import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/data/enums/detail_enums.dart';
import 'package:rescupaws/models/paw_entry_detail.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class Characteristics extends StatelessWidget {
  const Characteristics({
    super.key,
    required this.pawEntryDetailResponse,
  });

  final GetPawEntryDetailResponse? pawEntryDetailResponse;

  @override
  Widget build(BuildContext context) {
    String weight = pawEntryDetailResponse!.pawEntryDetail!.weight ?? '';
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
            CharacteristicItem(
              title: 'Breed',
              value: pawEntryDetailResponse!.pawEntryDetail?.sub_category_id ?? ''
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
              value: weight.length > 3
                  ? '${weight.substring(0, 3)} kg'
                  : '$weight kg',
            ),
            const Gap(30),
            VaccineButton(
              pawEntryDetailResponse: pawEntryDetailResponse,
            ),
          ],
        ),
      ],
    );
  }
}

class VaccineButton extends StatelessWidget {
  const VaccineButton({
    super.key,
    required this.pawEntryDetailResponse,
  });

  final GetPawEntryDetailResponse? pawEntryDetailResponse;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          SGRoute.vaccine.route,
          extra: pawEntryDetailResponse!.data?.id,
        );
      },
      child: Container(
          height: 40,
          width: 65,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: context.colorScheme.primary),
          ),
          child: Center(
            child: Text(
              'Aşılar',
              style: context.textTheme.bodyLarge,
            ),
          )),
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
