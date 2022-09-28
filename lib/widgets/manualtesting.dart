import 'dart:io';
import 'dart:math';
import 'package:opencv/core/imgproc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManualTesting extends StatefulWidget {
  const ManualTesting({Key key}) : super(key: key);

  static Future<File> imageToFile({String imageName, String ext}) async {
    var bytes = await rootBundle.load('assets/$imageName.$ext');
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/profile.png');
    await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  @override
  State<ManualTesting> createState() => _ManualTestingState();
}

class _ManualTestingState extends State<ManualTesting> {
  File file;
  Image o;
  Image temp;
  void loadImages() async {
    var tfile = await ManualTesting.imageToFile(
      imageName: 'road2',
      ext: "jpg",
    );

    setState(() {
      file = tfile;
    });

    evalFunc();
  }

  Future<Image> func(File f) async {
    var temp1 = await ImgProc.canny(await f.readAsBytes(), 50, 150);
    var oImage = await ImgProc.gaussianBlur(await f.readAsBytes(), [1, 1], 0);
    oImage = await ImgProc.canny(await oImage, 50, 200);
    oImage = await ImgProc.houghLines(
      oImage,
      threshold: 100,
      lineColor: "#ff0000",
      theta: pi / 180,
      rho: 1,
    );
    setState(() => temp = Image.memory(temp1));
    return Image.memory(oImage);
  }

  void evalFunc() async {
    if (file != null) {
      var temp1 = await func(file);
      setState(() => o = temp1);
    }
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual Test Results')),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                child: temp,
              ),
              SizedBox(
                height: 300,
                child: o,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
