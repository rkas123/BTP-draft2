import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opencv/opencv.dart';

class GaussianBlurWidget extends StatefulWidget {
  static String routeName = '/gaussianblur';
  final List<CameraDescription> _cameras;
  const GaussianBlurWidget(this._cameras, {Key key}) : super(key: key);

  @override
  State<GaussianBlurWidget> createState() => _GaussianBlurWidgetState();
}

class _GaussianBlurWidgetState extends State<GaussianBlurWidget> {
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
      gaussianBlur();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void gaussianBlur() async {
    final oImage =
        await ImgProc.gaussianBlur(await imgFile.readAsBytes(), [45, 45], 0);
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
