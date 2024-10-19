import 'package:flutter/material.dart';

class LongPressDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onLongPressEnd;
  final Duration duration;

  const LongPressDetector({
    Key? key,
    required this.child,
    required this.onLongPressEnd,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _LongPressDetectorState createState() => _LongPressDetectorState();
}

class _LongPressDetectorState extends State<LongPressDetector> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLongPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onLongPressEnd();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startLongPress() {
    setState(() {
      _isLongPressed = true;
    });
    _controller.forward();
  }

  void _endLongPress() {
    setState(() {
      _isLongPressed = false;
    });
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startLongPress(),
      onLongPressEnd: (_) => _endLongPress(),
      child: Stack(
        children: [
          widget.child,
          if (_isLongPressed)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange.withOpacity(_controller.value),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}