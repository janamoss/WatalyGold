import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:screenshot/screenshot.dart';
import 'package:watalygold/Home/Quality/result_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:async';
import 'dart:io';
// import 'dart:math';
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
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Home/Quality/Gallerypage.dart';
import 'package:watalygold/Home/Quality/Result.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogHowtoUse.dart';
import 'package:image/image.dart' as img;

class WeightNumberTest extends StatefulWidget {
  final List<CameraDescription> camera;
  const WeightNumberTest({
    super.key,
    required this.camera,
  });

  @override
  State<WeightNumberTest> createState() => _WeightNumberState();
}

class _WeightNumberState extends State<WeightNumberTest> {
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
  List<int> countTokens = [];
  late bool checkhowtouse;

  @override
  void initState() {
    super.initState();
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    // addTokenToFirebase(countTokens);
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
                          height: size.height * 1,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                                width:
                                    100, // the actual width is not important here
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
                  left: MediaQuery.of(context).size.width * 0.15,
                  top: MediaQuery.of(context).size.height * 0.3,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.12,
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
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    // _processedImage != null
                    //     ? Image.file(_processedImage!) // แสดงภาพที่ประมวลผลแล้ว
                    //     : Text('No image selected.'),
                    // const Padding(
                    //   padding: EdgeInsets.only(bottom: 10),
                    //   child: Text(
                    //     "พยายามให้ลูกมะม่วงของคุณ\nอยู่ภายในระยะกรอบสีขาว",
                    //     maxLines: 3,
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(color: GPrimaryColor),
                    //   ),
                    // ),
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
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndProcess() async {
    try {
      final XFile image = await _controller.takePicture();
      setState(() {});
      await _cropAndOCR(image);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _cropAndOCR(XFile image) async {
    final File imageFile = File(image.path);
    final img.Image? fullImage = img.decodeImage(await imageFile.readAsBytes());

    if (fullImage == null) {
      throw Exception('ไม่สามารถอ่านภาพได้');
    }

    final double frameLeftPercent = 0.15;
    final double frameTopPercent = 0.5;
    final double frameWidthPercent = 0.7;
    final double frameHeightPercent = 0.12;

    final int cropX = (frameLeftPercent * fullImage.width).round();
    final int cropY = (frameTopPercent * fullImage.height).round();
    final int cropWidth = (frameWidthPercent * fullImage.width).round();
    final int cropHeight =
        (frameHeightPercent * fullImage.height * 1.5).round();

    print(fullImage.width);
    print(fullImage.height);
    print(cropX);
    print(cropY);
    print(cropWidth);
    print(cropHeight);

    final img.Image croppedImage = img.copyCrop(
      fullImage,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final File croppedFile = File('$tempPath/cropped_image.png')
      ..writeAsBytesSync(img.encodePng(croppedImage));

    final processedImage = await _preprocessImageblackandwhite(croppedFile);

    // Perform OCR on the cropped image
    // final inputImage = InputImage.fromFile(croppedFile);
    // final recognizedText = await textRecognizer.processImage(inputImage);
    // debugPrint("recognizedText.text ${recognizedText.text}");
    // final String numbersOnly = _extractNumbersOCR(recognizedText.text);
    // debugPrint("numbersOnly $numbersOnly");

    // Integrate Gemini
    final gemini = Gemini.instance;
    gemini.textAndImage(
      text:
          """The image shows a digital scale display with digital numbers and decimal points. 
            There is a weight attached to the image, with a white background and black numbers. 
            However, if you cannot find the numbers or there is no digital scale display, 
            you would answer "ไม่มีตัวเลขหรือตาชั่งในภาพนี้" 
            I would like you to read the weight on the scale, for example, 325.25 g .""",
      // text:
      //     "From the picture is the digital weighing scale screen. Can you please read the numbers on the scale screen, for example 33.3 g",
      images: [processedImage.readAsBytesSync()],
    ).then((value) {
      final geminiText = value?.content?.parts?.last.text ?? '';
      // final extractedNumbers = _extractNumbersGeminiText(geminiText);
      debugPrint("Gemini analysis: $geminiText");
      // debugPrint("Gemini extractedNumbers: $extractedNumbers");

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ResultScreen(
            // text: "$numbersOnly\n$geminiText",
            text: "$geminiText",
            img: processedImage,
          ),
        ),
      );
    }).catchError((error) {
      if (error is HttpException) {
        print('Error connecting to the server');
      } else if (error is FormatException) {
        print('Invalid data format');
      } else {
        print('An unexpected error occurred: $error');
      }
    });
  }

  final textRecognizer = TextRecognizer();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);

      final img.Image originalImage =
          img.decodeImage(await file.readAsBytes())!;

      // final processedImageHSV = await preprocessImagesHSV(originalImage);
      // final processedImageFile = File('${file.path}_processed.png')
      //   ..writeAsBytesSync(img.encodePng(processedImageHSV));

      final processedImageBW = await _preprocessImageblackandwhite(file);

      final inputImage = InputImage.fromFile(processedImageBW);
      final recognizedText = await textRecognizer.processImage(inputImage);
      debugPrint("recognizedText.text ${recognizedText}");
      final String numbersOnly = _extractNumbersOCR(recognizedText.text);
      debugPrint("numbersOnly ${numbersOnly}");

      // Integrate Gemini
      final gemini = Gemini.instance;

      gemini.textAndImage(
          text:
              """The image shows a digital scale display with digital numbers and decimal points. 
            There is a weight attached to the image, with a white background and black numbers. 
            However, if you cannot find the numbers or there is no digital scale display, 
            you would answer "ไม่มีตัวเลขหรือตาชั่งในภาพนี้" 
            I would like you to read the weight on the scale, for example, 325.25 g .""",
          // text:
          //     "The picture shows a digital weighing scale screen with digital numbers and a decimal point. There is a unit of weight attached to the image with a white background and black numbers. I'd like you to read the weight on the scale, for example 325.25 g",
          images: [
            processedImageBW.readAsBytesSync(),
          ]

          // images: [
          //   file.readAsBytesSync(),
          // ]
          //  images: [file.readAsBytesSync(),]
          // images: [processedImageFile.readAsBytesSync(),processedImageBW.readAsBytesSync(),file.readAsBytesSync()],

          ).then((value) {
        final geminiText = value?.content?.parts?.last.text ?? '';
        final extractedNumbers = _extractNumbersGeminiText(geminiText);
        final promt =
            """The image shows a digital scale display with digital numbers and decimal points. 
            There is a weight attached to the image, with a white background and black numbers. 
            However, if you cannot find the numbers or there is no digital scale display, 
            you would answer "ไม่มีตัวเลขหรือตาชั่งในภาพนี้" 
            I would like you to read the weight on the scale, for example, 325.25 g .""";

        // gemini
        //     .countTokens(
        //       promt,
        //     )
        //     .then((value) => print("countTokens ${value}"))

        //     /// output like: `6` or `null`
        //     .catchError((e) => log('countTokens', error: e));

// final tokenCount = await model.countTokens([
//   Content.multi([prompt, ...imageParts])
// ]);
// print('Token count: ${tokenCount.totalTokens}');

        gemini.countTokens(promt).then((value) {
          // เก็บค่า value ลงในตัวแปร countTokens
          if (value != null) {
            countTokens.add(value); // เก็บค่าลงใน List
          }
          print("countTokens: ${value}");
          print("countTokens: ${countTokens}");
          // addTokenToFirebase(countTokens);
        }).catchError((e) => log('countTokens', error: e));

        // นับจำนวนโทเค็นที่นี่
        // final tokenCount = Gemini.instance
        //     .countTokens("Write a story about a magic backpack.");
        // print('จำนวนโทเค็น: $tokenCount');

        debugPrint("Gemini analysis: $geminiText");
        debugPrint("Gemini extractedNumbers: $extractedNumbers");

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ResultScreen(
              // text: "$numbersOnly\n$geminiText",
              text: "$geminiText",
              img: file,
            ),
          ),
        );
      }).catchError((error) {
        if (error is HttpException) {
          print('Error connecting to the server');
        } else if (error is FormatException) {
          print('Invalid data format');
        } else {
          print('An unexpected error occurred: $error');
        }
      });
    }
  }

  // Future<String> addToken(Map<String, dynamic> tokenMap, String id) async {
  //   await FirebaseFirestore.instance.collection("Token").doc(id).set(tokenMap);
  //   return id;
  // }

  // Future<void> addTokenToFirebase(List<int> countTokens) async {
  //   String id = const Uuid().v4().substring(0, 10);
  //   Map<String, dynamic> tokenMap = {
  //     "NumToken": countTokens,
  //   };
  //   try {
  //     await addToken(tokenMap, id);
  //     print("Token added to Firestore with ID: $id");
  //   } catch (e) {
  //     print("Error adding token to Firestore: $e");
  //   }
  // }

  String _extractNumbersOCR(String text) {
    return text.replaceAll(RegExp(r'[^0-9.g]'), '').trim();
  }

  String? _extractNumbersGeminiText(String response) {
    final regex = RegExp(r"(\d+(\.\d*)?)\s([a-zA-Z]+)");
    final match = regex.firstMatch(response);
    if (match != null) {
      final number = match.group(1);
      final unit = match.group(3);
      return "$number $unit";
    }
    return "รูปที่คุณถ่ายไม่ใช่เครื่องชั่งน้ำหนัก";
  }

  // hsv ปรับสีน้ำเงินพื้นหลัง
  img.Image preprocessImagesHSV(img.Image image) {
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        var pixel = image.getPixel(x, y);
        // แปลง pixel เป็น Color
        var color = Color.fromARGB(
            pixel.a.toInt(), pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
        var hsv = HSVColor.fromColor(color);
        if (hsv.hue >= 210 && hsv.hue <= 240 && hsv.value > 0.5) {
          // ลบพื้นที่สีน้ำเงินออก
          // hsv = HSVColor.fromAHSV(0.0, hsv.hue, 0.0, 0.0);
          hsv = HSVColor.fromAHSV(1, 0.0, 0.0, 1.0); //สีขาว
        }
        // hue สีน้ำเงิน 180-240
        // if (hsv.hue >= 210 && hsv.hue <= 270 && hsv.value > 0.5) {
        //   // เพิ่มความสว่างและลดความอิ่มตัว
        //   // hsv = HSVColor.fromAHSV(0.0, hsv.hue, 0.0, 1);
        //   hsv = HSVColor.fromAHSV(1.0, 0.0, 0.0, 1);
        // } else if (hsv.value < 0.3) {
        //   // สำหรับตัวเลขที่มืด ปรับให้เข้มขึ้นเล็กน้อย
        //   // hsv = HSVColor.fromAHSV(1.0, hsv.hue, hsv.saturation, hsv.value * 0.5);
        //   hsv = HSVColor.fromAHSV(1.0, 0.0, 0.0, 0.0);
        // } else {
        //   // ไม่พบสีน้ำเงิน ให้เพิ่มความสว่าง
        //   hsv =
        //       HSVColor.fromAHSV(1.0, hsv.hue, hsv.saturation, 0.5);
        // }
        var rgb = hsv.toColor();
        image.setPixelRgb(
          x,
          y,
          rgb.red,
          rgb.green,
          rgb.blue,
        ); //เซ็ทค่าสีใหม่
      }
    }
    return image;
  }

  // ปรับขาวดำ
  Future<File> _preprocessImageblackandwhite(File imageFile) async {
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage == null) return imageFile;
    final processedImage = preprocessImagesHSV(originalImage);

    // ต่ำมืด สูงสว่าง
    const int threshold = 32;

    for (int y = 0; y < processedImage.height; y++) {
      //วนลูปผ่านทุกพิกเซลในภาพ
      for (int x = 0; x < processedImage.width; x++) {
        final pixel = processedImage.getPixel(x, y);
        // ดึงข้อมูลสีของแต่ละพิกเซล
        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();

        //สูตรluminance ช่วยปรับความสว่างให้แม่น ใช้สำหรับการแปลงภาพสีเป็นขาวดำ
        int luminance = (0.299 * r + 0.587 * g + 0.114 * b).toInt();

        if (luminance < threshold) {
          processedImage.setPixelRgba(x, y, 0, 0, 0, 255); // Black แสงน้อย
        } else {
          processedImage.setPixelRgba(x, y, 255, 255, 255, 255); // White แสงมาก
        }

        // if (luminance < threshold) {
        //   originalImage.setPixelRgba(x, y, 255, 255, 255, 255); // White
        // } else {
        //   originalImage.setPixelRgba(x, y, 0, 0, 0, 255); // Black
        // }
      }
    }

    // Save the processed image into a temporary file
    final processedFile = File(imageFile.path)
      ..writeAsBytesSync(
          img.encodeJpg(processedImage)); // บันทึก processedImage
    return processedFile;
  }
}
