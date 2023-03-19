import 'package:camera_test/opencv_widgets/deph_estimation.dart';
import 'package:camera_test/widgets/changeurlscreen.dart';
import 'package:camera_test/widgets/speech_to_text.dart';
import 'package:flutter/material.dart';

import './button.dart';
import '../opencv_widgets/houghlinesprob.dart';
import '../opencv_widgets/canny.dart';
import '../opencv_widgets/hough_cloud.dart';
import '../opencv_widgets/segmented_cloud.dart';
import '../opencv_widgets/yolo_cloud.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select the Operation'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ChangeUrlScreen.routeName);
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: GridView(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          Button('Canny Edge Detector',
              (context) => Navigator.of(context).pushNamed(Canny.routeName)),
          Button(
              'Hough Transform Probabilistic',
              (context) =>
                  Navigator.of(context).pushNamed(HoughProb.routeName)),

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
          Button(
              'Depth Estimation',
              (context) => Navigator.of(context).pushNamed(
                    DepthEstimation.routeName,
                  )),
          Button(
            'Voice Assist',
            (context) => Navigator.of(context).pushNamed(VoiceAssist.routeName),
          )

          // Button('Manual Testing', navigateToManualTesting),
          // Button('Perspective Transform', navigateToPerspective),
        ],
      ),
    );
  }
}
