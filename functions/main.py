# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

import os
import uuid
import firebase_admin
import numpy as np
import cv2
import matplotlib.pyplot as plt
import tensorflow as tf

from PIL import Image
from google.cloud import storage
from firebase_functions import https_fn, options
from firebase_admin import firestore,credentials

import urllib.parse

# firebaseConfig = {
#   apiKey: "AIzaSyBmkAwwEYIrdEyZ_FOkm3t4nDvIDvS1OK0",
#   authDomain: "watalygold.firebaseapp.com",
#   databaseURL: "https://watalygold-default-rtdb.firebaseio.com",
#   projectId: "watalygold",
#   storageBucket: "watalygold.appspot.com",
#   messagingSenderId: "692047570487",
#   appId: "1:692047570487:web:206c3096e4156fb15281b2",
#   measurementId: "G-8XEDQLLKFB"
# }

cred = credentials.Certificate("./watalygold-firebase-adminsdk-e02wr-cadc46418d.json")
firebase_admin.initialize_app(cred)

options.set_global_options(
    memory=options.MemoryOption.MB_128,
)

@https_fn.on_call(
    cors=options.CorsOptions(
        cors_origins=[r"firebase\.com$", r"https://flutter\.com"],
        cors_methods=["get", "post"],
    )
)
def on_request_example(req: https_fn.Request) -> https_fn.Response:
    storage_client = storage.Client()
    # This is the name of the Cloud Storage bucket that will store the images.
    bucket_name = 'watalygold-imageanalysis'

    # This is the name of the Cloud Storage subdirectory in which the images will be stored.
    subdirectory_name = 'image_analysis'

    # This is the maximum number of images that can be uploaded in a single request.
    max_images_per_request = 4
    """Handles an HTTP request to upload multiple images to Cloud Storage."""

    # Get the images from the request.
    images = req.files.getlist('images')
    # Check if the number of images is within the maximum allowed.
    if len(images) > max_images_per_request:
        return 'Too many images. The maximum number of images that can be uploaded in a single request is {}.'.format(max_images_per_request), 400

    # Create a unique identifier for the request.
    request_id = str(uuid.uuid4())
    # Create a directory in Cloud Storage to store the images.
    
    bucket = storage_client.bucket(bucket_name)
    # subdirectory = bucket.subdirectory(subdirectory_name)
    
    # Get the image names.
    image_names = []
    for image in images:
        image_names.append(image.filename)

    # Upload the images to Cloud Storage.
    for image in images:
        full_path = f"{subdirectory_name}/{request_id}/{image.filename}_{request_id}"
        blob = bucket.blob(full_path)
        blob.upload_from_file(image.stream, content_type=image.content_type)

    # Return a success message.
    image.stream.close()  # Close the stream after upload
    print(req.files)
    return 'Images uploaded successfully.', 200

@https_fn.on_call(
    cors=options.CorsOptions(
        cors_origins=[r"firebase\.com$", r"https://flutter\.com"],
        cors_methods=["get", "post"],
    ),
    region=options.SupportedRegion('asia-southeast1')
)
def add_images(req: https_fn.CallableRequest) -> any:
    """Take the text parameter passed to this HTTP endpoint and insert it into
    a new document in the messages collection."""
    # Grab the text parameter.
    request_data = req.data["imagename"]
    if request_data is None:
        return https_fn.Response("No text parameter provided", status=400)
    # urls = urls.replace(', ', ',')
    decoded_url = urllib.parse.unquote(request_data)
    url_list = [decoded_url.strip() for decoded_url in decoded_url.split(',')]
    if len(url_list) != 4:
        return https_fn.Response("Exactly 4 URLs are required", status=400)  
    # print(url_list)
    print(decoded_url)
    
    storage_client = storage.Client()
    bucket_name = "watalygold.appspot.com"
    
    folder_prefix = 'image_analysis'  # เปลี่ยนเป็นชื่อโฟลเดอร์ของคุณที่ต้องการ
    
    # Get bucket และ list blobs ด้วย prefix
    source_bucket = storage_client.get_bucket(bucket_name)
    
    blob_list = []
    for identifier in url_list:
        # Fetch blob corresponding to the identifier
        blob = source_bucket.get_blob(f"{folder_prefix}/{identifier}")
        
        # Check if the blob is found and valid
        if blob is None:
            # Handle cases where the blob is not found or retrieval fails
            return https_fn.Response(f"Blob for identifier '{identifier}' not found or retrieval failed", status=404)
        
        blob_list.append(blob)
        
    predict_mango_ripeness(blob_list[0])
    
    def predict_mango_ripeness(blob_list):
        # Load the TFLite model
        interpreter = tflite.Interpreter(model_path="mango_color.tflite")
        interpreter.allocate_tensors()

        # Get input and output tensors information
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()

        # Process the first image
        first_blob_bytes = blob_list[0].download_as_bytes()

        # Preprocess the image according to model requirements (if needed)
        # ... (e.g., resize, normalize, etc.) ...

        # Prepare the input tensor
        input_tensor = np.array(first_blob_bytes, dtype=np.float32)  # Assuming model expects a float32 array
        interpreter.set_tensor(input_details[0]['index'], input_tensor)

        # Run inference
        interpreter.invoke()

        # Get output probabilities
        output_data = interpreter.get_tensor(output_details[0]['index'])
        ripe_probability = output_data[0]  # Assuming the first output represents "Ripe"
        not_ripe_probability = output_data[1]  # Assuming the second output represents "Not Ripe"

        # Determine the predicted class
        predicted_class = "Ripe" if ripe_probability > not_ripe_probability else "Not Ripe"

        return predicted_class

        # Download the blob and process it (this part may require modification based on your image processing requirements)
        # image = np.asarray(bytearray(blob.download_as_string()), dtype="uint8")
        # img = cv2.imdecode(image, cv2.COLOR_BGR2BGR555)
        
        # Display or perform further processing with the image (for example, showing using matplotlib)
        # plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        # plt.title(f"Image: {identifier}")
        # plt.show()
    
    return {"message": "Message with ID added."}
