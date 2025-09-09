import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/favorite/favorite_model.dart';
import '../../../utils/context_extensions.dart';
import '../../home/widgets/loading_paw_widget.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'logic/favorite_logic.dart';
import 'widgets/favorite_card.dart';

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
        color: context.colorScheme.surface,
         gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            context.colorScheme.surface,
            context.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context),
          bottomNavigationBar: const PawBottomNavBar(),
          body: switch (favoriteList) {
            AsyncValue<GetFavoriteListResponse>(
              :final GetFavoriteListResponse value
            ) =>
              (value.data.isEmpty)
                  ? const Center(child: Text('Henüz favori ilanınız yok'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        // ignore: unused_result
                        ref.refresh(fetchFavoriteListProvider);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildBody(value, context),
                      )),
            AsyncValue<Object>(:final Object error?) => ErrorWidget(error),
            _ => const Center(child: LoadingPawWidget()),
          }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'Önceden Gördüklerin',
        style: context.textTheme.titleLarge,
      ),
    );
  }

  Widget _buildBody(GetFavoriteListResponse valueOrNull, BuildContext context) {
    final bool showFav = ref.watch(favoriteLogicProvider).showFavorite;
    final List<Favorite> favoriteList =
        valueOrNull.data.where((Favorite favorite) {
      final int fav = showFav ? 1 : 0;
      return favorite.is_favorite == fav;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSlidingSegmentedControl<int>(
              initialValue: showFav ? 1 : 0,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              thumbDecoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(50),
              ),
              children: <int, Widget>{
                1: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  child: Text(
                    'Favoriler',
                    style: context.textTheme.titleMedium
                        ?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                0: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  child: Text('Diğerleri',
                      style: context.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center),
                ),
              },
              onValueChanged: (int value) {
                ref.read(favoriteLogicProvider.notifier).showFavorite();
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteList.length,
              itemBuilder: (BuildContext context, int index) {
                final Favorite favorite = favoriteList[index];
                return FavoriteCard(favorite: favorite, items: <PopupMenuEntry<String>>[
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
                ],);
              },
            ),
          ),
        ],
      ),
    );
  }
}
