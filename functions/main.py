# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

import os
import math
import io
import uuid
import firebase_admin
import numpy as np
import cv2
import matplotlib.pyplot as plt
import tensorflow as tf

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
def onrequestexample(req: https_fn.Request) -> https_fn.Response:
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
def addImages(req: https_fn.CallableRequest) -> any:
    """Take the text parameter passed to this HTTP endpoint and insert it into
    a new document in the messages collection."""
    # Grab the text parameter.
    db = firestore.Client()
    # ตรวจสอบ IP ของอุปกรณ์ที่ส่งคำขอเข้ามา
    ip_address = req.data["ip"]
    print(ip_address)
    # ค้นหาเอกสารในคอลเลกชัน User ที่มีฟิลด์ IP_add เท่ากับ IP ของอุปกรณ์ที่ส่งคำขอเข้ามา
    doc = db.collection("User").where("IP_add", "==", ip_address).get()

    # หากพบเอกสาร แสดงว่าอุปกรณ์นั้นเคยใช้งาน Functions นี้แล้ว
    if doc:
        ip_value = doc[0].get("IP_add")
    else:
        # เพิ่มเอกสารใหม่
        doc = db.collection('User').document(f'{ip_address}')
        doc.set({
        "IP_add": ip_address,
        "create_at": firestore.SERVER_TIMESTAMP,
        "update_at": firestore.SERVER_TIMESTAMP,
        "delete_at": firestore.SERVER_TIMESTAMP,
        })
        ip_value = ip_address   
    
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
    blob_list_url = []
    for identifier in url_list:
        # Fetch blob corresponding to the identifier
        blob = source_bucket.get_blob(f"{folder_prefix}/{identifier}")
        
        # Check if the blob is found and valid
        if blob is None:
            # Handle cases where the blob is not found or retrieval fails
            return https_fn.Response(f"Blob for identifier '{identifier}' not found or retrieval failed", status=404)
        blob_list_url.append(blob.public_url)
        blob_list.append(blob)
        
    print(blob_list_url)
    mango_blemishes_list = {}
    def mango_blemishes(processed_images) :
        for i, img in enumerate(processed_images):
            # แปลงภาพเป็นสีเทา
            gray_image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

            _, thresholded_image = cv2.threshold(gray_image, 120, 255, cv2.THRESH_BINARY_INV)

            # หา contours จากภาพ thresholded
            contours, _ = cv2.findContours(thresholded_image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

            # วาด contours บนภาพ
            cv2.drawContours(img, contours, -1, (0,255,0), 3)

            # คำนวณพื้นที่ของความบกพร่อง
            defect_area = np.sum(thresholded_image == 255)
            total_area = img.shape[0] * img.shape[1]

            # คำนวณเปอร์เซ็นต์ของความบกพร่อง 
            defect_percentage = (defect_area / total_area) * 100
            mango_blemishes_list[i] = defect_percentage
            # print(f'Percentage of defects in {preprocessed_images[i]}: {defect_percentage}%')
        return "Finish!!"
    
    brown_spot_percentage_list = {}
    def get_brown_spot_percentage(image_data) :
        for i, img in enumerate(image_data):
            # แปลงภาพเป็นโหมด HSV
            hsv_image = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

            # กำหนดช่วงสีของจุดสีน้ำตาล
            lower_brown = (15, 40, 40)
            upper_brown = (40, 255, 255)

            # ทำการแยกแยะจุดสีน้ำตาล
            brown_mask = cv2.inRange(hsv_image, lower_brown, upper_brown)

            # คำนวณพื้นที่ของจุดสีน้ำตาล
            brown_area = cv2.countNonZero(brown_mask)

            # คำนวณพื้นที่ทั้งหมดของภาพ
            image_area = image.shape[0] * image.shape[1]

            # คำนวณเปอร์เซ็นต์ของพื้นที่จุดสีน้ำตาล
            percentage = brown_area / image_area * 100
            brown_spot_percentage_list[i] = percentage
        return "Finish!!"
    
    def predict_mango_ripeness(image_data):
        # Load the TFLite model
        interpreter = tf.lite.Interpreter(model_path="./mango_color.tflite")
        interpreter.allocate_tensors()

        # Get input and output tensors information
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()

        # Prepare the input tensor
        input_tensor = np.expand_dims(image_data, axis=0)  # Add batch dimension
        input_tensor = input_tensor.astype(np.float32)
        interpreter.set_tensor(input_details[0]['index'], input_tensor)

        # Run inference
        interpreter.invoke()
        class_names = ['Not Ripe', 'Ripe']
        # Get output probabilities
        output_data = interpreter.get_tensor(output_details[0]['index'])
        predicted_class_index = np.argmax(output_data[0])
        predicted_class = class_names[predicted_class_index]
        print(predicted_class)
        print(output_data[0])
        # Determine the predicted class
        
        return predicted_class
    
    def Mango_weight(image):
        # Convert image to grayscale
        gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY).astype(np.uint8)

        # Apply thresholding to create a binary image
        _, thresh = cv2.threshold(gray_image, 128, 255, cv2.THRESH_BINARY)

        # Find contours
        contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        # Filter for the largest contour (the mango)
        largest_contour = max(contours, key=cv2.contourArea, default=0)

        # Find the bounding rectangle of the mango
        x, y, w, h = cv2.boundingRect(largest_contour)

        # Crop the image to the bounding rectangle
        cropped_image = image[y:y+h, x:x+w]

        # Calculate dimensions (height and width)
        mango_height = h
        mango_width = w

        pixels_per_cm = mango_height / 30  # Assuming mango height is the reference distance

        # Convert pixel values to centimeters
        mango_height_cm = mango_height / pixels_per_cm
        mango_width_cm = mango_width / pixels_per_cm

        # Calculate radius and volume
        radius = mango_height_cm / 2
        radius = radius / 100
        pi = np.pi
        volume = (4 / 3) * pi * (radius ** 3)

        # Assuming mango density in g/cm^3, calculate mass in grams
        mango_density = 0.98  # Example density value
        mango_mass_grams = mango_density * (mango_width_cm * mango_width_cm)

        return mango_height_cm, mango_width_cm, mango_mass_grams

    # Process images and call prediction function
    image_h, image_w = 64, 64

    def remove_background(image):
        # Convert the image to grayscale
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

        # Apply Canny edge detection
        edges = cv2.Canny(gray, 30, 100)

        # Find contours
        contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        # Create a mask to store the foreground
        mask = np.zeros_like(gray)

        # Fill the contours in the mask
        cv2.drawContours(mask, contours, -1, (255), thickness=cv2.FILLED)

        # Apply the mask to the original image
        result = cv2.bitwise_and(image, image, mask=mask)
        
        return result
    
    preprocessed_images = []
    for blob in blob_list:
        image_data = blob.download_as_bytes()
        image = np.frombuffer(image_data, dtype=np.uint8)
        image = cv2.imdecode(image, cv2.IMREAD_COLOR)
        image = cv2.resize(image, dsize=(image_h, image_w))
        preprocessed_images.append(image)
        
    # Call prediction function with preprocessed image
    
    predicted_result = predict_mango_ripeness(preprocessed_images[0])
    if predicted_result == "Not Ripe" :
        predicted_result = "Not_Yellow"
    else :
        predicted_result = "Yellow"
        
    imagemango = remove_background(preprocessed_images[0])
    Mango_weights = Mango_weight(imagemango)
    mango_height_cm, mango_width_cm, mango_mass_grams = Mango_weights
    mango_blemishe = mango_blemishes(preprocessed_images)
    max_mango_blemishe = max(mango_blemishes_list.values())
    brown_sport = get_brown_spot_percentage(preprocessed_images)
    total_blemishes = sum(brown_spot_percentage_list.values())
    number_of_blemishes = len(brown_spot_percentage_list)
    average_blemish = total_blemishes / number_of_blemishes
    
    
    result_mango = ""
    another_note = ""
    if (predicted_result == "Yellow" and mango_mass_grams >= 450 and max_mango_blemishe <= 2 and average_blemish <= 10 ) :
        result_mango = "ขั้นพิเศษ"
        another_note = "มะม่วงมีขนาดและรูปร่างสวยงาม สีมะม่วงเหลืองทองสวย"
    if (predicted_result == "Yellow" and 350 < mango_mass_grams <= 450 and max_mango_blemishe <= 4 and average_blemish <= 30 ) :
        result_mango = "ขั้นที่ 1"
        another_note = "มะม่วงมีขนาดและรูปร่างสวยงาม สีมะม่วงเหลืองทอง มีจุดตำหนิหรือจุดกระสีน้ำตาลเล็กน้อย"
    if (predicted_result == "Yellow" and 250 < mango_mass_grams <= 350 and max_mango_blemishe <= 5 and average_blemish <= 40 ) :
        result_mango = "ขั้นที่ 2"
        another_note = "มะม่วงมีขนาดและรูปร่างผิดปกติเล็กน้อย สีมะม่วงเหลืองทอง มีจุดตำหนิหรือจุดกระสีน้ำตาลปานกลาง"
    else :
        result_mango = "ไม่เข้าข่าย"
        another_note = "มะม่วงมีขนาดและรูปร่างผิดปกติปานกลางถึงมาก สีมะม่วงไม่เหลืองทองสวย มีจุดตำหนิหรือจุดกระสีน้ำตาลมาก"
    ids = []
    status = ["Front", "Back", "Top", "Bottom"]
    print(type(mango_blemishes_list))
    print(len(url_list))
    print(len(blob_list_url))
    for i in range(len(url_list)):
        doc_ref = db.collection('Image').document(f'{url_list[i]}-{i}')
        doc_ref.set({
            "image_name": url_list[i],
            "image_url": blob_list_url[i],
            "mango_length": mango_height_cm,
            "mango_width": mango_width_cm,
            "mango_weight": mango_mass_grams,
            "flaws_percent": mango_blemishes_list[i],
            "brown_spot": brown_spot_percentage_list[i],
            "color": predicted_result,
            "img_status": status[i],
            "create_at": firestore.SERVER_TIMESTAMP,
            "update_at": firestore.SERVER_TIMESTAMP,
            "delete_at": firestore.SERVER_TIMESTAMP,
        })
        document_id = doc_ref.id
        ids.append(document_id)
        
    result_collection_ref = db.collection("Result")
    result_data = {
        "user": {
            "user_id": ip_value
        },
        "Image_result": [],
        "Quality": result_mango,
        "Length": mango_height_cm,
        "Width": mango_width_cm,
        "Weight": mango_mass_grams,
        "Another_note": another_note,
        "create_at": firestore.SERVER_TIMESTAMP,
        "update_at": firestore.SERVER_TIMESTAMP,
        "delete_at": firestore.SERVER_TIMESTAMP
    }

    # สร้าง Array ของ Image_result โดยใส่ IDs จาก Collection "Image"
    for image_id in ids:
        result_data["Image_result"].append({"image_id": image_id})
        
    result_doc_ref = result_collection_ref.document()  # No ID specified
    result_doc_ref.set(result_data)

    # Get ID of the newly created document
    result_doc_id = result_doc_ref.id

    print(result_doc_id)
    
    # หากไม่พบเอกสาร แสดงว่าอุปกรณ์นั้นไม่เคยใช้งาน Functions นี้มาก่อน
    
    return {"message": "Message with IDs added", "IDs": ids , "ID_Result":result_doc_id}
