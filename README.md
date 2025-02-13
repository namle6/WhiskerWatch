# WhiskerWatch: Smart Cat Food Monitoring System

## Inspiration
As a busy cat parent, I often found myself forgetting to refill my cat's food container until it was completely empty. This would lead to last-minute store runs or, worse, a very unhappy feline friend. I realized that technology could help solve this common problem that many pet owners face, leading to the creation of WhiskerWatch.

## What it does
WhiskerWatch is an automated cat food monitoring system that:
- Captures daily images of the cat food container using a repurposed laptop camera
- Automatically uploads these images to an AWS S3 bucket
- Processes the images using AWS Lambda and Amazon Rekognition to determine food levels
- Triggers a phone call via Twilio API when food levels are critically low
- All infrastructure is managed through Infrastructure as Code using Terraform

## How we built it
The system architecture consists of several key components:
- Frontend: Python script running on an old laptop to capture and upload images
- Storage: AWS S3 bucket for image storage
- Processing: AWS Lambda function triggered by S3 uploads
- Analysis: AWS Rekognition for image processing and food level detection
- Notification: Twilio API integration for automated phone calls
- Infrastructure: Terraform configurations for AWS resource provisioning

## Challenges we ran into
The main technical challenges included:
- Debugging Lambda functions in the cloud environment proved more complex than local development
- Managing AWS IAM permissions and roles through Terraform

## Accomplishments that we're proud of
- Successfully implemented a fully automated monitoring system
- Created a scalable cloud architecture using AWS services
- Developed a practical solution to a real-world problem
- Implemented Infrastructure as Code practices with Terraform
- Achieved reliable food level detection using AWS Rekognition

## What we learned
- Cloud service integration and serverless architecture design
- Image processing and computer vision capabilities with AWS Rekognition
- Infrastructure as Code practices with Terraform
- AWS Lambda function development and debugging strategies
- The importance of error handling in distributed systems

## Installation and Setup

### Prerequisites
- Python 3.8 or higher
- AWS Account with appropriate permissions
- Twilio Account for phone call notifications
- Terraform installed

### AWS Setup
1. Create an AWS account if you don't have one
2. Configure AWS credentials locally:
   ```bash
   aws configure
   ```
3. Create an S3 bucket for storing images

### Local Setup
1. Clone the repository
   ```bash
   git clone https://github.com/namle6/WhiskerWatch.git
   cd WhiskerWatch
   ```

2. Create and activate Python virtual environment
   ```bash
   python -m venv venv
   # On Windows
   .\venv\Scripts\activate
   # On Unix or MacOS
   source venv/bin/activate
   ```

3. Install required packages
   ```bash
   pip install -r requirements.txt
   ```

4. Configure environment variables
   ```bash
   cp .env.example .env
   # Edit .env with your AWS and Twilio credentials
   ```

### Infrastructure Setup
1. Initialize Terraform
   ```bash
   cd terraform
   terraform init
   ```

2. Apply Terraform configuration
   ```bash
   terraform plan
   terraform apply
   ```

## Running the Application

### Start Image Capture
```bash
python capture_image.py
```
This script will:
- Take daily photos of your cat food container
- Upload images to S3
- Trigger Lambda function for processing

### Monitor Logs
You can monitor the application through:
- AWS CloudWatch logs
- Local application logs in the `logs` directory

### Stop the Application
To stop the image capture:
- Press Ctrl+C in the terminal running capture_image.py
- Or use task manager to end the Python process

## What's next for WhiskerWatch
Future development plans include:
- Migrating from laptop camera to a dedicated IoT device
- Adding a mobile app for remote monitoring
- Implementing multiple container tracking
- Adding AI-powered consumption pattern analysis
- Expanding notification options (SMS, email, push notifications)
- Creating a web dashboard for historical data visualization