import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceWaveVisualizer extends StatefulWidget {
  final bool isActive;
  final Color color;

  const VoiceWaveVisualizer({
    Key? key,
    required this.isActive,
    required this.color,
  }) : super(key: key);

  @override
  State<VoiceWaveVisualizer> createState() => _VoiceWaveVisualizerState();
}

class _VoiceWaveVisualizerState extends State<VoiceWaveVisualizer> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  final int _barsCount = 5;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _barsCount,
          (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + _random.nextInt(600)),
      ),
    );
    _startAnimation();
  }

  void _startAnimation() {
    for (var controller in _controllers) {
      controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VoiceWaveVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        for (var controller in _controllers) {
          controller.repeat(reverse: true);
        }
      } else {
        for (var controller in _controllers) {
          controller.stop();
          controller.animateTo(0.0);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _barsCount,
            (index) => AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: 3.w,
              height: widget.isActive
                  ? (20 + _controllers[index].value * 30).h
                  : 20.h,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(5.r),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}