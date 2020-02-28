import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  RoundIconButton({
    @required this.onPressed,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Icon(
        icon,
        size: 18,
      ),
      fillColor: Colors.white,
      shape: CircleBorder(),
      constraints: BoxConstraints.tightFor(
        width: 25.0,
        height: 25.0,
      ),
    );
  }
}
