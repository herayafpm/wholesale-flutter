import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemInputText extends StatelessWidget {
  final TextEditingController controller;
  final Function validator;
  final String hint;
  final bool obsecure;
  final bool isSecure;
  final Function changeObsecure;
  final TextInputType tipe;

  const ItemInputText(
      {Key key,
      this.controller,
      this.validator,
      this.hint,
      this.obsecure = true,
      this.changeObsecure,
      this.isSecure = false,
      this.tipe = TextInputType.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: tipe,
        controller: controller,
        validator: validator,
        cursorColor: Colors.white,
        obscureText: !obsecure,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
            suffixStyle: TextStyle(backgroundColor: Colors.white),
            suffixIcon: (isSecure)
                ? IconButton(
                    icon: Icon(
                        (obsecure) ? Icons.visibility : Icons.visibility_off),
                    color: Colors.white,
                    onPressed: changeObsecure,
                  )
                : null,
            enabledBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(4.0),
                borderSide: new BorderSide(color: Colors.white, width: 2)),
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(4.0),
                borderSide: new BorderSide(color: Colors.white, width: 2)),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white70)));
  }
}
