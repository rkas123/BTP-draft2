import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'opencv_widgets/blur.dart';
import 'opencv_widgets/canny.dart';
import 'opencv_widgets/gaussianblur.dart';
import 'opencv_widgets/hough.dart';
import 'opencv_widgets/houghlinesprob.dart';
import 'opencv_widgets/sobel.dart';

import './widgets/mainpage.dart';

List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: {
        Hough.routeName: (ctx) => Hough(_cameras),
        HoughProb.routeName: (ctx) => HoughProb(_cameras),
        Sobel.routeName: (ctx) => Sobel(_cameras),
        GaussianBlurWidget.routeName: (ctx) => GaussianBlurWidget(_cameras),
        BlurWidget.routeName: (ctx) => BlurWidget(_cameras),
        Canny.routeName: (ctx) => Canny(_cameras),
      },
    );
  }
}
