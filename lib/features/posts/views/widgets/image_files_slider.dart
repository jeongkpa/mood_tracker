import 'dart:io';

import 'package:flutter/material.dart';

class ImageFilesSlider extends StatelessWidget {
  const ImageFilesSlider({
    super.key,
    required this.imgs,
  });

  final List<File> imgs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller:
            imgs.length > 1 ? PageController(viewportFraction: 0.9) : null,
        itemCount: imgs.length,
        padEnds: false,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.file(
              imgs[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
