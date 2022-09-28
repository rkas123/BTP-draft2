import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';

class Perspective extends StatefulWidget {
  final List<CameraDescription> _cameras;
  const Perspective(this._cameras, {Key key}) : super(key: key);

  @override
  State<Perspective> createState() => _SobelState();
}

class _SobelState extends State<Perspective> {
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
      perspective();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void perspective() async {
    final oImage = await ImgProc.warpPerspectiveTransform(
        await imgFile.readAsBytes(),
        sourcePoints: [113, 137, 260, 137, 138, 379, 271, 340],
        destinationPoints: [0, 0, 612, 0, 0, 459, 612, 459],
        outputSize: [612, 459]);
    setState(() {
      outputImage = Image.memory(oImage);
    });
    clickPicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gaussian Blur'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
    );
  }
}
