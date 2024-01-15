import 'dart:async';
import 'dart:io';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Home/Quality/Gallerypage.dart';
import 'package:watalygold/Home/Quality/Result.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:image/image.dart' as img;

const modelname = "Mango-Color";

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final List<CameraDescription> camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  late File model;
  String? _deviceId;
  int selectedIndex = 0;
  FirebaseModelDownloader downloader = FirebaseModelDownloader.instance;
  final List _predictions = [];
  img.Image? inputImage;
  late String idResult;
  late List<String> ids;

  void _getDeviceId() async {
    //Recieving device id in the result
    String? result = await PlatformDeviceId.getDeviceId;
    setState(() {
      _deviceId = result;
    });
  }

  @override
  void initState() {
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    _getDeviceId();
    super.initState();
  }

  int selectedCamera = 0;
  List<File> capturedImages = [];

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      // Get a specific camera from the list of available camera.
      widget.camera[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  File? image;
  String imageUrl = '';

  bool isModelLoaded = false;

  Future Gallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      print(image?.path);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        capturedImages.add(imageTemporary);
      });

      String uniquename = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('image_analysis');

      Reference referenceImagetoUpload = referenceDirImages.child(uniquename);

      // แยก asynchronous operation ออกจาก setState
      Future uploadImageAndUpdateState() async {
        await referenceImagetoUpload.putFile(File(image.path));
        imageUrl = await referenceImagetoUpload.getDownloadURL();
        print(imageUrl);
        if (capturedImages.length == 4) {
          // สร้างชื่อที่ไม่ซ้ำกันจาก timestamp
          String uniquename = DateTime.now().millisecondsSinceEpoch.toString();

          // ชื่อของรูปภาพที่ต้องการ
          List<String> imageNames = [
            'Front_$uniquename',
            'Back_$uniquename',
            'Top_$uniquename',
            'Bottom_$uniquename',
          ];

          bool allImagesUploaded = true;

          List<String> imageuri = [];
          for (int i = 0; i < capturedImages.length; i++) {
            String imageUrl = await uploadImageToCloudStorage(
                capturedImages[i], imageNames[i]);
            imageuri.add(imageUrl);
          }

          String concatenatedString = imageuri.join(',');
          // File first = capturedImages[0];
          // ตัวแปรเพื่อตรวจสอบว่าทุกรูปถูกอัปโหลดหรือไม่

          var firebasefunctions =
              FirebaseFunctions.instanceFor(region: 'asia-southeast1');

          try {
            final result = await firebasefunctions
                .httpsCallable("add_images")
                .call({"imagename": concatenatedString, "ip": _deviceId});
            print(result.data);
            final Map<String, dynamic> data =
                Map<String, dynamic>.from(result.data);

            idResult = data['ID_Result'];
            ids = List<String>.from(data['IDs']);

            // นำค่า idResult และ ids ไปใช้ต่อได้ตามต้องการ
            print('ID_Result: $idResult');
            print('IDs: $ids');
          } on FirebaseFunctionsException catch (error) {
            debugPrint(
                'Functions error code: ${error.code}, details: ${error.details}, message: ${error.message}');
            rethrow;
          }

          // เช็คว่าอัปโหลดภาพทั้ง 4 ได้สำเร็จหรือไม่ ถ้าสำเร็จทั้งหมดให้กลับไปยังหน้าหลัก
          if (allImagesUploaded) {
            print(imageuri);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  ID_Result: idResult,
                  ID_Image: ids,
                  capturedImage: capturedImages.reversed.toList(),
                ),
              ),
            );
            // ResizeandRectangleImages();
          }
        }
        // loadModel();
        // เรียก setState เพื่ออัพเดท UI หลังจากได้ imageUrl แล้ว
        setState(() {
          // detectImage(imageTemporary);
        });
      }

      uploadImageAndUpdateState();
    } on PlatformException catch (e) {
      print('ผิดพลาด $e');
    }
  }

  Future<String> uploadImageToCloudStorage(
      File imageFile, String imageName) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('image_analysis/$imageName');

    // Set metadata to specify the content type
    final metadata = SettableMetadata(
        contentType: 'image/png'); // Adjust content type if needed

    // Upload file with metadata
    final uploadTask = storageRef.putFile(imageFile, metadata);
    final snapshot = await uploadTask;

    String downloadURL = await snapshot.ref.getDownloadURL();
    return imageName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarMains(name: 'วิเคราะห์คุณภาพ'),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Column(
        children: [
          Stack(
            children: [
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.
                    return CameraPreview(_controller);
                  } else {
                    // Otherwise, display a loading indicator.
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        onPressed: () {
                          if (widget.camera.length > 1) {
                            setState(() {
                              selectedCamera = selectedCamera == 0 ? 1 : 0;
                              initializeCamera(selectedCamera);
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('No secondary camera found'),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        },
                        icon: const Icon(
                          Icons.flash_on_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        onPressed: () {
                          if (widget.camera.length > 1) {
                            setState(() {
                              selectedCamera = selectedCamera == 0 ? 1 : 0;
                              initializeCamera(selectedCamera);
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('No secondary camera found'),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        },
                        icon: const Icon(
                          Icons.flip_camera_ios_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: WhiteColor, width: 4),
                            image: capturedImages.isNotEmpty
                                ? DecorationImage(
                                    image: FileImage(capturedImages[0]),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: WhiteColor, width: 4),
                            image: capturedImages.isNotEmpty &&
                                    capturedImages.length > 1
                                ? DecorationImage(
                                    image: FileImage(capturedImages[1]),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: WhiteColor, width: 4),
                            image: capturedImages.isNotEmpty &&
                                    capturedImages.length > 2
                                ? DecorationImage(
                                    image: FileImage(capturedImages[2]),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: WhiteColor, width: 4),
                            image: capturedImages.isNotEmpty &&
                                    capturedImages.length > 3
                                ? DecorationImage(
                                    image: FileImage(capturedImages[3]),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Gallery();
                  },
                  icon: const Icon(
                    Icons.image_rounded,
                    color: GPrimaryColor,
                    size: 40,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await _initializeControllerFuture;
                    var xFile = await _controller.takePicture();
                    setState(() {
                      capturedImages.add(File(xFile.path));
                    });
                    if (capturedImages.length == 4) {
                      // สร้างชื่อที่ไม่ซ้ำกันจาก timestamp
                      String uniquename =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      // ชื่อของรูปภาพที่ต้องการ
                      List<String> imageNames = [
                        'Front_$uniquename',
                        'Back_$uniquename',
                        'Top_$uniquename',
                        'Bottom_$uniquename',
                      ];

                      bool allImagesUploaded = true;

                      List<String> imageuri = [];
                      for (int i = 0; i < capturedImages.length; i++) {
                        String imageUrl = await uploadImageToCloudStorage(
                            capturedImages[i], imageNames[i]);
                        imageuri.add(imageUrl);
                      }

                      String concatenatedString = imageuri.join(',');
                      // File first = capturedImages[0];
                      // ตัวแปรเพื่อตรวจสอบว่าทุกรูปถูกอัปโหลดหรือไม่

                      var firebasefunctions = FirebaseFunctions.instanceFor(
                          region: 'asia-southeast1');

                      try {
                        final result = await firebasefunctions
                            .httpsCallable("add_images")
                            .call({
                          "imagename": concatenatedString,
                          "ip": _deviceId
                        });
                        print(result.data);
                        final Map<String, dynamic> data =
                            Map<String, dynamic>.from(result.data);

                        idResult = data['ID_Result'];
                        ids = List<String>.from(data['IDs']);

                        // นำค่า idResult และ ids ไปใช้ต่อได้ตามต้องการ
                        print('ID_Result: $idResult');
                        print('IDs: $ids');
                      } on FirebaseFunctionsException catch (error) {
                        debugPrint(
                            'Functions error code: ${error.code}, details: ${error.details}, message: ${error.message}');
                        rethrow;
                      }
                      // เช็คว่าอัปโหลดภาพทั้ง 4 ได้สำเร็จหรือไม่ ถ้าสำเร็จทั้งหมดให้กลับไปยังหน้าหลัก
                      if (allImagesUploaded) {
                        print(imageuri);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage(
                              ID_Result: idResult,
                              ID_Image: ids,
                              capturedImage: capturedImages.reversed.toList(),
                            ),
                          ),
                        );
                        // ResizeandRectangleImages();
                      }
                    }
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: GPrimaryColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (capturedImages.isEmpty) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryScreen(
                                images: capturedImages.reversed.toList())));
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: GPrimaryColor, width: 4),
                      image: capturedImages.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(capturedImages.last),
                              fit: BoxFit.cover)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
