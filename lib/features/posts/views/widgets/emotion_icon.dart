import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/utils.dart';

class EmotionIcon extends StatelessWidget {
  final String name;
  final double? size;
  const EmotionIcon({
    super.key,
    required this.name,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final AnimatedEmojiData emoji;
    const Color emojiColor = Color(0xFFFFCC80); // 동양인 피부 톤 색상

    switch (name) {
      case "joy":
        emoji = AnimatedEmojis.grin;
        break;
      case "sadness":
        emoji = AnimatedEmojis.cry;
        break;
      case "disgust":
        emoji = AnimatedEmojis.raisedEyebrow;
        break;
      case "anger":
        emoji = AnimatedEmojis.rage;
        break;
      case "fear":
        emoji = AnimatedEmojis.anguished;
        break;
      default:
        emoji = AnimatedEmojis.wink;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(emojiColor, BlendMode.modulate),
        child: Container(
          color: isDarkMode(context) ? Colors.black : Colors.white,
          child: AnimatedEmoji(
            emoji,
            size: size ?? 80,
            animate: true,
          ),
        ),
      ),
    );
  }
}
