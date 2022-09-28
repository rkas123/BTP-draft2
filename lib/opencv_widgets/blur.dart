import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';

class BlurWidget extends StatefulWidget {
  static String routeName = '/blur';
  final List<CameraDescription> _cameras;
  const BlurWidget(this._cameras, {Key key}) : super(key: key);

  @override
  State<BlurWidget> createState() => _BlurWidgetState();
}

class _BlurWidgetState extends State<BlurWidget> {
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
      blur();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void blur() async {
    final oImage = await ImgProc.blur(
        await imgFile.readAsBytes(), [45, 45], [20, 30], Core.borderReflect);
    setState(() {
      outputImage = Image.memory(oImage);
    });
    clickPicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blur'),
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
