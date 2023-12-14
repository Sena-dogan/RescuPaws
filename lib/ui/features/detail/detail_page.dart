import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/app_router.dart';
import '../../../models/paw_entry.dart';
import '../../../utils/context_extensions.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.pawEntry,
  });

  final PawEntry pawEntry;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: Image.network(
            pawEntry.images_uploads?.firstOrNull?.image_url ?? '',
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              debugPrint(
                  'Error occured while loading image: ${pawEntry.images_uploads?.firstOrNull?.image_url} \n');
              debugPrint('Id of the paw entry: ${pawEntry.id}');
              // FirebaseCrashlytics.instance.recordError(
              //   error,
              //   stackTrace,
              //   reason:
              //       '[API] Error occured while loading image. Id of the paw entry: ${pawEntry.id}',
              //   printDetails: true,
              // );
              return Image.network(
                  'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg');
            },
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(SGRoute.home.route),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: context.colorScheme.background,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Gap(10),
                  Text(
                    pawEntry.name ?? '',
                    style: context.textTheme.labelMedium,
                  ),
                  const Gap(10),
                  Text(
                    pawEntry.description ?? '',
                    style: context.textTheme.labelSmall,
                  ),
                  const Gap(10),
                  Text(
                    pawEntry.address ?? '',
                    style: context.textTheme.bodyMedium,
                  ),
                  const Gap(10),
                  Text(
                    pawEntry.createdAtFormatted,
                    style: context.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
