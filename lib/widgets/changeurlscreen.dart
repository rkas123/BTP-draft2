import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeUrlScreen extends StatefulWidget {
  static const String routeName = '/change-url';
  final existingUrl;
  final Function(String) updateUrl;
  const ChangeUrlScreen({this.updateUrl, this.existingUrl, Key key})
      : super(key: key);

  @override
  State<ChangeUrlScreen> createState() => _ChangeUrlScreenState();
}

class _ChangeUrlScreenState extends State<ChangeUrlScreen> {
  final urlController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    urlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var text = widget.existingUrl;
    final mediaQueryInfo = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Change URL screen'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Container(
          height: 300,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 1,
              )),
          width: mediaQueryInfo.size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter new url'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: TextInputType.url,
                    controller: urlController,
                    decoration: InputDecoration(
                      label: Text('New Url'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.updateUrl(urlController.text);
                        Fluttertoast.showToast(
                            msg: "URL Updated",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey.shade400,
                            textColor: Colors.black,
                            fontSize: 16.0);
                      },
                      child: Text('Done'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      urlController.text = text;
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
