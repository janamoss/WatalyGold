import 'dart:async';
import 'dart:io';

import 'package:background_remover/background_remover.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
// import 'package:watalygold/Home/Quality/Gallerypage.dart';
import 'package:watalygold/Home/Quality/WeightNumber.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/DialogHowtoUse.dart';
import 'package:watalygold/Widgets/Quality/DialogWarningDel.dart';
import 'package:watalygold/Widgets/WeightNumber/DialogError.dart';

class ProblematicImage {
  final int statusimage;
  final bool isStatusMangoProblem;
  final bool isStatusMangoColorProblem;

  ProblematicImage({
    required this.statusimage,
    required this.isStatusMangoProblem,
    required this.isStatusMangoColorProblem,
  });
}

class CapturedImage {
  final File image;
  int statusMango;
  int statusimage;
  int statusMangoColor;

  CapturedImage({
    required this.image,
    required this.statusMango,
    required this.statusimage,
    required this.statusMangoColor,
  });
}

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
  late tfl.Interpreter _interpreter;
  final dynamic _probability = 0;
  List<String>? _labels;
  String? result;

  final ImagePicker picker = ImagePicker();
  Timer? _lightMeterTimer;
  bool _isProcessing = false;

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late File model;
  String _mobileDeviceIdentifier = "";
  int selectedIndex = 0;
  FirebaseModelDownloader downloader = FirebaseModelDownloader.instance;
  final List _predictions = [];

  late bool checkhowtouse;

  int statusimage = 1;

  bool _noInternet = false;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isBottomSheetShown = false;

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique ID on Android
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique ID on iOS
    }
    return null;
  }

  void _checkHowtoUse() async {
    final prefs = await SharedPreferences.getInstance();
    checkhowtouse = prefs.getBool("checkhowtouse") ?? false;
    _mobileDeviceIdentifier = prefs.getString("device") ?? "unknow";
    if (!checkhowtouse) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog_HowtoUse();
        },
      );
    }
    // prefs.setBool("checkhowtouse", false);
  }

  @override
  void initState() {
    super.initState();
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    getDeviceId();
    _checkHowtoUse();
    loadmodel().then((_) => {
          loadlabels().then((loadedLabels) {
            setState(() {
              _labels = loadedLabels;
            });
          })
        });
  }

  Future<bool> _checkRealInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _updateNoInternetState(true);
      return true; // ส่ง true เมื่อไม่มีการเชื่อมต่ออินเทอร์เน็ต
    } else {
      bool hasRealConnectivity = await _checkRealInternetConnectivity();
      _updateNoInternetState(!hasRealConnectivity);
      return !hasRealConnectivity; // ส่ง true เมื่อไม่มีการเชื่อมต่ออินเทอร์เน็ตจริง ๆ
    }
  }

  void _updateNoInternetState(bool noInternet) {
    setState(() {
      _noInternet = noInternet;
    });

    if (_noInternet) {
      _showNoInternetModal();
    } else {
      _dismissNoInternetModal();
    }
  }

  void _showNoInternetModal() {
    if (!_isBottomSheetShown) {
      _isBottomSheetShown = true;
      showMaterialModalBottomSheet(
        context: context,
        isDismissible: false, // ไม่ให้ปิด Modal โดยการแตะด้านนอก
        enableDrag: true, // อนุญาตให้ลากปิด Modal
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // เมื่อผู้ใช้กดปุ่มย้อนกลับ
              capturedImages.clear(); // เคลียร์ capturedImages ก่อนปิด Modal
              _isBottomSheetShown = false; // รีเซ็ตสถานะเมื่อปิด Modal
              Navigator.of(context).pop(); // ปิด Modal
              setState(() {});
              return false; // บอกว่าจะไม่ให้ปิด Modal โดยอัตโนมัติ
            },
            child: SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 80,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ตอนนี้คุณไม่ได้เชื่อมต่ออินเทอร์เน็ต",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _checkInternetConnection();
                      capturedImages.clear();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.red.shade300),
                    ),
                    child: const Text(
                      "ลองใหม่",
                      style: TextStyle(color: WhiteColor, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).whenComplete(() {
        _isBottomSheetShown = false; // รีเซ็ตสถานะเมื่อปิด Modal
      });
    }
  }

  void _dismissNoInternetModal() {
    if (_isBottomSheetShown) {
      Navigator.of(context).pop();
      _isBottomSheetShown = false;
    }
  }

  int selectedCamera = 0;
  List<CapturedImage> capturedImages = [];
  // List<File> capturedImages = [];

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
        // Get a specific camera from the list of available camera.
        widget.camera[cameraIndex],
        // Define the resolution to use.
        ResolutionPreset.max, // new resolution
        enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
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

  int processAndRunInference(File images) {
    // แปลงภาพและเตรียมข้อมูล input
    Uint8List inputBytes = preProcessingImage(images);

    var input = inputBytes.buffer.asFloat32List().reshape([1, 64, 64, 3]);

    var outputBuffer = List<double>.filled(1, 0).reshape([1, 1]);

    // รันโมเดล
    _interpreter.run(input, outputBuffer);

    double output = outputBuffer[0][0];

    // ตรวจสอบค่าผลลัพธ์และแปลงเป็นสถานะ
    return output > 0.5 ? 1 : 2; // สีเหลือง หรือ ไม่ใช่สีเหลือง
  }

  Uint8List preProcessingImage(File capturedImages) {
    // อ่านภาพและ resize ให้เป็น 64x64
    img.Image? image = img.decodeImage(capturedImages.readAsBytesSync());
    img.Image? resizedImage = img.copyResize(image!, width: 64, height: 64);

    // แปลงเป็น Uint8List (พิกเซลในรูปแบบตัวเลข)
    Uint8List bytes = resizedImage.getBytes();

    // สร้าง Float32List สำหรับการ normalize ค่าพิกเซล
    Float32List normalizedBytes = Float32List(bytes.length);
    for (int i = 0; i < bytes.length; i++) {
      normalizedBytes[i] = bytes[i] / 255.0;
    }

    return normalizedBytes.buffer.asUint8List();
  }

  /// รันโมเดลกับภาพที่เลือก
  ///
  /// [images] ภาพที่จะส่งเข้าโมเดล
  /// [index] ลำดับที่ของภาพในรายการ capturedImages
  ///
  /// จะแปลงภาพให้เป็นขนาด 64x64 และเตรียมข้อมูล input สำหรับโมเดล
  /// จากนั้นจะรันโมเดลและตรวจสอบค่าผลลัพธ์เพื่อแปลงเป็นสถานะ
  /// สุดท้ายจะอัปเดตสถานะ UI ด้วย

  Future<void> runInference(File images, int index) async {
    if (_labels == null) {
      return;
    }
    try {
      // แปลงภาพและเตรียมข้อมูล input
      Uint8List inputBytes = preProcessingImage(images);
      var input = inputBytes.buffer.asFloat32List().reshape([1, 64, 64, 3]);
      // สำหรับ output แบบ sigmoid คุณจะมี output ขนาด [1, 1]
      var outputBuffer = List<double>.filled(1, 0).reshape([1, 1]);
      // รันโมเดล
      _interpreter.run(input, outputBuffer);
      double output = outputBuffer[0][0];
      print('Raw output: $output');
      // ตรวจสอบค่าผลลัพธ์และแปลงเป็นสถานะ
      int numberresult = output > 0.5 ? 1 : 2;
      // อัปเดตสถานะ UI
      setState(() {
        updateStatusMangoColorByStatusImage(index, numberresult);
        checkCapturedImages();
      });

      if (capturedImages.length == 4 &&
          capturedImages
              .map((image) => image.statusimage)
              .toSet()
              .containsAll([1, 2, 3, 4]) &&
          capturedImages.every((image) =>
              image.statusMango == 1 && image.statusMangoColor == 1)) {
        debugPrint("ครบ 4 รูปภาพเรียบร้อยแล้ว");
        await uploadImageAndUpdateState();
      }
    } catch (e) {
      debugPrint('Error processing Image: $e');
    }
  }

  loadmodel() async {
    try {
      _interpreter =
          await tfl.Interpreter.fromAsset("assets/mango_color.tflite");
    } catch (e) {
      debugPrint('error loadmodel $e');
    }
  }

  Future<List<String>> loadlabels() async {
    final lebelsData =
        await DefaultAssetBundle.of(context).loadString('assets/lebels.txt');
    return lebelsData.split('\n');
  }

  Future<void> uploadImageinphone(File imageFile, String imageName) async {
    return;
  }

  Future Gallery() async {
    try {
      // เลือกรูปภาพไม่เกิน 4 รูป
      final List<XFile> images = await picker.pickMultiImage(
        imageQuality: 70,
        limit: 4,
      );

      if (images.isNotEmpty) {
        // ตรวจสอบว่าจำนวนรูปมากกว่า 4 หรือไม่ ถ้ามากกว่าให้เอาแค่ 4 รูปแรก
        List<XFile> selectedImages = images.length > 4
            ? images.sublist(0, 4) // เลือก 4 รูปแรก
            : images; // ถ้าน้อยกว่าหรือเท่ากับ 4 ก็ใช้รายการเต็ม

        Set<int> existingStatusImages =
            capturedImages.map((image) => image.statusimage).toSet();

        List<Future<void>> analysisFutures = [];

        for (int i = 0; i < selectedImages.length; i++) {
          int nextAvailableStatus = 1;
          while (existingStatusImages.contains(nextAvailableStatus)) {
            nextAvailableStatus++;
          }

          // แปลง XFile เป็น File
          File imageFile = File(selectedImages[i].path);

          setState(() {
            capturedImages.add(CapturedImage(
              image: imageFile,
              statusMango: 0,
              statusMangoColor: 0,
              statusimage: nextAvailableStatus,
            ));
            existingStatusImages.add(nextAvailableStatus);

            List<int> availableStatusImages = [1, 2, 3, 4]
                .where((number) => !existingStatusImages.contains(number))
                .toList();

            if (availableStatusImages.isNotEmpty) {
              statusimage = availableStatusImages.first;
            } else {
              debugPrint("ครบ 4 รูปแล้วค่า");
            }
          });
          print(capturedImages.length);

          // ส่ง File แทน XFile ไปยัง analyzeImage
          analysisFutures.add(analyzeImage(imageFile, nextAvailableStatus));
        }
        print(capturedImages.length);
        // ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต
        bool noInternet = await _checkInternetConnection();
        if (noInternet) {
          // ถ้าไม่มีอินเทอร์เน็ตให้ทำสิ่งนี้
          print("ไม่มีการเชื่อมต่ออินเทอร์เน็ต");
          return; // หยุดการทำงานหรือเรียกฟังก์ชันอื่น
        } else {
          // ถ้ามีอินเทอร์เน็ตให้ทำสิ่งที่คุณต้องการ
          await Future.wait(analysisFutures);
          debugPrint("analysis");
          print("มีการเชื่อมต่ออินเทอร์เน็ต");
          // เรียกฟังก์ชันหรือทำสิ่งที่คุณต้องการต่อไป
        }
      }
    } on PlatformException catch (e) {
      debugPrint('เกิดข้อผิดพลาด: $e');
    }
  }

  CapturedImage? findCapturedImageByStatusImage(int statusImage) {
    try {
      return capturedImages.firstWhere(
        (image) => image.statusimage == statusImage,
      );
    } catch (e) {
      return null; // คืนค่า null ถ้าไม่พบภาพที่ตรงกับ statusImage
    }
  }

  Future<File> processAndSaveImage(Uint8List imageBytes) async {
    // ลบพื้นหลังของรูปภาพ
    final resultImage = await removeBackground(imageBytes: imageBytes);

    // แปลง Uint8List เป็น Image object
    final image = img.decodeImage(resultImage);

    // แปลง Image เป็น PNG
    final pngBytes = img.encodePng(image!);

    // สร้างชื่อไฟล์ที่ไม่ซ้ำกัน
    final String fileName =
        'processed_image_${DateTime.now().millisecondsSinceEpoch}.png';

    // หาตำแหน่งที่จะบันทึกไฟล์
    final directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';

    // บันทึกไฟล์
    final File file = File(filePath);
    await file.writeAsBytes(pngBytes);

    return file;
  }

  Future uploadImageAndUpdateState() async {
    if (capturedImages.length == 4) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => PopScope(
          canPop: false,
          child: Center(
            child: AlertDialog(
              backgroundColor: GPrimaryColor.withOpacity(0.6),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              title: Column(
                children: [
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'กำลังไปยังขั้นตอนต่อไป',
                      style: TextStyle(color: WhiteColor, fontSize: 20),
                      textAlign: TextAlign.center,
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
            ),
          ),
        ),
      );

      print("พบสีเหลือง");

      String uniquename = DateTime.now().millisecondsSinceEpoch.toString();

      // ชื่อของรูปภาพที่ต้องการ
      List<String> imageNames = [
        'Front_$uniquename',
        'Back_$uniquename',
        'Bottom_$uniquename',
        'Top_$uniquename',
      ];

      List<String> imageuri = [];
      List<String> downloaduri = [];
      List<String> listImagepath = [];

      for (int i = 1; i <= 4; i++) {
        // ใช้ฟังก์ชัน findCapturedImageByStatusImage เพื่อนำ capturedImages ที่ตรงกับ statusimage
        final capturedImage = findCapturedImageByStatusImage(i);

        if (capturedImage != null) {
          final result = await uploadImageToCloudStorage(
              capturedImage.image, imageNames[i - 1]);

          if (result.containsKey('downloadURL')) {
            final imagePath =
                await saveImageToDevice(capturedImage.image, imageNames[i - 1]);

            stdout.writeln('Saved image path: $imagePath');
            listImagepath.add(imagePath.toString());
            downloaduri.add(result['downloadURL']!);
            imageuri.add(result['imageName']!);
          } else {
            print("Upload failed or result is null for statusimage $i");
          }
        } else {
          print("ไม่พบภาพสำหรับ statusimage $i");
        }
      }

      bool allImagesUploaded = true;
      String downloadurl = downloaduri.join(',');
      String concatenatedString = imageuri.join(',');

      setState(() {
        capturedImages.sort((a, b) => a.statusimage.compareTo(b.statusimage));
      });

// ตอนที่ใช้ results ใน preview_result:
      final previewResult = {
        'downloadurl': downloadurl,
        "imagename": concatenatedString,
        "ip": _mobileDeviceIdentifier,
        "result": "Yellow"
      };

      debugPrint("$previewResult");

      List<File> capturedImagesFiles =
          capturedImages.map((captured) => captured.image).toList();

      debugPrint("เสร็จสิ้น");

      if (allImagesUploaded) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WeightNumber(
                    camera: widget.camera,
                    capturedImage: capturedImagesFiles,
                    ListImagePath: listImagepath,
                    httpscall: previewResult,
                  )),
        );
      }
    } else {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog_Error(
              name: "เกิดข้อผิดพลาด",
              content: "เซิฟเวอร์ทำงานผิดพลาด กรุณาลองใหม่อีกครั้ง");
        },
      );
      Navigator.of(context).pop();
      setState(() {
        capturedImages.clear();
      });
      print("ผลลัพธ์ไม่ตรงกับที่คาดหวัง: $result");
    }
  }

  Future<String> saveImageToDevice(File imageFile, String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final fileName = '$path/$imageName';
    final savedImage = await imageFile.copy(fileName);
    return savedImage.path;
  }

  Future<Map<String, String>> uploadImageToCloudStorage(
      File imageFile, String imageName) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('image_analysis/$imageName');

    // เปลี่ยนประเภทเป็นรูป
    final metadata = SettableMetadata(contentType: 'image/jpg');

    final uploadTask = storageRef.putFile(imageFile, metadata);
    final snapshot = await uploadTask;

    String downloadURL = await snapshot.ref.getDownloadURL();
    final result = {'downloadURL': downloadURL, 'imageName': imageName};
    return result;
  }

  late int flashstatus = 0;

  // การอัพเดตข้อมูล statusmango
  void updateStatusMangoByStatusImage(int statusImage, int statusMango) {
    setState(() {
      for (var image in capturedImages) {
        if (image.statusimage == statusImage) {
          image.statusMango =
              statusMango; // อัปเดตค่า statusMango ตามที่ต้องการ
          break; // ถ้าเจอแล้วหยุดลูป
        }
      }
    });
  }

  void updateStatusMangoColorByStatusImage(
      int statusImage, int statusMangoColor) {
    setState(() {
      for (var image in capturedImages) {
        if (image.statusimage == statusImage) {
          image.statusMangoColor =
              statusMangoColor; // อัปเดตค่า statusMango ตามที่ต้องการ
          break; // ถ้าเจอแล้วหยุดลูป
        }
      }
    });
  }

  String mapIndexToText(int index) {
    switch (index) {
      case 1:
        return "หน้า";
      case 2:
        return "หลัง";
      case 3:
        return "ล่าง";
      case 4:
        return "บน";
      default:
        return "ไม่ทราบตำแหน่ง"; // สำหรับค่าที่ไม่อยู่ในช่วง 1-4
    }
  }

  String _getProblemReason(ProblematicImage image) {
    if (image.isStatusMangoProblem && image.isStatusMangoColorProblem) {
      return "ไม่มีมะม่วงในภาพและสีไม่ถูกต้อง";
    } else if (image.isStatusMangoProblem) {
      return "ไม่มีมะม่วงในภาพ";
    } else if (image.isStatusMangoColorProblem) {
      return "สีของมะม่วงไม่ถูกต้อง";
    } else {
      return "เกิดข้อผิดพลาด";
    }
  }

  bool _hasShownDialog =
      false; // ตัวแปร flag เพื่อตรวจสอบว่า Dialog ได้แสดงหรือยัง

  void checkCapturedImages() {
    // ตรวจสอบว่ามี capturedImages ครบ 4 ภาพ
    if (capturedImages.length == 4) {
      // ตรวจสอบว่า status ของภาพทั้งหมดถูกประมวลผลแล้ว
      bool allImagesProcessed = capturedImages.every(
          (image) => image.statusMango != 0 || image.statusMangoColor != 0);

      // หากทุกภาพได้รับการประมวลผลแล้ว
      debugPrint(allImagesProcessed.toString());
      if (allImagesProcessed && !_hasShownDialog) {
        // ตรวจสอบว่าภาพประมวลผลเสร็จและยังไม่เคยแสดง Dialog
        // ภาพที่มีปัญหา (statusMango == 2 หรือ statusMangoColor == 2)
        List<ProblematicImage> problematicImages = capturedImages
            .where((image) =>
                image.statusMango == 2 || image.statusMangoColor == 2)
            .map((image) => ProblematicImage(
                  statusimage: image.statusimage,
                  isStatusMangoProblem: image.statusMango == 2,
                  isStatusMangoColorProblem: image.statusMangoColor == 2,
                ))
            .toList()
          ..sort((a, b) => a.statusimage.compareTo(b.statusimage));

        // ภาพที่ไม่มีปัญหา
        List<int> passedImages = capturedImages
            .where((image) =>
                image.statusMango != 2 && image.statusMangoColor != 2)
            .map((image) => image.statusimage)
            .toList();

        // ตรวจสอบว่ามีภาพที่ไม่ผ่านการวิเคราะห์หรือไม่
        if (problematicImages.isNotEmpty) {
          _hasShownDialog = true; // แสดง Dialog แค่ครั้งเดียว
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: WhiteColor,
                surfaceTintColor: WhiteColor,
                title: Text(
                  'พบรูปภาพที่ไม่ถูกต้อง',
                  style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        'ภาพที่ไม่ถูกต้องมีดังนี้ :',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    for (var problematicImage in problematicImages)
                      ListTile(
                        leading: Icon(
                          Icons.image_rounded,
                          size: 25,
                          color: Colors.red.shade400,
                        ),
                        title: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "ภาพด้าน ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${mapIndexToText(problematicImage.statusimage)} ",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: GPrimaryColor,
                              ),
                            ),
                            Text(
                              "เนื่องจาก ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              _getProblemReason(problematicImage),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 10),
                    FittedBox(
                      child: Text(
                        'กรุณาถ่ายภาพด้านดังกล่าวใหม่อีกครั้ง',
                        style: TextStyle(
                            color: Colors.red.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  SizedBox(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(GPrimaryColor),
                            elevation: WidgetStatePropertyAll(1)),
                        onPressed: () async {
                          _hasShownDialog =
                              false; // รีเซ็ต flag เมื่อปิด Dialog
                          Navigator.of(context).pop();
                        },
                        child: Text('เข้าใจแล้ว',
                            style: TextStyle(
                              color: WhiteColor,
                              fontSize: 16,
                            ))),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  Future<void> analyzeImage(File image, int index) async {
    final gemini = Gemini.instance;
    await gemini.textAndImage(
      text:
          """ From the picture I gave you, can you check if there is a mango and a 5 baht coin in this picture? If there are both, then answer "mango". 
          If there are neither or if there is a hand or finger in the picture, then answer "not a mango". 
          Please note that this picture may show the mango from different angles, such as front, back, top or bottom. 
          The bottom may look like the top of the mango but there is no stem in the middle.""",
      images: [await image.readAsBytes()],
    ).then((result) {
      final geminiText = (result?.content?.parts?.last.text ?? '').trim();

      debugPrint(geminiText);
      setState(() {
        if (geminiText == "mango" || geminiText == "mango.") {
          updateStatusMangoByStatusImage(index, 1);
          runInference(image, index);
        } else {
          updateStatusMangoByStatusImage(index, 2);
          // updateStatusMangoColorByStatusImage(index, 2);
        }
        checkCapturedImages();
      });

      debugPrint("Gemini response: $geminiText");
    }).catchError((error) {
      debugPrint("Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const AppbarMains(name: 'วิเคราะห์คุณภาพ'),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
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
                          width: size.width,
                          height: size.height * 0.8,
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
                statusimage == 3 || statusimage == 4
                    ? Positioned(
                        bottom: 180,
                        left: 50,
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: WhiteColor, width: 3),
                          ),
                        ),
                      )
                    : Positioned(
                        bottom: 125,
                        left: 100,
                        child: Container(
                          width: 200,
                          height: 350,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: WhiteColor, width: 3),
                          ),
                        ),
                      ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  left: 0,
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        final labels = [
                          'ด้านหน้า',
                          'ด้านหลัง',
                          'ด้านล่าง',
                          'ด้านบน'
                        ];

                        // ฟังก์ชันสำหรับค้นหาภาพที่มี statusimage ตรงกับ index ปัจจุบัน
                        CapturedImage? findCapturedImageByStatusImage(
                            int statusImage) {
                          try {
                            return capturedImages.firstWhere(
                              (image) => image.statusimage == statusImage,
                            );
                          } catch (e) {
                            return null; // คืนค่า null เมื่อไม่เจอ
                          }
                        }

                        // ดึงข้อมูลภาพที่ตรงกับ statusimage = index + 1
                        final image = findCapturedImageByStatusImage(index + 1);

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: image == null
                                      ? () {
                                          setState(() {
                                            statusimage = index +
                                                1; // ตั้งค่า statusimage ตาม index ของรูปภาพที่กด
                                          });
                                          debugPrint("$statusimage สถานะตอนกด");
                                        }
                                      : (image.statusMango == 0 &&
                                                  image.statusMangoColor ==
                                                      0) ||
                                              (image.statusMango == 1 &&
                                                  image.statusMangoColor == 0)
                                          ? null
                                          : image.statusMango == 1 &&
                                                  image.statusMangoColor == 1
                                              ? null
                                              : () {
                                                  setState(() {
                                                    capturedImages
                                                        .remove(image);
                                                    statusimage = index + 1;
                                                  });
                                                },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      border: image != null
                                          ? Border.all(
                                              color: (image.statusMango == 2 ||
                                                      image.statusMangoColor ==
                                                          2)
                                                  ? Colors.red
                                                      .shade400 // Red border for status 2
                                                  : GPrimaryColor,
                                              width: 2,
                                            )
                                          : statusimage == index + 1
                                              ? Border.all(
                                                  color: Colors.cyan.shade400,
                                                  width: 2,
                                                )
                                              : Border.all(
                                                  color: WhiteColor,
                                                  width: 2,
                                                ),
                                      color: Colors.white.withOpacity(0.4),
                                      image: image != null
                                          ? DecorationImage(
                                              image: FileImage(image.image),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),

                                    // ใช้ child เพื่อแสดงสถานะของ statusMango ตามที่เลือก
                                    child: image != null
                                        ? Center(
                                            child: (image.statusMango == 0 &&
                                                        image.statusMangoColor ==
                                                            0) ||
                                                    (image.statusMango == 1 &&
                                                        image.statusMangoColor ==
                                                            0)
                                                ? CircularProgressIndicator(
                                                    color: GPrimaryColor,
                                                  )
                                                : image.statusMango == 1 &&
                                                        image.statusMangoColor ==
                                                            1
                                                    ? Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                          Icon(
                                                            Icons.check,
                                                            size: 20,
                                                            weight: 10,
                                                            color:
                                                                GPrimaryColor,
                                                          ),
                                                        ],
                                                      )
                                                    : Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 15,
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                          Icon(
                                                            Icons.close,
                                                            size: 20,
                                                            weight: 10,
                                                            color: Colors
                                                                .red.shade400,
                                                          ),
                                                        ],
                                                      ),
                                          )
                                        : null,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      labels[index],
                                      style: TextStyle(
                                          color: GPrimaryColor, fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (image != null &&
                                image.statusMango == 1 &&
                                image.statusMangoColor == 1)
                              Positioned(
                                top: -10,
                                right: -5,
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      statusimage = index + 1;
                                    });
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialogwarningdel(
                                          message: labels[index],
                                        );
                                      },
                                    );
                                    if (result == true) {
                                      setState(() {
                                        capturedImages.remove(image);
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade700,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 15,
                                      color: WhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                )
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "พยายามให้ลูกมะม่วงของคุณ\nอยู่ภายในระยะกรอบสีขาว",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: GPrimaryColor),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
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
                              onTap: capturedImages.length == 4
                                  ? null
                                  : () async {
                                      await _initializeControllerFuture;

                                      // ตั้งค่าแฟลชตาม flashstatus
                                      if (flashstatus == 0) {
                                        _controller.setFlashMode(FlashMode.off);
                                      }

                                      // ถ่ายรูป
                                      var xFile =
                                          await _controller.takePicture();

                                      // ตรวจสอบเลข statusimage ที่ขาด
                                      Set<int> existingStatusImages =
                                          capturedImages
                                              .map((image) => image.statusimage)
                                              .toSet();

                                      // เพิ่ม statusimage ปัจจุบันเข้าไปใน existingStatusImages
                                      existingStatusImages.add(statusimage);

                                      List<int> availableStatusImages = [
                                        1,
                                        2,
                                        3,
                                        4
                                      ]
                                          .where((number) =>
                                              !existingStatusImages
                                                  .contains(number))
                                          .toList();

                                      // ใช้ statusimage ปัจจุบันเป็น statusN
                                      int statusN = statusimage;

                                      // เพิ่มรูปภาพลงใน capturedImages
                                      setState(() {
                                        capturedImages.add(CapturedImage(
                                          statusimage: statusN,
                                          image: File(xFile.path),
                                          statusMango: 0,
                                          statusMangoColor: 0,
                                        ));
                                        if (availableStatusImages.isNotEmpty) {
                                          statusimage =
                                              availableStatusImages.first;
                                        } else {
                                          debugPrint("ครบ 4 รูปแล้วค่า");
                                        }
                                      });

                                      debugPrint("ตัวเลขสถานะ $statusN");
                                      debugPrint("$capturedImages");
                                      debugPrint(
                                          "availableStatusImages: $availableStatusImages");

                                      // เรียก analyzeImage พร้อมส่ง statusN ไป
                                      bool noInternet =
                                          await _checkInternetConnection();
                                      if (noInternet) {
                                      } else {
                                        await analyzeImage(
                                            File(xFile.path), statusN);
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
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // showDialog(
                                    //   barrierDismissible: false,
                                    //   context: context,
                                    //   builder: (context) {
                                    //     // return Dialog_HowtoUse();
                                    //     return const Dialog_WeightNumber();
                                    //   },
                                    // );
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
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
