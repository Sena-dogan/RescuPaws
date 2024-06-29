import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../data/network/location/location_repository.dart';
import '../../../../models/location_response.dart';
import '../../../../utils/context_extensions.dart';
import '../logic/new_paw_logic.dart';
import '../model/new_paw_ui_model.dart';
import '../widgets/save_button.dart';

class AddressInputScreen extends ConsumerStatefulWidget {
  const AddressInputScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressInputScreenState();
}

class _AddressInputScreenState extends ConsumerState<AddressInputScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<GetLocationsResponse> locations =
        ref.watch(fetchLocationsProvider());
    final NewPawUiModel newPawLogic = ref.watch(newPawLogicProvider);
    final String city = newPawLogic.city?.name ?? 'Giresun';
    final String district = newPawLogic.district?.name ?? 'Bulancak';
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
                      const Divider(color: Colors.grey),
                      const Gap(10),
                      ListTile(
                        title: const Text('Konum'),
                        subtitle: Text('$city, $district'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () async {
                          debugPrint('Konum');
                          await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              barrierColor: Colors.black,
                              backgroundColor: context.colorScheme.surface,
                              builder: (BuildContext context) {
                                return DraggableScrollableSheet(
                                    expand: false,
                                    maxChildSize: 0.90,
                                    minChildSize: 0.2,
                                    builder: (BuildContext context,
                                        ScrollController scrollController) {
                                      return SingleChildScrollView(
                                          controller: scrollController,
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color:
                                                  context.colorScheme.surface,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const SizedBox(height: 21),
                                                Text('İl Seçiniz',
                                                    style: context
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                            color:
                                                                Colors.grey)),
                                                const Gap(5),
                                                const Divider(
                                                    color: Colors.grey),
                                                const Gap(10),
                                                SizedBox(
                                                  height: context.height * 0.8,
                                                  child: SearchableList<City>(
                                                    initialList: data!.cities,
                                                    filter: (String query) => data
                                                        .cities
                                                        .where((City city) => city
                                                            .name
                                                            .toLowerCase()
                                                            .contains(query
                                                                .toLowerCase()))
                                                        .toList(),
                                                    inputDecoration:
                                                        const InputDecoration(
                                                      hintText: 'İl Ara',
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.grey,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                    ),
                                                    builder: (List<City>
                                                            displayedList,
                                                        int itemIndex,
                                                        City item) {
                                                      final City city = item;
                                                      return ListTile(
                                                        title: Text(city.name),
                                                        onTap: () async {
                                                          final GetLocationsResponse
                                                              response =
                                                              await ref
                                                                  .read(newPawLogicProvider
                                                                      .notifier)
                                                                  .setCity(
                                                                      city);
                                                          if (context.mounted) {
                                                            Navigator.pop(
                                                                context);
                                                            await _showDistrictsDialog(
                                                                context,
                                                                response);
                                                          }
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                    });
                              });
                        },
                      ),
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (String? value) {
                            if (value != null && value.trim().isEmpty) {
                              return 'Lütfen "açıklama" giriniz.';
                            }
                            return null;
                          },
                          minLines: 2,
                          maxLines: 5,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (String value) {
                            ref
                                .read(newPawLogicProvider.notifier)
                                .setAddress(value);
                          },
                          autofillHints: const <String>[
                            AutofillHints.streetAddressLevel1,
                            AutofillHints.streetAddressLine1,
                            AutofillHints.streetAddressLine2,
                            AutofillHints.postalCode,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Açık Adres',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SaveButton(
                        title: 'Kaydet',
                        onPressed: () {
                          if (newPawLogic.address == null ||
                              newPawLogic.address!.isEmpty ||
                              newPawLogic.city == null ||
                              newPawLogic.district == null) {
                            context.showErrorSnackBar(
                                message: 'Lütfen adres bilgilerini giriniz.');
                            return;
                          }
                          context.push(SGRoute.pawimage.route);
                        },
                      ),
                      const Gap(20),
                    ],
                  ),
              error: (Object error, StackTrace stackTrace) =>
                  ErrorWidget(error),
              loading: () => const Center(child: CircularProgressIndicator())),
        ));
  }

  Future<dynamic> _showDistrictsDialog(
      BuildContext context, GetLocationsResponse? data) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        barrierColor: Colors.black,
        backgroundColor: context.colorScheme.surface,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              expand: false,
              maxChildSize: 0.90,
              minChildSize: 0.2,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 30,
                              height: 4,
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: const Color(0xFFE5E5EA)),
                            ),
                          ),
                          const SizedBox(height: 21),
                          Text('İlçe Seçiniz',
                              style: context.textTheme.labelSmall
                                  ?.copyWith(color: Colors.grey)),
                          const Gap(5),
                          const Divider(color: Colors.grey),
                          const Gap(10),
                          SizedBox(
                            height: context.height * 0.8,
                            child: SearchableList<District>(
                              initialList: data!.districts,
                              filter: (String query) => data.districts
                                  .where((District district) => district.name
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                                  .toList(),
                              inputDecoration: const InputDecoration(
                                hintText: 'İlçe Ara',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              builder: (List<District> displayedList,
                                  int itemIndex, District item) {
                                final District district = item;
                                return ListTile(
                                  title: Text(district.name),
                                  onTap: () async {
                                    ref
                                        .read(newPawLogicProvider.notifier)
                                        .setDistrict(district);

                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ));
              });
        });
  }
}
