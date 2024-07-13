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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "당신의 감정을 선택해주세요",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: PageController(viewportFraction: 0.8),
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
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EmotionIcon(
                            name: emotion,
                            size: 100,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            emotion,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
