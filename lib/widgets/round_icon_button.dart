import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final Color fillColor;
  final Color iconColor;
  RoundIconButton(
      {@required this.onPressed,
      @required this.icon,
      this.fillColor = Colors.white,
      this.iconColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 18,
        color: iconColor,
      ),
      fillColor: fillColor,
      shape: CircleBorder(),
      constraints: BoxConstraints.tightFor(
        width: 25.0,
        height: 25.0,
      ),
    );
  }
}
