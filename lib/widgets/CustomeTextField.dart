import 'dart:ui';

import 'package:find/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomeTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final IconData? iconData;
  final String? hintText;
  bool isObscure = true;
  bool? enabledEdit = true;
  final Widget? hidePassowrdIcon;
  final TextInputType? textInputType;
  CustomeTextField({
    super.key,
    this.textInputType,
    this.textEditingController,
    this.iconData,
    this.hintText,
    this.enabledEdit,
    this.hidePassowrdIcon,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: enabledEdit == false ? Colors.black12 : Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 7, bottom: 7, right: 20, left: 20),
      child: TextField(
        controller: textEditingController,
        obscureText: isObscure,
        enabled: enabledEdit,
        keyboardType: textInputType,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              iconData,
              color: Colors.white,
            ),
            suffixIcon: hidePassowrdIcon,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white),
            focusColor: Theme.of(context).selectedRowColor),
      ),
    );
  }
}
