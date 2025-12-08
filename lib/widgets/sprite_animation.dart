import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SpriteAnimation extends StatefulWidget {
  final String spriteSheetPath;
  final int frameCount;
  final double frameWidth;
  final double frameHeight;
  final Duration animationDuration;

  const SpriteAnimation({
    Key? key,
    required this.spriteSheetPath,
    required this.frameCount,
    required this.frameWidth,
    required this.frameHeight,
    required this.animationDuration,
  }) : super(key: key);

  @override
  State<SpriteAnimation> createState() => _SpriteAnimationState();
}

class _SpriteAnimationState extends State<SpriteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();

    _animation = IntTween(
      begin: 0,
      end: widget.frameCount - 1,
    ).animate(_controller);
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
        return ClipRect(
          child: CustomPaint(
            size: Size(widget.frameWidth, widget.frameHeight),
            painter: SpritePainter(
              imagePath: widget.spriteSheetPath,
              frameIndex: _animation.value,
              frameWidth: widget.frameWidth,
              frameHeight: widget.frameHeight,
            ),
          ),
        );
      },
    );
  }
}

class SpritePainter extends CustomPainter {
  final String imagePath;
  final int frameIndex;
  final double frameWidth;
  final double frameHeight;
  ui.Image? _image;

  SpritePainter({
    required this.imagePath,
    required this.frameIndex,
    required this.frameWidth,
    required this.frameHeight,
  }) {
    _loadImage();
  }

  void _loadImage() {
    final imageProvider = AssetImage(imagePath);
    imageProvider.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((ImageInfo image, bool synchronousCall) {
        _image = image.image;
      }),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_image == null) return;

    final src = Rect.fromLTWH(
      frameIndex * frameWidth,
      0,
      frameWidth,
      frameHeight,
    );
    final dst = Rect.fromLTWH(0, 0, frameWidth, frameHeight);
    
    canvas.drawImageRect(_image!, src, dst, Paint());
  }

  @override
  bool shouldRepaint(SpritePainter oldDelegate) {
    return frameIndex != oldDelegate.frameIndex || _image != oldDelegate._image;
  }
}