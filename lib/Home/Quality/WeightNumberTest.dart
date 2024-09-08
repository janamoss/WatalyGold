import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:screenshot/screenshot.dart';
import 'package:watalygold/Home/Quality/result_screen.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Home/Quality/Gallerypage.dart';
import 'package:watalygold/Home/Quality/Result.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogHowtoUse.dart';

class WeightNumber extends StatefulWidget {
  final List<CameraDescription> camera;
  const WeightNumber({
    super.key,
    required this.camera,
  });

  @override
  State<WeightNumber> createState() => _WeightNumberState();
}

class _WeightNumberState extends State<WeightNumber> {
  late tfl.Interpreter _interpreter;
  dynamic _probability = 0;
  List<String>? _labels;
  String? result;
  final _screenshotController = ScreenshotController();
  final ImagePicker picker = ImagePicker();
  Timer? _lightMeterTimer;
  bool _isProcessing = false;
  GlobalKey containerKey = GlobalKey();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late File model;
  String? _deviceId;
  int selectedIndex = 0;
  FirebaseModelDownloader downloader = FirebaseModelDownloader.instance;
  final List _predictions = [];
  late String idResult;
  late List<String> ids;

  late bool checkhowtouse;

  

  @override
  void initState() {
    super.initState();
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    // loadModel();
  }

  // Future<void> loadModel() async {
  //   try {
  //     _interpreter =
  //         await tfl.Interpreter.fromAsset('assets/model_float16.tflite');
  //   } catch (e) {
  //     print("Error loading model: $e");
  //   }
  // }

