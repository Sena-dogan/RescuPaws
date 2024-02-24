import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../constants/assets.dart';
import '../../../models/favorite/delete_favorite_response.dart';
import '../../../models/favorite/favorite_model.dart';
import '../../../utils/context_extensions.dart';
import '../../home/widgets/loading_paw_widget.dart';
import 'logic/favorite_logic.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<GetFavoriteListResponse> favoriteList =
        ref.watch(fetchFavoriteListProvider);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Önceden Gördüklerin',
              style: context.textTheme.titleLarge,
            ),
          ),
          body: switch (favoriteList) {
            AsyncValue<GetFavoriteListResponse>(
              :final GetFavoriteListResponse valueOrNull?
            ) =>
              (valueOrNull == null || valueOrNull.data.isEmpty) 
                  ? const Center(child: Text('Henüz favori ilanınız yok'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.refresh(fetchFavoriteListProvider);
                      },
                      child: _buildBody(valueOrNull, context),
                    ),
            AsyncValue<Object>(:final Object error?) => ErrorWidget(error),
            _ => const Center(child: LoadingPawWidget()),
          }),
    );
  }

  Padding _buildBody(
      GetFavoriteListResponse valueOrNull, BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75),
          children: valueOrNull.data
              .map((Favorite favorite) => _buildFavoriteCard(context, favorite))
              .toList()),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Favorite favorite) {
    return Card(
        elevation: 2,
        color: context.colorScheme.background,
        surfaceTintColor: context.colorScheme.surface,
        child: Column(children: <Widget>[
          _buildImage(favorite),
          const Gap(20),
          _buildNameAndPopUp(favorite, context),
          _buildLocation(context, favorite),
          const Gap(10),
        ]));
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
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'delete',
                  onTap: () {
                    ref.read(deleteFavoriteProvider(favorite));
                    ref.invalidate(fetchFavoriteListProvider);
                  },
                  child: Text(
                    'Sil',
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(Favorite favorite) {
    return Expanded(
      child: Image.network(
        favorite.classfield?.images_uploads?[0].image_url ?? '',
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Image(
            image: AssetImage(Assets.PawPaw),
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
