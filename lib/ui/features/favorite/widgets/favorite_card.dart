import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../models/favorite/favorite_model.dart';
import '../../../../utils/context_extensions.dart';
import '../../../widgets/adaptive_image.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({super.key, required this.favorite, this.items = const <PopupMenuEntry<String>>[]});
  final Favorite favorite;
  final List<PopupMenuEntry<String>> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: context.colorScheme.surface,
      surfaceTintColor: context.colorScheme.surface,
      child: InkWell(
        onTap: () {
          context.push(SGRoute.detail.route, extra: favorite.classfield?.id);
        },
        child: Column(
          children: <Widget>[
            _buildImage(favorite),
            const Gap(20),
            _buildNameAndPopUp(favorite, context),
            _buildLocation(context, favorite),
            const Gap(10),
          ],
        ),
      ),
    );
  }

  Row _buildLocation(BuildContext context, Favorite favorite) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: context.colorScheme.primary,
        ),
        Expanded(
          child: Text(
            favorite.classfield?.address ?? '',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Row _buildNameAndPopUp(Favorite favorite, BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 2.0, top: 15.0),
            child: Text(
              favorite.classfield?.name ?? '',
              style: context.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert),
              onSelected: (String value) {},
              itemBuilder: (BuildContext context) => items,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(Favorite favorite) {
    if (favorite.classfield?.image == null ||
        favorite.classfield!.image!.isEmpty) {
      return const Image(
        image: AssetImage(Assets.Hearts),
        fit: BoxFit.contain,
      );
    }
    return Expanded(
      child: AdaptiveImage(
        imageUrl: favorite.classfield!.image!.first,
        errorWidget: (BuildContext context, String url, Object error) {
          return const Image(
            image: AssetImage(Assets.Hearts),
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
