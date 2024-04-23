import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:watalygold/Home/Quality/Gallerypage.dart';
import 'package:watalygold/Home/Quality/Result.dart';
import 'package:watalygold/Widgets/Appbar_main.dart';
import 'package:watalygold/Widgets/Color.dart';

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
  dynamic _probability = 0;
  List<String>? _labels;
  String? result;

  final ImagePicker picker = ImagePicker();

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late File model;
  String? _deviceId;
  int selectedIndex = 0;
  FirebaseModelDownloader downloader = FirebaseModelDownloader.instance;
  final List _predictions = [];
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
    super.initState();
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    _getDeviceId();
    loadmodel().then((_) => {
          loadlabels().then((loadedLabels) {
            setState(() {
              _labels = loadedLabels;
            });
          })
        });
  }

  int selectedCamera = 0;
  List<File> capturedImages = [];

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
        // Get a specific camera from the list of available camera.
        widget.camera![cameraIndex],
        // Define the resolution to use.
        ResolutionPreset.max, // new resolution
        enableAudio: false);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
    _interpreter.close();
  }

  File? image;
  String imageUrl = '';

  Future<Uint8List> preProcessingImage(File capturedImages) async {
    img.Image? Oimage = img.decodeImage(await capturedImages.readAsBytes());
    img.Image? resizedImage = img.copyResize(Oimage!, width: 64, height: 64);

    Uint8List bytes = resizedImage.getBytes();
    return bytes;
  }

  Future<void> runInference() async {
    if (_labels == null) {
      return;
    }

    try {
      Uint8List inputBytes = await preProcessingImage(capturedImages[0]);
      var input = inputBytes.buffer.asUint8List().reshape([1, 64, 64, 3]);
      var outputBuffer = List<int>.filled(1 * 2, 0).reshape([1, 2]);
      _interpreter.run(input, outputBuffer);
      List<double> output = outputBuffer[0];
      debugPrint('Raw output $output');

      double maxScore = output.reduce(max);
      _probability = (maxScore / 255.0);

      int highestProbIndex = output.indexOf(maxScore);
      String classificationResult = _labels![highestProbIndex];
      setState(() {
        result = classificationResult;
      });
      debugPrint(result);
    } catch (e) {
      debugPrint('Error processing Image $e');
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
      final image = await ImagePicker().pickMultiImage(imageQuality: 60);
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
      uploadImageAndUpdateState();
    } on PlatformException catch (e) {
      print('ผิดพลาด $e');
    }
  }

  Future uploadImageAndUpdateState() async {
    if (capturedImages.length == 4) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: AlertDialog(
            backgroundColor: GPrimaryColor.withOpacity(0.6),
            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            title: Column(
              children: [
                Text(
                  'กำลังวิเคราะห์คุณภาพ . . .',
                  style: TextStyle(color: WhiteColor),
                  textAlign: TextAlign
                      .center, // Add this line to center the title text
                ),
                SizedBox(
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
            actions: [],
          ),
        ),
      );

      runInference();
      print(result);

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
      List<String> downloaduri = [];
      List<String> listImagepath = [];
      for (int i = 0; i < capturedImages.length; i++) {
        final result =
            await uploadImageToCloudStorage(capturedImages[i], imageNames[i]);
        final imagePath =
            await saveImageToDevice(capturedImages[i], imageNames[i]);
        print('Saved image path: $imagePath');
        listImagepath.add(imagePath.toString());
        downloaduri.add(result['downloadURL']!);
        imageuri.add(result['imageName']!);
      }
      String downloadurl = downloaduri.join(',');
      String concatenatedString = imageuri.join(',');
      // File first = capturedImages[0];
      // ตัวแปรเพื่อตรวจสอบว่าทุกรูปถูกอัปโหลดหรือไม่
      String results = result!;

      var firebasefunctions =
          FirebaseFunctions.instanceFor(region: 'asia-southeast1');

      try {
        final result = await firebasefunctions.httpsCallable("addImages").call({
          'downloadurl': downloadurl,
          "imagename": concatenatedString,
          "ip": _deviceId,
          "result": results
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
        Navigator.of(context).pop();
        // ไปยังหน้าหลัก
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              ID_Result: idResult,
              ID_Image: ids,
              capturedImage: capturedImages.reversed.toList(),
              ListImagePath: listImagepath,
            ),
          ),
        );
      }
    }
    // loadModel();
    // เรียก setState เพื่ออัพเดท UI หลังจากได้ imageUrl แล้ว
    setState(() {
      // detectImage(imageTemporary);
    });
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
            child: Stack(
              children: [
                SizedBox(
                  child: FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If the Future is complete, display the preview.
                        return Container(
                            width: size.width,
                            height: size.height * 0.5,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Container(
                                  width:
                                      100, // the actual width is not important here
                                  child: CameraPreview(_controller!)),
                            ));
                      } else {
                        // Otherwise, display a loading indicator.
                        return const Center(child: CircularProgressIndicator());
                      }
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
                            if (widget.camera!.length > 1) {
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
                            if (widget.camera!.length > 1) {
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
                capturedImages.length >= 2
                    ? Positioned(
                        bottom: 180,
                        left: 50,
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: WhiteColor,
                                width: 3,
                              )),
                        ),
                      )
                    : Positioned(
                        bottom: 160,
                        left: 100,
                        child: Container(
                          width: 200,
                          height: 350,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: WhiteColor,
                                width: 3,
                              )),
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
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: WhiteColor, width: 4),
                                  border: capturedImages.isNotEmpty
                                      ? Border.all(
                                          color: GPrimaryColor, width: 2)
                                      : Border.all(color: WhiteColor, width: 2),
                                  color: Colors.white.withOpacity(0.4),
                                  image: capturedImages.isNotEmpty
                                      ? DecorationImage(
                                          image: FileImage(capturedImages[0]),
                                          fit: BoxFit.cover)
                                      : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "ด้านหน้า",
                                  style: TextStyle(
                                      color: GPrimaryColor, fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: WhiteColor, width: 4),
                                  border: capturedImages.isNotEmpty &&
                                          capturedImages.length >= 2
                                      ? Border.all(
                                          color: GPrimaryColor, width: 2)
                                      : Border.all(color: WhiteColor, width: 2),
                                  color: Colors.white.withOpacity(0.4),
                                  image: capturedImages.isNotEmpty &&
                                          capturedImages.length > 1
                                      ? DecorationImage(
                                          image: FileImage(capturedImages[1]),
                                          fit: BoxFit.cover)
                                      : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "ด้านหลัง",
                                  style: TextStyle(
                                      color: GPrimaryColor, fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: WhiteColor, width: 4),
                                  border: capturedImages.isNotEmpty &&
                                          capturedImages.length >= 3
                                      ? Border.all(
                                          color: GPrimaryColor, width: 2)
                                      : Border.all(color: WhiteColor, width: 2),
                                  color: Colors.white.withOpacity(0.4),
                                  image: capturedImages.isNotEmpty &&
                                          capturedImages.length > 2
                                      ? DecorationImage(
                                          image: FileImage(capturedImages[2]),
                                          fit: BoxFit.cover)
                                      : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "ด้านล่าง",
                                  style: TextStyle(
                                      color: GPrimaryColor, fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  // border: Border.all(color: WhiteColor, width: 4),
                                  border: capturedImages.isNotEmpty &&
                                          capturedImages.length == 4
                                      ? Border.all(
                                          color: GPrimaryColor, width: 2)
                                      : Border.all(color: WhiteColor, width: 2),
                                  color: Colors.white.withOpacity(0.4),
                                  image: capturedImages.isNotEmpty &&
                                          capturedImages.length > 3
                                      ? DecorationImage(
                                          image: FileImage(capturedImages[3]),
                                          fit: BoxFit.cover)
                                      : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "ด้านบน",
                                  style: TextStyle(
                                      color: GPrimaryColor, fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            flex: 8,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
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
                              uploadImageAndUpdateState();
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
                                        images:
                                            capturedImages.reversed.toList())));
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: GPrimaryColor, width: 4),
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
                  ],
                ),
              ),
            ),
            flex: 3,
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