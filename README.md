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

## What's next for WhiskerWatch
Future development plans include:
- Migrating from laptop camera to a dedicated IoT device
- Adding a mobile app for remote monitoring
- Implementing multiple container tracking
- Adding AI-powered consumption pattern analysis
- Expanding notification options (SMS, email, push notifications)
- Creating a web dashboard for historical data visualization