import 'dart:async';

import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration speed;
  final VoidCallback? onComplete;

  const TypewriterText({
    Key? key,
    required this.text,
    this.style,
    this.speed = const Duration(milliseconds: 50),
    this.onComplete,
  }) : super(key: key);

  @override
  TypewriterTextState createState() => TypewriterTextState();
}

class TypewriterTextState extends State<TypewriterText> {
  int _visibleLength = 0;
  Timer? _timer;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_visibleLength >= widget.text.length) {
        _timer?.cancel();
        _isCompleted = true;
        widget.onComplete?.call();
      } else {
        setState(() {
          _visibleLength++;
        });
      }
    });
  }

  /// Call this to immediately show full text and stop animation
  void skip() {
    if (!_isCompleted) {
      _timer?.cancel();
      setState(() {
        _visibleLength = widget.text.length;
        _isCompleted = true;
      });
      widget.onComplete?.call();
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.text.substring(0, _visibleLength), style: widget.style);
  }
}
