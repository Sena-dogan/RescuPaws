import 'package:flutter/material.dart';

import '../../../../utils/context_extensions.dart';

class HaveVaccineWidget extends StatelessWidget {
  const HaveVaccineWidget({
    required this.title,
    required this.haveVaccine,
    super.key,
  });

  final String title;
  final int haveVaccine;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: haveVaccine == 1
                ? Colors.green.withOpacity(0.4)
                : haveVaccine == 0
                    ? Colors.red.withOpacity(0.4)
                    : Colors.grey.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: context.textTheme.bodyLarge,
            selectionColor: context.colorScheme.scrim,
          ),
          trailing: haveVaccine == 1
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : haveVaccine == 0
                  ? const Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.help,
                      color: Colors.grey,
                    ),
        ),
      ),
    );
  }
}
