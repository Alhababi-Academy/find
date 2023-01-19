import 'package:find/widgets/CirclePrograa.dart';
import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String? message;
  const LoadingAlertDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(
            height: 10,
          ),
          Text(message!),
        ],
      ),
    );
  }
}
