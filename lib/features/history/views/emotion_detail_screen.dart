import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mood_tracker/constants/gaps.dart';
import 'package:mood_tracker/features/posts/models/post_model.dart';
import 'package:mood_tracker/features/posts/views/widgets/emotion_ball.dart';
import 'package:mood_tracker/features/posts/views/widgets/images_slider.dart';
import 'package:timeago/timeago.dart' as timeago;

class EmotionDetailScreen extends StatelessWidget {
  final PostModel post;
  const EmotionDetailScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          DateTime.fromMillisecondsSinceEpoch(post.createdAt)
              .toString()
              .split(" ")
              .first,
        ),
        automaticallyImplyLeading: false,
        actions: const [
          CloseButton(),
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Hero(
                  tag: post.id,
                  child: Transform.scale(
                    scale: 3,
                    child: EmotionBall(
                      name: post.emotionName,
                      isCore: false,
                      size: size.width,
                    ),
                  ),
                ),
                SizedBox(
                  // color: Colors.white,
                  width: double.infinity,
                  // height: double.infinity,
                  // alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (post.imgs != null && post.imgs!.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: ImagesSlider(
                            imgs: post.imgs!,
                          ),
                        ),
                      Text(
                        post.content,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms, delay: 1500.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
