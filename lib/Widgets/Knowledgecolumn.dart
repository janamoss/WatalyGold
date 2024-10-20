import 'dart:io';

import 'package:flutter/material.dart';
import 'package:watalygold/Widgets/Color.dart';
import 'package:watalygold/Widgets/Contentcol.dart';
import 'package:watalygold/models/knowledge.dart';

class KnowlegdeCol extends StatefulWidget {
  const KnowlegdeCol(
      {super.key,
      required this.title,
      required this.icons,
      required this.ismutible,
      this.subtitile,
      this.onTap,
      this.contents});

  final String title;
  final IconData icons;
  final bool ismutible;
  final List<String>? subtitile;
  final void Function()? onTap;
  final List<dynamic>? contents;
  @override
  State<KnowlegdeCol> createState() => _KnowlegdeColState();
}

class _KnowlegdeColState extends State<KnowlegdeCol> {
  bool _showDropdown = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: GestureDetector(
            onTap: () {
              // Show the dropdown menu
              setState(() {
                _showDropdown = !_showDropdown;
              });
              stdout.writeln("tap");
              widget.onTap?.call();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: WhiteColor,
              ),
              child: Column(
                children: [
                  ListTile(
                      leading: Icon(widget.icons, color: GPrimaryColor),
                      title: Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: widget.ismutible
                          ? RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                _showDropdown
                                    ? Icons.keyboard_arrow_left_rounded
                                    : Icons.keyboard_arrow_right_rounded,
                                color: GPrimaryColor,
                              ),
                            )
                          : RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: GPrimaryColor,
                              ),
                            )),
                  _showDropdown
                      ? Column(
                          children: [
                            for (var content in widget.contents! )
                              Contentcol(
                                icons: widget.icons,
                                ContentID: content.toString(),
                              ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          )),
    );
  }
}
