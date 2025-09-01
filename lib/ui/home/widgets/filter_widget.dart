import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 20,
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha:0.6800000071525574),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFE18525)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
