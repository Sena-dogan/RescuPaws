import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/app_router.dart';
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
    final AsyncValue<GetFavoriteListResponse> favoriteList =
        ref.watch(fetchFavoriteListProvider);
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        image: const DecorationImage(
          image: AssetImage(Assets.LoginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context),

          /// Renders the body of the favorite screen based on the state of the [favoriteList].
          /// If the [favoriteList] is empty or null, displays a message indicating that there are no favorite listings.
          /// Otherwise, displays a refreshable list of favorite listings.
          ///
          /// The [onRefresh] callback is triggered when the user pulls down to refresh the list.
          /// It calls the [fetchFavoriteListProvider] to fetch the latest favorite listings.
          ///
          /// If there is an [error] while fetching the favorite listings, displays an [ErrorWidget].
          ///
          /// If the state of [favoriteList] is not recognized, displays a loading indicator.
          body: switch (favoriteList) {
            AsyncValue<GetFavoriteListResponse>(
              :final GetFavoriteListResponse valueOrNull?
            ) =>
              (valueOrNull == null || valueOrNull.data.isEmpty)
                  ? const Center(child: Text('Henüz favori ilanınız yok'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        // ignore: unused_result
                        ref.refresh(fetchFavoriteListProvider);
                      },
                      child: _buildBody(valueOrNull, context)),
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
    /// Filters the list of favorites based on the value of [showFav].
    /// If [showFav] is true, it returns the favorites that are marked as favorite.
    /// If [showFav] is false, it returns the favorites that are not marked as favorite.
    ///
    /// Returns a list of [Favorite] objects that match the filtering criteria.
    final bool showFav = ref.watch(favoriteLogicProvider).showFavorite;
    final List<Favorite> favoriteList =
        valueOrNull.data.where((Favorite favorite) {
      final int fav = showFav ? 1 : 0;
      return favorite.is_favorite == fav;
    }).toList();
    return Column(
      children: <Widget>[
        Expanded(
          child: Align(
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75),
                children: favoriteList
                    .map((Favorite favorite) =>
                        _buildFavoriteCard(context, favorite))
                    .toList()),
          ),
        ),
      ],
    );
  }

  /// Builds a card widget for displaying a favorite item.
  ///
  /// The [context] parameter is the build context.
  /// The [favorite] parameter is the favorite item to display.
  ///
  /// Returns a [Card] widget with the favorite item's details.
  Widget _buildFavoriteCard(BuildContext context, Favorite favorite) {
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
        /// This widget represents a popup menu button used in the favorite screen.
        /// It allows the user to perform actions such as deleting a favorite item.
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

  /// Builds an image widget based on the provided [favorite].
  ///
  /// The image is loaded from the network using the URL specified in the [favorite].
  /// If the image fails to load, an error image with the [Assets.PawPaw] asset is displayed.
  ///
  /// Returns an expanded widget containing the image.
  Widget _buildImage(Favorite favorite) {
    return Expanded(
      child: Image.network(
        favorite.classfield?.images_uploads?[0].image_url ?? '',
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Image(
            image: AssetImage(Assets.PawPaw),
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
