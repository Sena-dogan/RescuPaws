import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../constants/assets.dart';
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
              'Önceden Gördüklerin',
              style: context.textTheme.displayLarge,
            ),
          ),
          body: switch (favoriteList) {
            AsyncValue<List<Favorite>?>(:final List<Favorite>? valueOrNull?) =>
              SizedBox(
                child: Text('Hi Mom! ${valueOrNull?.length}'),
              ),
            AsyncValue<Object>(:final Object error?) => ErrorWidget(error),
            _ => const Center(child: LoadingPawWidget()),
          }),
    );
  }
}
