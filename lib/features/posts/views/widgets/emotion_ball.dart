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
    const Color firstColor = Color(0xFFFFE0B2); // Light skin tone
    const Color secondColor = Color(0xFFFFCC80); // Darker skin tone

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: size ?? 70,
            height: size ?? 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [firstColor, secondColor],
                radius: 0.5,
              ),
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
