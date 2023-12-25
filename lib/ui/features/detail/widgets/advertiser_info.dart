import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../models/paw_entry_detail.dart';
import '../../../../utils/context_extensions.dart';

class AdvertiserInfo extends StatelessWidget {
  const AdvertiserInfo({
    super.key,
    required this.pawEntryDetail,
  });

  final PawEntryDetail? pawEntryDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite_border,
            size: 25,
          ),
        ),
        const Gap(20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'İlan Sahibi',
              style: context.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(5),
            Text(
              'Location',
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
