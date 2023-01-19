import 'package:find/config/config.dart';
import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12.0),
    child: const CircularProgressIndicator(
      backgroundColor: FindColors.primaryColor,
      valueColor: AlwaysStoppedAnimation(FindColors.secondaryColor),
    ),
  );
}

linerProgress() {
  Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
    ),
  );
}
