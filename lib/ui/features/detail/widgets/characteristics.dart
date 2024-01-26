import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../data/enums/detail_enums.dart';
import '../../../../models/paw_entry_detail.dart';
import '../../../../utils/context_extensions.dart';

class Characteristics extends StatelessWidget {
  const Characteristics({
    super.key,
    required this.pawEntryDetailResponse,
  });

  final GetPawEntryDetailResponse? pawEntryDetailResponse;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharacteristicItem(
              title: 'Cinsiyet',
              value: pawEntryDetailResponse!.pawEntryDetail?.genderEnum ==
                      Gender.Female
                  ? 'Dişi'
                  : 'Erkek',
            ),
            const Gap(30),
            CharacteristicItem(
              title: 'Tuvalet Eğitimi',
              value: pawEntryDetailResponse!.pawEntryDetail?.educationEnum ==
                      HaveorNot.Have
                  ? 'Var'
                  : 'Yok',
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CharacteristicItem(
              title: 'Breed',
              value: 'Breed',
            ),
            const Gap(30),
            CharacteristicItem(
              title: 'Yaş',
              value:
                  pawEntryDetailResponse!.pawEntryDetail?.age.toString() ?? '',
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharacteristicItem(
              title: 'Ağırlık',
              value:
                  '${pawEntryDetailResponse!.pawEntryDetail!.weight?.substring(0, 3)} kg',
            ),
            const Gap(30),
            CharacteristicItem(
              title: 'Aşıları',
              value: pawEntryDetailResponse!.pawEntryDetail?.vaccinatedEnum ==
                      HaveorNot.Have
                  ? 'Var'
                  : 'Yok',
            ),
          ],
        ),
      ],
    );
  }
}

class CharacteristicItem extends StatelessWidget {
  const CharacteristicItem({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(5),
        Text(
          value,
          style: context.textTheme.bodyLarge,
        )
      ],
    );
  }
}
