import 'dart:ui';

import 'package:flutter/material.dart';

import 'context_extensions.dart';

Future<dynamic> popUp(BuildContext context,
    {required String title,
    required Function()? onPressed,
    required String buttonTitle}) {
  return showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: context.colorScheme.surface,
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('İptal', style: context.textTheme.bodyLarge),
              ),
              TextButton(
                onPressed: onPressed,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      context.colorScheme.error),
                ),
                child: Text(
                  buttonTitle,
                  style: context.textTheme.bodyLarge!
                      .copyWith(color: context.colorScheme.scrim),
                ),
              ),
            ],
          ),
        );
      });
}
