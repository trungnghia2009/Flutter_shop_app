import 'package:flutter/material.dart';

class FlatButtonSnackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('Ok'),
      onPressed: () {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Have a snack!'),
          ),
        );
      },
    );
  }
}
