import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'opencv_widgets/blur.dart';
import 'opencv_widgets/canny.dart';
import 'opencv_widgets/gaussianblur.dart';
import 'opencv_widgets/hough.dart';
import 'opencv_widgets/houghlinesprob.dart';
import 'opencv_widgets/sobel.dart';
import 'opencv_widgets/canny_cloud.dart';
import 'opencv_widgets/segmented_cloud.dart';
import 'opencv_widgets/hough_cloud.dart';
import 'opencv_widgets/yolo_cloud.dart';
import 'opencv_widgets/deph_estimation.dart';

import './widgets/mainpage.dart';
import './widgets/changeurlscreen.dart';

List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.removeAfter(initialization);
  runApp(const MyApp());
}

Future initialization(BuildContext context) async {
  _cameras = await availableCameras();
  await Future.delayed(Duration(seconds: 2));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String baseUrl = 'http://192.168.43.35:5000';

  void updateUrl(String newUrl) {
    setState(() => baseUrl = newUrl);
    print(newUrl);
  }

  @override
  Widget build(BuildContext context) {
    print('url is ${baseUrl}');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        Hough.routeName: (ctx) => Hough(_cameras),
        HoughProb.routeName: (ctx) => HoughProb(_cameras),
        Sobel.routeName: (ctx) => Sobel(_cameras),
        GaussianBlurWidget.routeName: (ctx) => GaussianBlurWidget(_cameras),
        BlurWidget.routeName: (ctx) => BlurWidget(_cameras),
        Canny.routeName: (ctx) => Canny(_cameras),
        CannyCloud.routeName: (ctx) => CannyCloud(_cameras, baseUrl),
        SegmentedCloud.routeName: (ctx) => SegmentedCloud(_cameras, baseUrl),
        HoughCloud.routeName: (ctx) => HoughCloud(_cameras, baseUrl),
        YoloCloud.routeName: (ctx) => YoloCloud(_cameras, baseUrl),
        DepthEstimation.routeName: (ctx) => DepthEstimation(_cameras, baseUrl),
        ChangeUrlScreen.routeName: (ctx) => ChangeUrlScreen(
              updateUrl: updateUrl,
              existingUrl: baseUrl,
            ),
      },
    );
  }
}
