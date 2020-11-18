import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:swipedetector/swipedetector.dart';

class ImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onSwipeRight: () {
        Get.back();
      },
      onSwipeUp: () {
        Get.back();
      },
      child: Scaffold(
        body: Stack(
          children: [
            PhotoView(
              imageProvider: CachedNetworkImageProvider(
                Get.arguments['url'],
              ),
              heroAttributes:
                  PhotoViewHeroAttributes(tag: 'hero-${Get.arguments['id']}'),
            ),
            Positioned(
              top: 25,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  Get.back();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
