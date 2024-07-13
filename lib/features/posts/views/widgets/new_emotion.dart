import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/constants/sizes.dart';
import 'package:mood_tracker/features/posts/views/widgets/emotion_icon.dart';

class NewEmotion extends ConsumerStatefulWidget {
  const NewEmotion({required this.selectEmotion, super.key});
  final Function selectEmotion;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewEmotionState();
}

class _NewEmotionState extends ConsumerState<NewEmotion> {
  void _onTapButton(emotion) {
    widget.selectEmotion(emotion);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "What's your mood?",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          // Gaps.v20,
          Expanded(
            child: ListWheelScrollView(
              diameterRatio: 1.5,
              offAxisFraction: 0,
              itemExtent: 200,
              children: [
                for (var emotion in [
                  'joy',
                  'disgust',
                  'fear',
                  'anger',
                  'sadness',
                ])
                  GestureDetector(
                    onTap: () => _onTapButton(emotion),
                    child: Container(
                      // width: 100,
                      // height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      )),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmotionIcon(
                            name: emotion,
                            size: 100,
                          ),
                          Text(
                            emotion,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRadiusButton extends StatelessWidget {
  final bool radiusTop;
  final bool radiusBottom;
  final String text;
  final Function onTap;
  final Color? textColor;
  const CustomRadiusButton({
    super.key,
    required this.radiusTop,
    required this.radiusBottom,
    required this.text,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: radiusTop
                ? const Border(
                    bottom: BorderSide(
                      width: 0.4,
                      color: Color(0xffbbbbbb),
                    ),
                  )
                : null,
            borderRadius: BorderRadius.only(
              topLeft: radiusTop
                  ? const Radius.circular(
                      Sizes.size24,
                    )
                  : Radius.zero,
              topRight: radiusTop
                  ? const Radius.circular(
                      Sizes.size24,
                    )
                  : Radius.zero,
              bottomLeft: radiusBottom
                  ? const Radius.circular(
                      Sizes.size24,
                    )
                  : Radius.zero,
              bottomRight: radiusBottom
                  ? const Radius.circular(
                      Sizes.size24,
                    )
                  : Radius.zero,
            ),
          ),
          padding: const EdgeInsets.all(
            Sizes.size20,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: Sizes.size18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
