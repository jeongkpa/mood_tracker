import 'package:flutter/material.dart';
import 'package:mood_tracker/features/posts/views/widgets/new_post.dart';
import 'package:mood_tracker/features/posts/views/widgets/new_emotion.dart';

class ModalSheet extends StatefulWidget {
  const ModalSheet({super.key});

  @override
  State<ModalSheet> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  int _index = 0;
  late String _emotion;

  void changeIndex(index) {
    setState(() {
      _index = index;
    });
  }

  void selectEmotion(emotion) {
    setState(() {
      _emotion = emotion;
      _index = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(sizeFactor: animation, child: child);
      },
      child: _index == 0
          ? NewEmotion(selectEmotion: selectEmotion)
          : NewPost(selectIndex: changeIndex, emotionName: _emotion),
    );
  }
}
