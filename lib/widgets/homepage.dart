import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:opencv/opencv.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:opencv/core/core.dart';
// import 'package:opencv/opencv.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> _cameras;
  const HomePage(this._cameras, {Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController controller;
  Future<void> _initializeControllerFuture;
  bool cameraWorking = false;
  XFile imgFile;
  Image outputImage;

  @override
  void initState() {
    super.initState();
    imgFile = null;
    outputImage = null;
  }

  void _startCamera() {
    setState(() {
      controller =
          CameraController(widget._cameras[0], ResolutionPreset.medium);
      _initializeControllerFuture = controller.initialize();
      cameraWorking = true;
    });
    clickPicture();
  }

  void clickPicture() async {
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await controller.takePicture();

      if (!mounted) return;

      final oImage = await ImgProc.blur(
          await image.readAsBytes(), [45, 45], [20, 30], Core.borderReflect);
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

  void _closeCamera() {
    controller.dispose();
    setState(() {
      cameraWorking = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Camera Display')),
        body: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: SingleChildScrollView(
            child: (!cameraWorking)
                ? Center(
                    child: FlatButton(
                      onPressed: _startCamera,
                      child: const Icon(Icons.camera_alt_rounded),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            onPressed: _closeCamera,
                            child: const Icon(Icons.arrow_back_ios)),
                        // CameraPreview(controller),
                        if (imgFile != null) Image.file(File(imgFile.path)),
                        if (outputImage != null) outputImage,
                      ],
                    ),
                  ),
          ),
        ));
  }
}
