import 'package:flutter/material.dart';

class AnimatedCoin extends StatefulWidget {
  final VoidCallback onEnd;

  const AnimatedCoin({super.key, required this.onEnd});

  @override
  State<AnimatedCoin> createState() => _AnimatedCoinState();
}

class _AnimatedCoinState extends State<AnimatedCoin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  )..forward();

  late final Animation<double> _animation = Tween(begin: 0.0, end: -100.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onEnd(); // Remove overlay when done
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Opacity(
            opacity: 1 - (_animation.value.abs() / 100),
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.monetization_on,
        color: Colors.amber,
        size: 32,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
