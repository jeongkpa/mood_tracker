import 'package:flutter/material.dart';
import 'package:mood_tracker/constants/gaps.dart';
import 'package:mood_tracker/constants/sizes.dart';
import 'package:mood_tracker/features/posts/views/widgets/emotion_icon.dart';
import 'package:mood_tracker/features/posts/views/widgets/images_slider.dart';
import 'package:timeago/timeago.dart' as timeago;

class Post extends StatelessWidget {
  final String emotionName;
  final String content;
  final int createdAt;
  final List<String> imgs;
  const Post({
    super.key,
    required this.createdAt,
    required this.emotionName,
    required this.content,
    required this.imgs,
  });

  void _onMoreTap(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      // barrierColor: Colors.red,
      // backgroundColor: Colors.transparent,
      builder: (context) => Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                EmotionIcon(
                  name: emotionName,
                  size: 60,
                ),
                SizedBox(
                  width: 60,
                  height: 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 60,
                  child: Opacity(
                    opacity: 0.7,
                    child: Text(
                      timeago.format(
                        DateTime.fromMillisecondsSinceEpoch(createdAt),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                Gaps.h10,
              ],
            ),
            Gaps.h10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              emotionName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _onMoreTap(context),
                        child: const Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          Sizes.size20,
                        ),
                        topRight: Radius.circular(
                          Sizes.size20,
                        ),
                        bottomLeft: Radius.circular(
                          Sizes.size20,
                        ),
                        bottomRight: Radius.circular(
                          Sizes.size20,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            content,
                            style: const TextStyle(
                                // color: Colors.grey.shade800,
                                ),
                          ),
                        ),
                        Gaps.v10,
                        // Post image
                        if (imgs.isNotEmpty) ImagesSlider(imgs: imgs),
                        // Action buttons
                      ],
                    ),
                  ),

                  Gaps.v10,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
