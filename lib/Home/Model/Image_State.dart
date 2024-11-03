import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CapturedImage {
  final File image;
  final int statusimage;
  int statusMango;
  int statusMangoColor;
  String? downloadurl;

  CapturedImage({
    required this.image,
    required this.statusimage,
    this.statusMango = 0,
    this.statusMangoColor = 0,
  });
}

class ImageState extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  List<CapturedImage> capturedImages = [];
  int selectedStatus = 1;

  Future<void> pickImagesFromGallery({
    required Function(String) onError,
    required Function() onNoInternet,
    required Future<void> Function(File, int) analyzeImage,
    required Future<bool> Function() checkInternetConnection,
  }) async {
    try {
      final List<XFile> images = 
          await _picker.pickMultiImage(imageQuality: 60);

      if (images.isNotEmpty) {
        // จำกัดจำนวนรูปไม่เกิน 4 รูป
        List<XFile> selectedImages = images.length > 4
            ? images.sublist(0, 4)
            : images;

        Set<int> existingStatusImages =
            capturedImages.map((image) => image.statusimage).toSet();

        List<Future<void>> analysisFutures = [];

        for (int i = 0; i < selectedImages.length; i++) {
          int nextAvailableStatus = 1;
          while (existingStatusImages.contains(nextAvailableStatus)) {
            nextAvailableStatus++;
          }

          File imageFile = File(selectedImages[i].path);

          // เพิ่มรูปภาพใหม่โดยใช้ addCapturedImage ที่มีอยู่แล้ว
          addCapturedImage(imageFile, nextAvailableStatus);
          existingStatusImages.add(nextAvailableStatus);

          // เพิ่มงานวิเคราะห์รูปภาพเข้าไปในคิว
          analysisFutures.add(analyzeImage(imageFile, nextAvailableStatus));
        }

        // ตรวจสอบการเชื่อมต่ออินเทอร์เน็ต
        bool noInternet = await checkInternetConnection();
        if (noInternet) {
          onNoInternet();
          return;
        }

        // ดำเนินการวิเคราะห์รูปภาพทั้งหมด
        await Future.wait(analysisFutures);
      }
    } on PlatformException catch (e) {
      onError(e.toString());
    }
  }

  void updateStatusMangoColor(int statusImage, int result) {
    final imageIndex =
        capturedImages.indexWhere((img) => img.statusimage == statusImage);
    if (imageIndex != -1) {
      capturedImages[imageIndex].statusMangoColor = result;
      notifyListeners();
    }
  }

  void updateStatusMango(int statusImage, int result) {
    final imageIndex =
        capturedImages.indexWhere((img) => img.statusimage == statusImage);
    if (imageIndex != -1) {
      capturedImages[imageIndex].statusMango = result;
      notifyListeners();
    }
  }

  void removeCapturedImage(CapturedImage image) {
    capturedImages.remove(image);
    notifyListeners();
  }

  void setSelectedStatus(int status) {
    selectedStatus = status;
    notifyListeners();
  }

  void addCapturedImage(File image, int statusN) {
    capturedImages.add(CapturedImage(
      statusimage: statusN,
      image: File(image.path),
      statusMango: 0,
      statusMangoColor: 0,
    ));

    // หา statusimage ที่ยังว่างอยู่
    Set<int> existingStatusImages =
        capturedImages.map((image) => image.statusimage).toSet();
    List<int> availableStatusImages = [1, 2, 3, 4]
        .where((number) => !existingStatusImages.contains(number))
        .toList();

    // อัพเดท selectedStatus
    if (availableStatusImages.isNotEmpty) {
      selectedStatus = availableStatusImages.first;
    } else {
      debugPrint("ครบ 4 รูปแล้วค่า");
    }

    notifyListeners();
  }

  void imageclean() {
    capturedImages = [];
    notifyListeners();
  }

  List<CapturedImage> get getSortedImages {
    final sortedList = [...capturedImages]..sort(
      (a, b) => a.statusimage.compareTo(b.statusimage)
    );
    return sortedList;
  }

  // เมธอดสำหรับดึงเฉพาะ File จากรูปภาพที่เรียงแล้ว
  List<File> get getSortedImageFiles {
    return getSortedImages.map((captured) => captured.image).toList();
  }

  bool get isImagesFull => capturedImages.length == 4;

  bool get isAllImagesComplete {
    return capturedImages.length == 4 &&
        capturedImages
            .map((image) => image.statusimage)
            .toSet()
            .containsAll([1, 2, 3, 4]) &&
        capturedImages.every(
            (image) => image.statusMango == 1 && image.statusMangoColor == 1);
  }
  // ดึงรูปภาพทั้งหมด
  List<CapturedImage> get getAllImages => capturedImages;
}
