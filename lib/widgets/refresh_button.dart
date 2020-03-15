import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  final Function onPressed;
  RefreshButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton.icon(
          onPressed: onPressed,
          icon: Icon(Icons.refresh),
          label: Text(
            'Refresh',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          )),
    );
  }
}
