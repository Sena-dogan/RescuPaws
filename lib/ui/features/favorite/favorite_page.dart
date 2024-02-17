import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/assets.dart';
import '../../../models/favorite/favorite_model.dart';
import '../../../utils/context_extensions.dart';
import 'logic/favorite_logic.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Favorite>?> favoriteList =
        ref.watch(fetchFavoriteListProvider);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        image: const DecorationImage(
          image: AssetImage(Assets.FavoritesBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'Favorites',
              style: context.textTheme.displayLarge,
            ),
          ),
          body: switch (favoriteList) {
            final AsyncData<List<Favorite>?> data =>
              data.value != null && data.value!.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.value!.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Favorite favorite = data.value![index];
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              favorite.classfield?.images_uploads?.first
                                      .image_url ??
                                  '',
                              width: 50,
                              height: 50,
                            ),
                            title: Text(favorite.classfield?.name ?? ''),
                            subtitle:
                                Text(favorite.classfield?.description ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await ref
                                    .read(favoriteLogicProvider.notifier)
                                    .deleteFavorite(
                                      favorite,
                                    );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No favorites yet'),
                    ),
            final AsyncError<Object> error => Center(
                child: Text(error.error.toString()),
              ),
            _ => const Center(
                child: CircularProgressIndicator(),
              ),
          }),
    );
  }
}
