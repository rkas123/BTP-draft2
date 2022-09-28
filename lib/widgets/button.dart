import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final void Function(BuildContext) handler;
  const Button(this.title, this.handler, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => handler(context),
        splashColor: Theme.of(context).primaryColor,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.withOpacity(0.7), Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ));
  }
}
