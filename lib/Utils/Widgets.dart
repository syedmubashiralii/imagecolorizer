import 'package:flutter/material.dart';

import 'Constants.dart';

class MyButton extends StatelessWidget {
  String text;
  double? textSize = 12;
  FontWeight? fontWeight = FontWeight.w600;
  VoidCallback onTap;
  MyButton(
      {Key? key,
      required this.text,
      this.textSize,
      this.fontWeight,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        width: w * 1,
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        decoration: BoxDecoration(
          color: secondarycolor,
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 10)
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: "inter"),
          ),
        ),
      ),
    );
  }
}

class MyInputField extends StatefulWidget {
  TextEditingController controller;
  String hint;
  IconData icon;
  VoidCallback? onchanged;
  var suffixicon;
  var isobsecure;
  MyInputField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.onchanged,
      required this.icon,
      this.suffixicon = null,
      this.isobsecure = false})
      : super(key: key);

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: TextField(
          obscureText: widget.isobsecure,
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              prefixIcon: Icon(widget.icon),
              suffixIcon: widget.suffixicon,
              border: InputBorder.none,
              hintText: widget.hint),
        ),
      ),
    );
  }
}
