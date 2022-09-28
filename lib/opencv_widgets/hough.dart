import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opencv/opencv.dart';

class Hough extends StatefulWidget {
  static String routeName = '/hough';
  final List<CameraDescription> _cameras;
  const Hough(this._cameras, {Key key}) : super(key: key);

  @override
  State<Hough> createState() => _HoughState();
}

class _HoughState extends State<Hough> {
  CameraController controller;
  Future<void> _initializeControllerFuture;
  XFile imgFile;
  Image outputImage;
  @override
  void initState() {
    super.initState();
    imgFile = null;
    outputImage = null;
    controller = CameraController(widget._cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = controller.initialize();
    controller.setFlashMode(FlashMode.off);
    clickPicture();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void clickPicture() async {
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await controller.takePicture();

      if (!mounted) return;
      setState(() {
        imgFile = image;
      });
      hough();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void hough() async {
    var oImage =
        await ImgProc.gaussianBlur(await imgFile.readAsBytes(), [11, 11], 0);
    // var oImage;
    oImage = await ImgProc.canny(oImage, 50, 150);
    oImage = await ImgProc.houghLines(await oImage,
        threshold: 100, lineColor: "#ff0000");
    // oImage = await ImgProc.canny(await oImage, 50, 200);
    setState(() {
      outputImage = Image.memory(oImage);
    });
    clickPicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hough Transform'),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Actual Image'),
                if (imgFile != null)
                  SizedBox(
                    height: 275,
                    child: Image.file(File(imgFile.path)),
                  ),
                const Text('Output Image'),
                if (outputImage != null)
                  SizedBox(
                    height: 275,
                    child: outputImage,
                  ),
              ],
            ),
          ),
        ));
  }
}