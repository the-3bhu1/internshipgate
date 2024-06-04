import 'package:flutter/material.dart';

class RectangleTile extends StatelessWidget {
  final String imagePath;

  const RectangleTile({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100, // Increase the height to make the image larger
      width: 330,  // Increase the width to make the image wider
      // padding: const EdgeInsets.all(20),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover, // You can choose how the image fits within the container
      ),
    );
  }
}
