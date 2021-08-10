import 'package:app/globals.dart';
import "package:flutter/material.dart";

class LongButton extends StatefulWidget {
  final bool primary;
  final onPress;
  final String text;
  const LongButton(
      {Key? key,
      required this.primary,
      required this.onPress,
      required this.text})
      : super(key: key);

  @override
  _LongButtonState createState() => _LongButtonState();
}

class _LongButtonState extends State<LongButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        width: MediaQuery.of(context).size.width - 24,
        height: 60,
        decoration: BoxDecoration(
            color: widget.primary ? primary : primary,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.text,
                style: TextStyle(
                    color: widget.primary ? Colors.white : primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 17))
          ],
        ),
      ),
    );
  }
}
