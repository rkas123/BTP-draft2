import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opencv/opencv.dart';

class HoughProb extends StatefulWidget {
  static String routeName = '/houghlinesP';
  final List<CameraDescription> _cameras;
  const HoughProb(this._cameras, {Key key}) : super(key: key);

  @override
  State<HoughProb> createState() => _HoughProbState();
}

class _HoughProbState extends State<HoughProb> {
  CameraController controller;
  Future<void> _initializeControllerFuture;
  XFile imgFile;
  Image outputImage;
  // Image blurImage;
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
    // var temp = oImage;
    oImage = await ImgProc.canny(await oImage, 50, 200);
    oImage = await ImgProc.houghLinesProbabilistic(await oImage,
        rho: 2,
        threshold: 100,
        minLineLength: 50,
        maxLineGap: 10,
        lineColor: "#ff0000");
    setState(() {
      outputImage = Image.memory(oImage);
      // blurImage = Image.memory(temp);
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
                // Text('Blur Image'),
                // if (blurImage != null)
                //   Container(
                //     height: 275,
                //     child: blurImage,
                //   ),
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
