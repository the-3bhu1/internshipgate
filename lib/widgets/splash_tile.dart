import 'package:flutter/material.dart';

class SplashTile extends StatelessWidget {
  final String imagePath;

  const SplashTile({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 400, // Increase the height to make the image larger
      width: 400,  // Increase the width to make the image wider
      // padding: const EdgeInsets.all(20),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover, // You can choose how the image fits within the container
      ),
    );
  }
}
