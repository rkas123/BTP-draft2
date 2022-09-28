import 'package:flutter/material.dart';

import './button.dart';
import './blur.dart';
import './gaussianblur.dart';
import './hough.dart';
import './houghlinesprob.dart';
import './sobel.dart';

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
          Button('Hough Transform',
              (context) => Navigator.of(context).pushNamed(Hough.routeName)),
          Button(
              'Hough Transform Probabilistic',
              (context) =>
                  Navigator.of(context).pushNamed(HoughProb.routeName)),
          // Button('Manual Testing', navigateToManualTesting),
          // Button('Perspective Transform', navigateToPerspective),
        ],
      ),
    );
  }
}
