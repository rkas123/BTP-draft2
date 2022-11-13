import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../widgets/icon.dart';

class HoughCloud extends StatefulWidget {
  static String routeName = '/HoughCloud';
  final List<CameraDescription> _cameras;
  const HoughCloud(this._cameras, {Key key}) : super(key: key);

  @override
  State<HoughCloud> createState() => _HoughCloudState();
}

class _HoughCloudState extends State<HoughCloud> {
  CameraController controller;
  Future<void> _initializeControllerFuture;
  File imgFile;
  Image outputImage;
  final picker = ImagePicker();
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
      final imageFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      setState(() {
        imgFile = File(imageFile.path);
      });
      hough();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void hough() async {
    final url = Uri.parse("http://192.168.1.5:5000/raahi/hough");

    try {
      var request = http.MultipartRequest(
        'POST',
        url,
      );
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(
        http.MultipartFile(
          'image',
          imgFile.readAsBytes().asStream(),
          imgFile.lengthSync(),
          filename: 'filename',
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.headers.addAll(headers);

      var response = await request.send();

      var res = await http.Response.fromStream(response);
      String imgstr = json.decode(res.body).toString();
      setState(() {
        outputImage = Image.memory(base64Decode(imgstr));
      });
    } catch (error) {
      print(error);
    }
    // clickPicture();
    // break the loop, enabling manual click of photograph
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Canny Edge Detector'),
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
                ElevatedButton(
                  onPressed: clickPicture,
                  child: const Text('Click Picture'),
                )
              ],
            ),
          ),
        ));
  }
}
