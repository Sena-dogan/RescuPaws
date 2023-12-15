// ignore_for_file: avoid_field_initializers_in_const_classes, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/app_router.dart';
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
    final Size size = MediaQuery.of(context).size;
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
              leading: IconButton(
                icon: Container(
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => context.go(SGRoute.home.route),
              ),
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.all(0),
                title: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: context.colorScheme.background.withOpacity(0.4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Text(
                    pawEntry.name ?? '',
                    style: context.textTheme.labelMedium
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
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
                        const Gap(30),
                        Characteristics(),
                        const Gap(30),
                        Text(
                          pawEntry.createdAtFormatted,
                          style: context.textTheme.bodyMedium,
                        ),
                        const Gap(30),
                        AdvertiserInfo(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(size.width * 0.9, 50),
                              backgroundColor:
                                  context.colorScheme.secondaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {},
                            child: Text('Mesaj Gönder',
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                )),
                          ),
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

class AdvertiserInfo extends StatelessWidget {
  const AdvertiserInfo({
    super.key,
  });

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

class Characteristics extends StatelessWidget {
  const Characteristics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharacteristicItem(
              title: 'Cinsiyet',
              value: 'Dişi',
            ),
            Gap(30),
            CharacteristicItem(
              title: 'Tuvalet Eğitimi',
              value: 'Var',
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharacteristicItem(
              title: 'Yaş',
              value: '3.5 Ay',
            ),
            Gap(30),
            CharacteristicItem(
              title: 'Köken',
              value: 'İngiltere',
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharacteristicItem(
              title: 'Ağırlık',
              value: '1.5 Kg',
            ),
            Gap(30),
            CharacteristicItem(
              title: 'Aşıları',
              value: 'Yapıldı',
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
