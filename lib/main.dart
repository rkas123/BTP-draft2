import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import './widgets/blur.dart';
import './widgets/gaussianblur.dart';
import './widgets/hough.dart';
import './widgets/mainpage.dart';
import './widgets/houghlinesprob.dart';
import './widgets/sobel.dart';

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
        BlurWidget.routeName: (ctx) => BlurWidget(_cameras)
      },
    );
  }
}
