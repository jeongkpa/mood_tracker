import 'package:flutter/material.dart';

class ImagesSlider extends StatelessWidget {
  const ImagesSlider({
    super.key,
    required this.imgs,
  });

  final List<String> imgs;

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
            child: Image.network(
              imgs[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
