import 'package:flutter/material.dart';

class SuccessIconAnimation extends StatefulWidget {
  const SuccessIconAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SuccessIconAnimationState createState() => _SuccessIconAnimationState();
}

class _SuccessIconAnimationState extends State<SuccessIconAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Para detener la animación después de que se haya completado
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: const Icon(Icons.check_circle, color: Colors.green, size: 80),
    );
  }
}
