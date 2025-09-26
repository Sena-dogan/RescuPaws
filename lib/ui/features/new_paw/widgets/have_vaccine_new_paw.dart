import 'package:flutter/material.dart';

import 'package:rescupaws/utils/context_extensions.dart';

class NewPawHaveVaccineWidget extends StatelessWidget {
  const NewPawHaveVaccineWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.isVaccineSelected,
  });

  final String title;
  final bool isVaccineSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isVaccineSelected
                ? Colors.green.withValues(alpha:0.5)
                : Colors.red.withValues(alpha:0.5),
            width: 2,
          ),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(
            title,
            style: context.textTheme.bodyLarge,
            selectionColor: context.colorScheme.scrim,
          ),
          trailing: isVaccineSelected
              ? const Icon(
                  Icons.check,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.close,
                  color: Colors.red,
                ),
        ),
      ),
    );
  }
}
