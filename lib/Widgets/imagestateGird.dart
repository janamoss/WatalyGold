import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watalygold/Home/Model/Image_State.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/Quality/DialogWarningDel.dart';

class ImageGridItem extends StatelessWidget {
  final int index;
  final String label;
  final CapturedImage? image;

  const ImageGridItem({
    Key? key,
    required this.index,
    required this.label,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageState = context.watch<ImageState>();
    // print(imageState.capturedImages[index].statusMango);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: _handleTap(context, imageState),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  border: _getBorder(imageState),
                  color: Colors.white.withOpacity(0.4),
                  image: image != null
                      ? DecorationImage(
                          image: FileImage(image!.image),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _buildStatusIndicator(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                label,
                style: TextStyle(color: GPrimaryColor, fontSize: 20),
              ),
            ),
          ],
        ),
        if (image != null &&
            image!.statusMango == 1 &&
            image!.statusMangoColor == 1)
          _buildDeleteButton(context, imageState),
      ],
    );
  }

  VoidCallback? _handleTap(BuildContext context, ImageState imageState) {
    if (image == null) {
      print(imageState.selectedStatus);
      return () => imageState.setSelectedStatus(index + 1);
    }
    if ((image!.statusMango == 0 && image!.statusMangoColor == 0) ||
        (image!.statusMango == 1 && image!.statusMangoColor == 0)) {
      print(2);
      return null;
    }
    if (image!.statusMango == 1 && image!.statusMangoColor == 1) {
      print(3);
      return null;
    }
    return () {
      print("ทำงาน");
      imageState.removeCapturedImage(image!);
      imageState.setSelectedStatus(index + 1);
    };
  }

  Border _getBorder(ImageState imageState) {
    if (image != null) {
      // กรณีมีรูปภาพ
      return Border.all(
        color: (image!.statusMango == 2 || image!.statusMangoColor == 2)
            ? Colors.red.shade400 // สถานะไม่ผ่าน
            : GPrimaryColor, // สถานะปกติ
        width: 2,
      );
    } else {
      // กรณีไม่มีรูปภาพ
      return Border.all(
        color: imageState.selectedStatus == index + 1
            ? Colors.cyan.shade400 // ถูกเลือก
            : WhiteColor, // ไม่ถูกเลือก
        width: 2,
      );
    }
  }

  Widget _buildStatusIndicator() {
    if (image == null) return Container();

    if ((image!.statusMango == 0 && image!.statusMangoColor == 0) ||
        (image!.statusMango == 1 && image!.statusMangoColor == 0)) {
      return Center(child: CircularProgressIndicator(color: GPrimaryColor));
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(radius: 15, backgroundColor: Colors.white),
          Icon(
            image!.statusMango == 1 && image!.statusMangoColor == 1
                ? Icons.check
                : Icons.close,
            size: 20,
            weight: 10,
            color: image!.statusMango == 1 && image!.statusMangoColor == 1
                ? GPrimaryColor
                : Colors.red.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, ImageState imageState) {
    return Positioned(
      top: -10,
      right: -5,
      child: GestureDetector(
        onTap: () async {
          imageState.setSelectedStatus(index + 1);
          final result = await showDialog(
            context: context,
            builder: (context) => Dialogwarningdel(message: label),
          );
          if (result == true) {
            imageState.removeCapturedImage(image!);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade700,
          ),
          child: Icon(Icons.close, size: 15, color: WhiteColor),
        ),
      ),
    );
  }
}
