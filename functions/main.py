# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

import os
import uuid

from google.cloud import storage
from firebase_functions import https_fn
from firebase_admin import initialize_app

initialize_app()
# @https_fn.on_request()
# def process_image(req: https_fn.Request) -> https_fn.Response:
#     # Access image data from request (e.g., from request body or URL parameter)
#     image_data = req.get_data()  # Example assuming image data is in request body

#     # Perform image processing using your preferred library (e.g., OpenCV, Pillow)
#     processed_image = process_image_using_library(image_data)

#     # Return the processed image in the response
#     return https_fn.Response(processed_image, status=200, content_type="image/jpeg")  # Example for JPEG

@https_fn.on_request()
def on_request_example(req: https_fn.Request) -> https_fn.Response:
    # Initialize the Cloud Storage client.
    storage_client = storage.Client()

    # The Cloud Functions runtime environment has a default limit of
    # 256 MB of memory. Set this value lower if you expect your functions
    # to use a lot of memory.
    os.environ['FUNCTIONS_FRAMEWORK_MAX_MEMORY_MB'] = '256'

    # The Cloud Functions runtime environment has a default timeout of 60
    # seconds. Set this value higher if your functions take longer than that to
    # complete.
    os.environ['FUNCTIONS_TIMEOUT_SECONDS'] = '180'

    # This is the name of the Cloud Storage bucket that will store the images.
    bucket_name = 'watalygold-imageanalysis'

    # This is the name of the Cloud Storage subdirectory in which the images will be stored.
    subdirectory_name = 'image_analysis'

    # This is the maximum number of images that can be uploaded in a single request.
    max_images_per_request = 4

    def on_request(req):
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
        subdirectory = bucket.subdirectory(subdirectory_name)

        # Get the image names.
        image_names = []
        for image in images:
            image_names.append(image.filename)

        # Upload the images to Cloud Storage.
        for image in images:
            blob = subdirectory.blob(f'{request_id}/{image.filename}')
            blob.upload_from_string(image.stream.getvalue())

        # Return a success message.
        return 'Images uploaded successfully.', 200