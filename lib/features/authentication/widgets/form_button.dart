import 'package:flutter/material.dart';
import 'package:mood_tracker/constants/sizes.dart';
import 'package:mood_tracker/utils.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.disabled,
    this.text,
  });

  final bool disabled;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size5),
          color: disabled
              ? isDarkMode(context)
                  ? Colors.grey.shade800
                  : Colors.grey.shade300
              : Theme.of(context).primaryColor,
        ),
        duration: const Duration(
          milliseconds: 500,
          // seconds: 5,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(
            milliseconds: 500,
            // seconds: 5,
          ),
          style: TextStyle(
            color: disabled ? Colors.grey.shade400 : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          child: Text(
            text ?? "Next",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
