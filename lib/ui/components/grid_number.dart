import 'package:flutter/material.dart';

class GridNumber extends StatelessWidget {
  final String title;
  final Function onTap;

  const GridNumber({Key key, this.title = "", this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              "$title",
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }
}
