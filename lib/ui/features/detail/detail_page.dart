// ignore_for_file: avoid_field_initializers_in_const_classes, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../constants/assets.dart';
import '../../../models/paw_entry.dart';
import '../../../utils/context_extensions.dart';
import '../../widgets/add_nav_button.dart';
import '../../widgets/bottom_nav_bar.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.pawEntry,
  });

  final PawEntry pawEntry;
  final bool _pinned = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.HomeBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: _pinned,
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.all(0),
                title: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Text(
                    pawEntry.name ?? '',
                    style: context.textTheme.labelMedium,
                  ),
                ),
                background: Image.network(
                  pawEntry.images_uploads?.firstOrNull?.image_url ?? '',
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    debugPrint(
                        'Error occured while loading image: ${pawEntry.images_uploads?.firstOrNull?.image_url} \n');
                    debugPrint('Id of the paw entry: ${pawEntry.id}');
                    return Image.network(
                        'https://i.pinimg.com/736x/fc/05/5f/fc055f6e40faed757050d459b66e88b0.jpg');
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
        floatingActionButton: const AddNavButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
