import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:watalygold/Widgets/Color.dart';

class DialogLoading extends StatelessWidget {
  const DialogLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        backgroundColor: WhiteColor.withOpacity(0.4),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        title: Column(
          children: [
            Text(
              'กรุณารอสักครู่...',
              style: TextStyle(color: WhiteColor),
              textAlign:
                  TextAlign.center, // Add this line to center the title text
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
    );
  }
}
