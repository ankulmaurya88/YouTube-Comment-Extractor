
FROM python:3.10 

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies


# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the entire application into the container
COPY . .



# Expose the port the app will run on
EXPOSE 8000

# Command to run the application in development
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
