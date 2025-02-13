import cv2
import boto3
import schedule
import time
from datetime import datetime
import os

BUCKET_NAME = 'food-monitoring-images'

def capture_and_upload():
    try:
        cap = cv2.VideoCapture(0)
        
        if not cap.isOpened():
            print("error")
            return

        time.sleep(2)
        
        ret, frame = cap.read()
        
        if ret:
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            local_filename = f'cat_food_{timestamp}.jpg'
            
            cv2.imwrite(local_filename, frame)
            print(f"Image captured: {local_filename}")
            
            s3_client = boto3.client('s3')
            s3_client.upload_file(local_filename, BUCKET_NAME, local_filename)
            print(f"Image uploaded to s3://{BUCKET_NAME}/{local_filename}")
            
            os.remove(local_filename)
            
        cap.release()
        
    except Exception as e:
        print(f"Error: {str(e)}")

def main():
    schedule.every().day.at("09:00").do(capture_and_upload)
    schedule.every().day.at("21:00").do(capture_and_upload)
    
    print("Cat food monitoring script started")
    print(f"Will capture images daily at: 9:00 AM and 9:00 PM")
    print("Images will be uploaded to: food-monitoring-images bucket")
    print("Press Ctrl+C to stop")
    
    print("Performing initial capture...")
    capture_and_upload()
    
    try:
        while True:
            schedule.run_pending()
            time.sleep(60)
    except KeyboardInterrupt:
        print("\nMonitoring stopped by user")

if __name__ == "__main__":
    main()