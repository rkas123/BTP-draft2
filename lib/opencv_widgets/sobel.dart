import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opencv/opencv.dart';

import '../widgets/icon.dart';

class Sobel extends StatefulWidget {
  static String routeName = '/sobel';
  final List<CameraDescription> _cameras;
  const Sobel(this._cameras, {Key key}) : super(key: key);

  @override
  State<Sobel> createState() => _SobelState();
}

class _SobelState extends State<Sobel> {
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
      sobel();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void sobel() async {
    final oImage = await ImgProc.sobel(await imgFile.readAsBytes(), -1, 1, 1);
    setState(() {
      outputImage = Image.memory(oImage);
    });
    clickPicture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobel Operator'),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Actual Image'),
            SizedBox(
              height: 275,
              child: (imgFile != null)
                  ? Image.file(File(imgFile.path))
                  : const MyIcon(
                      icon: Icons.broken_image_outlined,
                      size: 'xl',
                    ),
            ),
            const Text('Output Image'),
            SizedBox(
              height: 275,
              child: (outputImage != null)
                  ? outputImage
                  : const MyIcon(
                      icon: Icons.broken_image_outlined,
                      size: 'xl',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
