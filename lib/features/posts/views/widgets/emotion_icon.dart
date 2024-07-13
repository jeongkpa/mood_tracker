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
    final Color emojiColor;
    switch (name) {
      case "joy":
        emoji = AnimatedEmojis.grin;
        emojiColor = Colors.yellow;
        break;
      case "sadness":
        emoji = AnimatedEmojis.cry;
        emojiColor = Colors.blue;
        break;
      case "disgust":
        emoji = AnimatedEmojis.raisedEyebrow;
        emojiColor = Colors.green;
        break;
      case "anger":
        emoji = AnimatedEmojis.rage;
        emojiColor = Colors.red;
        break;
      case "fear":
        emoji = AnimatedEmojis.anguished;
        emojiColor = Colors.purple;
        break;
      default:
        emoji = AnimatedEmojis.wink;
        emojiColor = Colors.grey;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(emojiColor, BlendMode.hue),
        child: Container(
          color: isDarkMode(context) ? Colors.black : Colors.white,
          child: AnimatedEmoji(
            emoji,
            size: size ?? 80,
            animate: true,
            // repeat: false,
          ),
        ),
      ),
    );
  }
}
