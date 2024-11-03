import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold/Home/Quality/Result.dart';
import 'package:watalygold/Home/Quality/result_screen.dart';

import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Widgets/Appbar_main_exit.dart';
import 'package:watalygold/Widgets/Appbar_main_exit_only.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogAlertWNbyGemini.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogChoose.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogError.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogHowtoUse_SelectNW.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogHowtoUse_WN.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogWeightNumber.dart';

class WeightNumber extends StatefulWidget {
  final Map<String, String?> httpscall;
  final List<File> capturedImage;
  final List<String> ListImagePath;
  final List<CameraDescription> camera;
  const WeightNumber({
    super.key,
    required this.camera,
    required this.capturedImage,
    required this.ListImagePath,
    required this.httpscall,
  });

  @override
  State<WeightNumber> createState() => _WeightNumberState();
}

class _WeightNumberState extends State<WeightNumber> {
  String? result;

  final ImagePicker picker = ImagePicker();
  bool _isProcessing = false;

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late File model;
  int selectedIndex = 0;
  FirebaseModelDownloader downloader = FirebaseModelDownloader.instance;
  late String idResult;
  late List<String> ids;

  String numbersOnly = "";
  late bool checkhowtouse;

  void _checkHowtoUse() async {
    final prefs = await SharedPreferences.getInstance();
    checkhowtouse = prefs.getBool("checkhowtouse_nw") ?? false;
    if (!checkhowtouse) {
      bool results = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Dialog_HowtoUse_NW();
        },
      );
      if (results) {
        _alertChoose();
      }
    } else {
      _alertChoose();
    }
    // prefs.setBool("checkhowtouse", false);
  }

  void _alertChoose() async {
    bool? result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Dialog_Choose();
      },
    );
    if (result != null) {
      if (result) {
        var results = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const Dialog_WeightNumber();
          },
        );
        if (results.isNotEmpty) {
          if (results == "") {
            debugPrint("ไม่มีน้ำหนักที่ได้มา");
          } else {
            numbersOnly = results;
            await useFunctionandresult();
          }
        }
      } else {
        // Handle the case where the dialog returned false
        print("Dialog false");
      }
    } else {
      print("ไม่ได้กด Dialog หรือ error");
    }
  }

  @override
  void initState() {
    super.initState();
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    _checkHowtoUse();
    // loadModel();
  }

  int selectedCamera = 0;

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
        // Get a specific camera from the list of available camera.
        widget.camera[cameraIndex],
        // Define the resolution to use.
        ResolutionPreset.max, // new resolution
        enableAudio: false);

    // Initialize the controller
    _initializeControllerFuture = _controller.initialize();

    // // Wait for the initialization to complete
    // try {
    //   await _initializeControllerFuture;

    //   // Now that initialization is complete, start the image stream
    //   if (_controller != null) {
    //     await _controller!.startImageStream(_processImage);
    //     setState(() {});
    //   }
    // } catch (e) {
    //   debugPrint('Error initializing camera: $e');
    //   // Handle the error appropriately
    // }
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
  late String weight;

  Future Gallery() async {
    // try {
    //   final results = await showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) {
    //       return const Dialog_Howtouse_SelectNW();
    //     },
    //   );
    //   if (results) {
    //     final image = await picker.pickImage(
    //         imageQuality: 50, source: ImageSource.gallery);
    //     setState(() {
    //       capturedImages.add(File(image!.path));
    //     });
    //   } else {
    //     debugPrint("Error");
    //   }
    //   // print(image?.path);
    //   // if (image == null) return;
    //   // final imageTemporary = File(image.path);
    // } on PlatformException catch (e) {
    //   stdout.writeln('ผิดพลาด $e');
    // }
  }

  Future useFunctionandresult() async {
    showdialogloadingprocessing();
    weight = numbersOnly.toString();
    debugPrint("ค่าน้ำหนัก $weight");
    widget.httpscall["weight"] = weight;
    debugPrint("${widget.httpscall}");
    // widget.httpscall["weight"] = numbersOnly.toString();
    var firebasefunctions =
        FirebaseFunctions.instanceFor(region: 'asia-southeast1');

    try {
      final result = await firebasefunctions
          .httpsCallable("addImages")
          .call(widget.httpscall);
      stdout.writeln(result.data);
      final Map<String, dynamic> data = Map<String, dynamic>.from(result.data);

      idResult = data['ID_Result'];
      ids = List<String>.from(data['IDs']);

      // นำค่า idResult และ ids ไปใช้ต่อได้ตามต้องการ
      stdout.writeln('ID_Result: $idResult');
      stdout.writeln('IDs: $ids');
    } on FirebaseFunctionsException catch (error) {
      debugPrint(
          'Functions error code: ${error.code}, details: ${error.details}, message: ${error.message}');
      Navigator.of(context).pop();
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog_Error(
              name: "เกิดข้อผิดพลาดบางอย่าง", content: "กรุณาลองใหม่อีกครั้ง");
        },
      );
      return;
    }

    Navigator.of(context).pop();
    // ไปยังหน้าหลัก
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          ID_Result: idResult,
          ID_Image: ids,
          capturedImage: widget.capturedImage,
          ListImagePath: widget.ListImagePath,
        ),
      ),
    );
  }

  Future<void> _captureAndProcess() async {
    try {
      final XFile image = await _controller.takePicture();
      setState(() {});
      showdialogloadingprocessing();
      await _cropAndOCR(image);
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  void showdialogloadingprocessing() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: AlertDialog(
            backgroundColor: GPrimaryColor.withOpacity(0.6),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            title: Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'กำลังตรวจสอบน้ำหนัก',
                    style: TextStyle(color: WhiteColor, fontSize: 20),
                    textAlign: TextAlign
                        .center, // Add this line to center the title text
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                LoadingAnimationWidget.discreteCircle(
                  color: WhiteColor,
                  secondRingColor: GPrimaryColor,
                  thirdRingColor: YPrimaryColor,
                  size: 70,
                ),
              ],
            ),
            // actions: [],
          ),
        ),
      ),
    );
  }

  Future<void> _cropAndOCR(XFile image) async {
    final File imageFile = File(image.path);
    final img.Image? fullImage = img.decodeImage(await imageFile.readAsBytes());

    if (fullImage == null) {
      throw Exception('ไม่สามารถอ่านภาพได้');
    }

    // กำหนดตาม position กรอบ
    final double frameLeftPercent = 0.15;
    final double frameTopPercent = 0.5;
    final double frameWidthPercent = 0.7;
    final double frameHeightPercent = 0.12;

    final int cropX = (frameLeftPercent * fullImage.width).round();
    final int cropY = (frameTopPercent * fullImage.height).round();
    final int cropWidth = (frameWidthPercent * fullImage.width).round();
    final int cropHeight =
        (frameHeightPercent * fullImage.height * 1.5).round();

    // Crop the image
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

    await processImageAndAnalyze(processedImage);
  }

  final textRecognizer = TextRecognizer();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final results = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Dialog_Howtouse_SelectNW();
      },
    );
    if (results) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        showdialogloadingprocessing();
        final file = File(image.path);
        final img.Image originalImage =
            img.decodeImage(await file.readAsBytes())!;

        // final processedImageHSV = await preprocessImagesHSV(originalImage);
        // final processedImageFile = File('${file.path}_processed.png')
        //   ..writeAsBytesSync(img.encodePng(processedImageHSV));
        final processedImageBW = await _preprocessImageblackandwhite(file);

        await processImageAndAnalyze(processedImageBW);
      }
    } else {
      debugPrint("Error");
    }
  }

  Future<void> processImageAndAnalyze(File file) async {
    try {
      setState(() {
        geminiProcessCount++;
      });

      final gemini = Gemini.instance;
      final result = await gemini.textAndImage(
        text:
            """The picture shows a digital scale with digital numbers and decimal points.
    There is a weight attached to the picture, with a white background and black numbers.
    However, if you do not see the numbers on the digital scale screen,
    you will have to answer "There are no numbers or scales in this picture."
    I would like you to read the weight on the scale, for example 325.25 grams.""",
        images: [file.readAsBytesSync()],
      );

      var geminiText = result?.content?.parts?.last.text ?? '';
      debugPrint("จำนวนครั้งที่ส่งไป Gemini: $geminiProcessCount");
      debugPrint("Gemini response: $geminiText");
      // var geminiText = "258.8 g";
      if (geminiText == 'There are no numbers or scales in this picture') {
        Navigator.of(context).pop(); // ปิด dialog กำลังโหลด
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog_Error(
                name: "เกิดข้อผิดพลาด",
                content: "ไม่พบตัวเลขจากรูปภาพหรือภายในรูปภาพไม่เจอตาชั่ง");
          },
        );
        return; // หยุดการทำงานต่อไป
      }

      String? extractedNumbers = _extractNumbersGeminiText(geminiText);
      debugPrint("Extracted numbers: $extractedNumbers");

      if (extractedNumbers == null) {
        Navigator.of(context).pop(); // ปิด dialog กำลังโหลด
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog_Error(
                name: "เกิดข้อผิดพลาด",
                content: "ไม่สามารถแยกตัวเลขจากข้อความที่ได้รับ");
          },
        );
        return; // หยุดการทำงานต่อไป
      }

      numbersOnly = extractedNumbers;
      debugPrint("ค่าน้ำหนักหลังทำงานเสร็จ $numbersOnly");
      await saveGeminiCountToFirebase();
      Navigator.of(context).pop(); // ปิด dialog กำลังโหลด

      String? results = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog_WN_Gemini(
            number: numbersOnly,
          );
        },
      );

      if (results!.isNotEmpty) {
        if (results == "") {
          debugPrint("ไม่มีน้ำหนักที่ได้มา");
        } else {
          numbersOnly = results;
          debugPrint(results);
          await useFunctionandresult();
          // ทำอะไรต่อกับ results ตามที่ต้องการ
        }
      } else {
        debugPrint("น้ำหนักไม่ถูกต้อง");
        debugPrint("น้ำหนักที่ได้มา : $results");
      }
    } catch (error) {
      setState(() {
        geminiProcessCount--;
      });
      await saveGeminiCountToFirebase();
      Navigator.of(context).pop(); // ปิด dialog กำลังโหลด ในกรณีเกิด error
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog_Error(
              name: "เกิดข้อผิดพลาด",
              content: "เกิดข้อผิดพลาดในการวิเคราะห์รูปภาพ: $error");
        },
      );
      if (error is HttpException) {
        print('Error connecting to the server');
      } else if (error is FormatException) {
        print('Invalid data format');
      } else {
        print('An unexpected error occurred: $error');
      }
    }
  }

  int geminiProcessCount = 0;
    Future<void> saveGeminiCountToFirebase() async {
  try {
   
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await FirebaseFirestore.instance
        .collection('GeminiProcesscount')
        .doc(today) 
        .set({
      'process_count': FieldValue.increment(geminiProcessCount),  // เพิ่มค่าครั้งการประมวลผล
      'last_updated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));  // ใช้ merge เพื่ออัปเดตข้อมูลเดิมหากมีอยู่แล้ว

    debugPrint('บันทึกจำนวนครั้งลง Firebase สำเร็จ');
  } catch (e) {
    debugPrint('เกิดข้อผิดพลาดในการบันทึกลง Firebase: $e');
  }
}


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
          // hsv = HSVColor.fromAHSV(0.0, hsv.hue, 0.0, 0.0); // ทำให้โปร่งใส
          hsv = HSVColor.fromAHSV(1, 0.0, 0.0, 0.7);
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
        image.setPixelRgba(x, y, rgb.red, rgb.green, rgb.blue, rgb.alpha);
      }
    }
    return image;
  }

  // ปรับขาวดำ
  Future<File> _preprocessImageblackandwhite(File imageFile) async {
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage == null) return imageFile;

    final processedImage = preprocessImagesHSV(originalImage);

    const int threshold = 32;

    for (int y = 0; y < processedImage.height; y++) {
      for (int x = 0; x < processedImage.width; x++) {
        final pixel = processedImage.getPixel(x, y);

        // Extract RGBA values and cast to int
        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();

        // สูตร luminance ปรับภาพขาวดำให้แม่นขึ้น
        int luminance = (0.299 * r + 0.587 * g + 0.114 * b).toInt();

        if (luminance < threshold) {
          processedImage.setPixelRgb(x, y, 0, 0, 0); // Black
        } else {
          processedImage.setPixelRgb(x, y, 255, 255, 255); // White
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
      ..writeAsBytesSync(img.encodeJpg(originalImage)); // บันทึก processedImage
    return processedFile;
  }

  String _extractNumbersOCR(String text) {
    return text.replaceAll(RegExp(r'[^0-9]'), '').trim();
  }

  String? _extractNumbersGeminiText(String response) {
    final regex =
        RegExp(r"(\d+(\.\d*)?)\s*([a-zA-Z]*)"); // เปลี่ยนให้หน่วยเป็น optional
    final match = regex.firstMatch(response);
    if (match != null) {
      final number = match.group(1);
      final unit = match.group(3);

      // ถ้า unit เป็น null หรือ empty ให้เติม "g" เข้าไป
      final finalUnit = (unit == null || unit.isEmpty) ? 'g' : unit;
      debugPrint("final unit : $number $finalUnit");
      return "$number $finalUnit"; // คืนค่าตัวเลขพร้อมหน่วย
    }
    return null;
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

  late int flashstatus = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppbarMainExit_only(
        name: 'น้ำหนักมะม่วง',
        actions: IconButton(
          color: Colors.white,
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xffF2F6F5)),
            child: const Icon(
              Icons.scale,
              color: GPrimaryColor,
              size: 20,
            ),
          ),
          onPressed: () async {
            String? results = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return const Dialog_WeightNumber();
              },
            );
            if (results!.isNotEmpty) {
              if (results == "") {
                debugPrint("ไม่มีน้ำหนักที่ได้มา");
              } else {
                numbersOnly = results;
                await useFunctionandresult();
              }
            } else {
              debugPrint("ไม่มีน้ำหนักที่ได้มา");
            }
          },
        ),
      ),
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
                      if (!_controller.value.isInitialized) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // หรือ loading indicator
                      }
                      return SizedBox(
                          width: screenSize.width,
                          height: screenSize.height * 0.8,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                                width: screenSize
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
                padding: const EdgeInsets.only(top: 50),
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
                                        return const Dialog_HowtoUse_NW();
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
}
