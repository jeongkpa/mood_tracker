import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EmotionBall extends StatelessWidget {
  final String name;
  final double? size;
  final bool isCore;

  const EmotionBall({
    super.key,
    required this.name,
    this.size,
    required this.isCore,
  });

  @override
  Widget build(BuildContext context) {
    final Color firstColor, secondColor;
    switch (name) {
      case "joy":
        firstColor = Colors.yellow.shade200;
        secondColor = Colors.yellow.shade600;
        break;
      case "sadness":
        firstColor = Colors.blue.shade50;
        secondColor = Colors.blue.shade200;
        break;
      case "disgust":
        firstColor = Colors.green.shade50;
        secondColor = Colors.green.shade200;
        break;
      case "anger":
        firstColor = Colors.red.shade50;
        secondColor = Colors.red.shade200;
        break;
      case "fear":
        firstColor = Colors.purple.shade50;
        secondColor = Colors.purple.shade200;
        break;
      default:
        firstColor = Colors.grey.shade200;
        secondColor = Colors.grey.shade400;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: size ?? 70,
            height: size ?? 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [firstColor, secondColor],
                radius: 0.5,
              ),
              // Remove border to avoid square background
              // border: Border.all(
              //   color: Colors.transparent,
              //   width: 2.0,
              // ),
            ),
          ),
        ),
        if (isCore)
          Shimmer.fromColors(
            baseColor: Colors.transparent,
            highlightColor: Colors.white,
            period: const Duration(milliseconds: 1500),
            child: Container(
              width: size ?? 70,
              height: size ?? 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
      ],
    );
  }
}
