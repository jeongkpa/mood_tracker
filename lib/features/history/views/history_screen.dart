import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/constants/gaps.dart';
import 'package:mood_tracker/features/history/view_models/history_view_model.dart';
import 'package:mood_tracker/features/history/views/emotion_detail_screen.dart';
import 'package:mood_tracker/features/history/views/setting_screen.dart';
import 'package:mood_tracker/features/posts/view_models/timeline_view_model.dart';
import 'package:mood_tracker/features/posts/views/widgets/emotion_ball.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  // TODO: 상단에 감정 통계

  // TODO: 특정 ball 선택시 modal 로 보여주기
  bool isInit = false;
  late int cntSum;
  late var cntEmotion;

  @override
  void initState() {
    super.initState();
    _resetCount();
  }

  void _resetCount() {
    cntSum = 0;
    cntEmotion = {
      "joy": 0,
      "sadness": 0,
      "disgust": 0,
      "fear": 0,
      "anger": 0,
    };
  }

  void _initCount(posts) {
    _resetCount();
    cntSum = posts.length;
    for (var post in posts) {
      if (cntEmotion.containsKey(post.emotionName)) {
        cntEmotion[post.emotionName] = cntEmotion[post.emotionName]! + 1;
      }
    }
    setState(() {});
  }

  void _onTapEmotion(post) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EmotionDetailScreen(post: post),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
            reverseCurve: Curves.easeInCirc,
          );
          return FadeTransition(
            opacity: curvedAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 1500),
        reverseTransitionDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  void _onTapSetting() {
    context.push(SettingsScreen.routeURL);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("History"),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: _onTapSetting,
              child: const FaIcon(FontAwesomeIcons.gear),
            ),
            Gaps.h10,
          ],
        ),
        body: ref.watch(historyProvider).when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  "could not load posts: $error",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              data: (posts) {
                _initCount(posts);
                return Column(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildEmotionIcon(
                            Icons.sentiment_very_satisfied, cntEmotion["joy"]!),
                        _buildEmotionIcon(Icons.sentiment_dissatisfied,
                            cntEmotion["sadness"]!),
                        _buildEmotionIcon(
                            Icons.sentiment_neutral, cntEmotion["disgust"]!),
                        _buildEmotionIcon(Icons.sentiment_very_dissatisfied,
                            cntEmotion["fear"]!),
                        _buildEmotionIcon(Icons.sentiment_very_dissatisfied,
                            cntEmotion["anger"]!,
                            color: Colors.red),
                      ],
                    ),
                    const Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(
                          bottom: 20,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          verticalDirection: VerticalDirection.up,
                          children: List.generate(
                            posts.length,
                            (index) {
                              return GestureDetector(
                                onTap: () => _onTapEmotion(posts[index]),
                                child: Hero(
                                  tag: posts[index].id,
                                  child: EmotionBall(
                                    name: posts[index].emotionName,
                                    isCore:
                                        posts[index].imgs?.isNotEmpty ?? false,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }

  Widget _buildEmotionIcon(IconData icon, int count, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.black, size: 30),
        Text(count.toString(), style: TextStyle(color: color ?? Colors.black)),
      ],
    );
  }
}

class EmotionBall extends StatelessWidget {
  final String name;
  final bool isCore;

  const EmotionBall({
    super.key,
    required this.name,
    required this.isCore,
  });

  @override
  Widget build(BuildContext context) {
    final emotionColors = {
      "joy": Colors.yellow.shade300,
      "sadness": Colors.blue.shade200,
      "disgust": Colors.green.shade200,
      "fear": Colors.purple.shade200,
      "anger": Colors.red.shade200,
    };

    final emotionIcons = {
      "joy": Icons.sentiment_very_satisfied,
      "sadness": Icons.sentiment_dissatisfied,
      "disgust": Icons.sentiment_neutral,
      "fear": Icons.sentiment_very_dissatisfied,
      "anger": Icons.sentiment_very_dissatisfied,
    };

    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: isCore ? 30 : 20,
        backgroundColor: emotionColors[name],
        child: Icon(
          emotionIcons[name],
          color: Colors.white,
          size: isCore ? 30 : 20,
        ),
      ),
    );
  }
}
