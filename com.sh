#!/bin/bash

# Deploy the YouTube Comment Extractor app with Docker, handling errors

# Function to clone the YouTube Comment Extractor app code
code_clone() {
    echo "Cloning the YouTube Comment Extractor app..."
    if [ -d "YouTube-Comment-Extractor" ]; then
        echo "The code directory already exists. Skipping clone."
    else
        git clone https://github.com/ankulmaurya88/YouTube-Comment-Extractor.git || {
            echo "Failed to clone the code."
            return 1
        }
    fi
}

# Function to install required dependencies
install_requirements() {
    echo "Installing dependencies..."
    sudo apt-get update && sudo apt-get install -y docker.io nginx docker-compose || {
        echo "Failed to install dependencies."
        return 1
    }
}

# Function to perform required Docker setup and restarts
required_restarts() {
    echo "Performing required restarts..."
    sudo chown "$USER" /var/run/docker.sock || {
        echo "Failed to change ownership of docker.sock."
        return 1
    }

    # Optional: enable and restart services if needed
    # sudo systemctl enable docker
    # sudo systemctl enable nginx
    # sudo systemctl restart docker
}

# Function to build and deploy the YouTube Comment Extractor app
deploy() {
    echo "Building and deploying the YouTube Comment Extractor app..."

    docker-compose down || {
        echo "Failed to stop existing containers."
        return 1
    }

    docker-compose up --build -d || {
        echo "Failed to build and deploy the app."
        return 1
    }

    # If it's a Django app, run migrations and collect static files
    if [ -f "manage.py" ]; then
        docker-compose exec web python manage.py migrate || {
            echo "Failed to run migrations."
            return 1
        }

        docker-compose exec web python manage.py collectstatic --noinput || {
            echo "Failed to collect static files."
            return 1
        }
    fi
}

# -------- Main Deployment Script --------

echo "********** DEPLOYMENT STARTED *********"

# Clone the repo
code_clone

# Move into the project directory
cd YouTube-Comment-Extractor || {
    echo "Failed to enter the project directory. Exiting..."
    exit 1
}

# Install dependencies
if ! install_requirements; then
    echo "Dependencies installation failed. Exiting..."
    exit 1
fi

# Perform Docker & nginx restarts if needed
if ! required_restarts; then
    echo "Required restarts failed. Exiting..."
    exit 1
fi

# Run Docker build and deploy
if ! deploy; then
    echo "Deployment failed. Mailing the admin..."
    # You can add sendmail or curl-based webhook/email alert here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"




