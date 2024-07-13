import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/constants/gaps.dart';
import 'package:mood_tracker/features/history/view_models/history_view_model.dart';
import 'package:mood_tracker/features/history/views/emotion_detail_screen.dart';
import 'package:mood_tracker/features/history/views/setting_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool isInit = false;
  late int cntSum;
  late Map<String, int> cntEmotion;

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("감정 기록 횟수"),
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
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    const style = TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    );
                                    Widget text;
                                    switch (value.toInt()) {
                                      case 0:
                                        text = const Text('Joy', style: style);
                                        break;
                                      case 1:
                                        text =
                                            const Text('Sadness', style: style);
                                        break;
                                      case 2:
                                        text =
                                            const Text('Disgust', style: style);
                                        break;
                                      case 3:
                                        text = const Text('Fear', style: style);
                                        break;
                                      case 4:
                                        text =
                                            const Text('Anger', style: style);
                                        break;
                                      default:
                                        text = const Text('');
                                        break;
                                    }
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: text,
                                    );
                                  },
                                  reservedSize: 28,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    const style = TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    );
                                    return Text('${value.toInt()}',
                                        style: style);
                                  },
                                  reservedSize: 40,
                                ),
                              ),
                            ),
                            gridData: const FlGridData(
                              show: false,
                            ),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: cntEmotion["joy"]!.toDouble(),
                                    color: Colors.yellow.shade600,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: cntEmotion["sadness"]!.toDouble(),
                                    color: Colors.blue.shade600,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: cntEmotion["disgust"]!.toDouble(),
                                    color: Colors.green.shade600,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [
                                  BarChartRodData(
                                    toY: cntEmotion["fear"]!.toDouble(),
                                    color: Colors.purple.shade600,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 4,
                                barRods: [
                                  BarChartRodData(
                                    toY: cntEmotion["anger"]!.toDouble(),
                                    color: Colors.red.shade600,
                                  ),
                                ],
                              ),
                            ],
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
