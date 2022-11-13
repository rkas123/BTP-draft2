import 'package:flutter/material.dart';

import './button.dart';
import '../opencv_widgets/blur.dart';
import '../opencv_widgets/gaussianblur.dart';
import '../opencv_widgets/hough.dart';
import '../opencv_widgets/houghlinesprob.dart';
import '../opencv_widgets/sobel.dart';
import '../opencv_widgets/canny.dart';
import '../opencv_widgets/canny_cloud.dart';
import '../opencv_widgets/hough_cloud.dart';
import '../opencv_widgets/segmented_cloud.dart';
import '../opencv_widgets/yolo_cloud.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select the Operation')),
      body: GridView(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          Button(
              'Blur',
              (context) =>
                  Navigator.of(context).pushNamed(BlurWidget.routeName)),
          Button(
              'Gaussian Blur',
              (context) => Navigator.of(context)
                  .pushNamed(GaussianBlurWidget.routeName)),
          Button('Sobel',
              (context) => Navigator.of(context).pushNamed(Sobel.routeName)),
          Button('Canny Edge Detector',
              (context) => Navigator.of(context).pushNamed(Canny.routeName)),
          Button('Hough Transform',
              (context) => Navigator.of(context).pushNamed(Hough.routeName)),
          Button(
              'Hough Transform Probabilistic',
              (context) =>
                  Navigator.of(context).pushNamed(HoughProb.routeName)),
          Button(
              'Canny Cloud',
              (context) =>
                  Navigator.of(context).pushNamed(CannyCloud.routeName)),
          Button(
              'Segmented Cloud',
              (context) =>
                  Navigator.of(context).pushNamed(SegmentedCloud.routeName)),
          Button(
              'Hough Cloud',
              (context) =>
                  Navigator.of(context).pushNamed(HoughCloud.routeName)),
          Button(
              'Yolo Cloud',
              (context) =>
                  Navigator.of(context).pushNamed(YoloCloud.routeName)),

          // Button('Manual Testing', navigateToManualTesting),
          // Button('Perspective Transform', navigateToPerspective),
        ],
      ),
    );
  }
}
