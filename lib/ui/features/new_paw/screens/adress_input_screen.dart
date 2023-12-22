import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/assets.dart';
import '../../../../data/network/location/location_repository.dart';
import '../../../../models/location_response.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';
import '../model/new_paw_ui_model.dart';

class AddressInputScreen extends ConsumerWidget {
  const AddressInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GetLocationsResponse> locations =
        ref.watch(fetchLocationsProvider());
    final NewPawUiModel newPawLogic = ref.read(newPawLogicProvider);
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Adres Bilgileri',
              style: context.textTheme.labelSmall,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: locations.when(
              data: (GetLocationsResponse? data) => Column(
                    children: <Widget>[
                      const Text('Konumunu seç'),
                      ListTile(
                        title: const Text('Konum'),
                        subtitle: Text(
                            '${newPawLogic.district?.name ?? "Bulancak"}, ${newPawLogic.city?.name} ?? "Giresun"}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () async {
                          await showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ListView.builder(
                                    itemCount: data?.cities.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final City city = data!.cities[index];
                                      return ListTile(
                                        title: Text(city.name),
                                        onTap: () async {
                                          ref
                                              .read(
                                                  newPawLogicProvider.notifier)
                                              .setCity(city);
                                          ref
                                              .read(fetchLocationsProvider(
                                                  cityId: city.id))
                                              .whenData((GetLocationsResponse?
                                                  data) async {
                                            await showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ListView.builder(
                                                      itemCount: data
                                                          ?.districts.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final District
                                                            district =
                                                            data!.districts[
                                                                index];
                                                        return ListTile(
                                                          title: Text(
                                                              district.name),
                                                          onTap: () async {
                                                            ref
                                                                .read(newPawLogicProvider
                                                                    .notifier)
                                                                .setDistrict(
                                                                    district);
                                                            ref
                                                                .read(
                                                                    fetchLocationsProvider())
                                                                .whenData(
                                                                    (GetLocationsResponse?
                                                                        data) {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                        );
                                                      });
                                                });
                                          });
                                        },
                                      );
                                    });
                              });
                        },
                      )
                    ],
                  ),
              error: (Object error, StackTrace stackTrace) =>
                  ErrorWidget(error),
              loading: () => const Center(child: CircularProgressIndicator())),
        ));
  }
}