  int selectedCamera = 0;
  List<File> capturedImages = [];

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
        // Get a specific camera from the list of available camera.
        widget.camera[cameraIndex],
        // Define the resolution to use.
        ResolutionPreset.max, // new resolution
        enableAudio: false);

    // Initialize the controller
    _initializeControllerFuture = _controller.initialize();

    // Wait for the initialization to complete
    try {
      await _initializeControllerFuture;

      // Now that initialization is complete, start the image stream
      if (_controller != null) {
        await _controller!.startImageStream(_processImage);
        _startLightMeter();
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      // Handle the error appropriately
    }
  }

  void _startLightMeter() {
    _lightMeterTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _isProcessing = true;
    });
  }

  void _processImage(CameraImage image) {
    if (_isProcessing) {
      double averageBrightness = _calculateAverageBrightness(image);
      debugPrint('Average Brightness: $averageBrightness');
      _isProcessing = false;
    }
  }

  double _calculateAverageBrightness(CameraImage image) {
    var bytes = image.planes[0].bytes;
    int total = 0;
    // เพื่อประสิทธิภาพ เราจะสุ่มตัวอย่างเพียงบางพิกเซล
    for (int i = 0; i < bytes.length; i += 10) {
      total += bytes[i];
    }
    return total / (bytes.length / 10);
  }

  @override
  void dispose() {
    // _lightMeterTimer?.cancel();
    // _controller.stopImageStream();
    _controller.dispose();
    super.dispose();
  }

  File? image;
  String imageUrl = '';

  Future Gallery() async {
    try {
      final image = await picker.pickMultiImage(imageQuality: 50, limit: 4);
      final List<String> ImagepathList = [];
      // print(image?.path);
      // if (image == null) return;
      // final imageTemporary = File(image.path);
      setState(() {
        for (int i = 0; i < image.length; i++) {
          ImagepathList.add(image[i].path);
        }
        for (int i = 0; i < ImagepathList.length; i++) {
          capturedImages.add(File(ImagepathList[i]));
        }
      });
    } on PlatformException catch (e) {
      stdout.writeln('ผิดพลาด $e');
    }
  }

  late int flashstatus = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const AppbarMains(name: 'น้ำหนักมะม่วง'),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                SizedBox(
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (_controller == null ||
                          !_controller!.value.isInitialized) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // หรือ loading indicator
                      }
                      return SizedBox(
                          width: size.width,
                          height: size.height * 0.8,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                                width: size
                                    .width, // the actual width is not important here
                                child: CameraPreview(_controller)),
                          ));
                      // if (snapshot.connectionState == ConnectionState.done) {
                      //   // If the Future is complete, display the preview.
                      // } else {
                      //   // Otherwise, display a loading indicator.
                      // }
                    },
                  ),
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
                              horizontal: 10, vertical: 10),
                          onPressed: () {
                            if (widget.camera.length > 1) {
                              setState(() {
                                if (flashstatus == 0) {
                                  _controller.setFlashMode(FlashMode.torch);
                                  flashstatus = 1;
                                } else {
                                  _controller.setFlashMode(FlashMode.off);
                                  flashstatus = 0;
                                }
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
                              horizontal: 10, vertical: 10),
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
                  left: MediaQuery.of(context).size.width *
                      0.1, // 10% from the left
                  top: MediaQuery.of(context).size.height *
                      0.3, // 30% from the top
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.8, // 80% of screen width
                    height: MediaQuery.of(context).size.height *
                        0.1, // 10% of screen height
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 85),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: _pickImage,
                                // onPressed: () {
                                //   Gallery();
                                // },
                                icon: const Icon(
                                  Icons.image_rounded,
                                  color: GPrimaryColor,
                                  size: 40,
                                ),
                              ),
                              const Text(
                                "รูปภาพ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: GPrimaryColor, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () => _captureAndProcess(),
                            // onTap: () async {
                            //   await _initializeControllerFuture;
                            //   var xFile = await _controller.takePicture();
                            //   setState(() {
                            //     capturedImages.add(File(xFile.path));
                            //   });
                            // },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: GPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog_HowtoUse();
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.help_outline_rounded,
                                  color: GPrimaryColor,
                                  size: 40,
                                ),
                              ),
                              const Text(
                                "คู่มือการถ่ายภาพ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: GPrimaryColor, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndProcess() async {
    try {
      final XFile image = await _controller.takePicture();
      await _cropAndOCR(image);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _cropAndOCR(XFile image) async {
    try {
      final File imageFile = File(image.path);
      final img.Image? fullImage =
          img.decodeImage(await imageFile.readAsBytes());

      if (fullImage == null) {
        throw Exception('ไม่สามารถอ่านภาพได้');
      }
      // Proportional position and size of the frame
      final double frameLeftPercent = 0.1; // 10% from the left
      final double frameTopPercent = 0.5; // 30% from the top
      final double frameWidthPercent = 0.8; // 80% of screen width
      final double frameHeightPercent = 0.1; // 10% of screen height

      // Calculate the position and size of the cropping area
      final int cropX = (frameLeftPercent * fullImage.width).round();
      final int cropY = (frameTopPercent * fullImage.height).round();
      final int cropWidth = (frameWidthPercent * fullImage.width).round();
      final int cropHeight = (frameHeightPercent * fullImage.height).round();
      print(fullImage.width);
      print(fullImage.height);
      print(cropX);
      print(cropY);
      print(cropWidth);
      print(cropHeight);

      // Crop the image
      final img.Image croppedImage = img.copyCrop(
        fullImage,
        x: cropX,
        y: cropY,
        width: cropWidth,
        height: cropHeight,
      );

      // Save the cropped image to a temporary file
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final File croppedFile = File('$tempPath/cropped_image.png')
        ..writeAsBytesSync(img.encodePng(croppedImage));

      // Perform OCR on the cropped image
      final inputImage = InputImage.fromFile(croppedFile);
      final recognizedText = await textRecognizer.processImage(inputImage);
      debugPrint("recognizedText.text ${recognizedText.text}");
      final String numbersOnly = _extractNumbers(recognizedText.text);
      debugPrint("numbersOnly $numbersOnly");

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ResultScreen(
            text: numbersOnly,
            imgs: croppedImage,
          ),
        ),
      );
    } catch (e) {
      print('Error processing image: $e');
    }
  }

  final textRecognizer = TextRecognizer();
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);

      // แปลงภาพและปรับขนาดก่อน OCR
      final processedImage = await _preprocessImage(file);

      // OCR
      final inputImage = InputImage.fromFile(processedImage);
      final recognizedText = await textRecognizer.processImage(inputImage);
      debugPrint("recognizedText.text ${recognizedText}");

      final String numbersOnly = _extractNumbers(recognizedText.text);

      debugPrint("numbersOnly ${numbersOnly}");
      debugPrint(numbersOnly);
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => ResultScreen(
      //       text: numbersOnly,
      //       img: processedImage, // ส่งภาพไปยัง ResultScreen
      //     ),
      //   ),
      // );
    }
  }

  String _extractNumbers(String text) {
    return text.replaceAll(RegExp(r'[^0-9.]'), '').trim();
  }

  Future<File> _preprocessImage(File imageFile) async {
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage == null) return imageFile;
    // แปลงภาพเป็น grayscale
    // final grayscaleImage = img.grayscale(originalImage);
    // ปรับแสงและความคม (เพิ่ม contrast, brightness)
    // final contrastImage = img.adjustColor(originalImage, contrast: 1, brightness:);
    // ทำให้ภาพเบลอเล็กน้อยเพื่อให้เส้นขอบอ่อนลง (ถ้าได้ผลดี ให้เพิ่ม sharpen)
    // final sharpenedImage = img.adjustColor(contrastImage, contrast: 2);
    // บันทึกภาพใหม่ลงในไฟล์ชั่วคราว
    final processedFile = File(imageFile.path)
      ..writeAsBytesSync(img.encodeJpg(originalImage));

    return processedFile;
  }

  // Widget screenshot() {
  //   return Screenshot(
  //     controller: _screenshotController,
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           left: 50,
  //           top: 250,
  //           child: Container(
  //             width: 300,
  //             height: 100,
  //             decoration: BoxDecoration(
  //               border: Border.all(color: Colors.white, width: 3),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
