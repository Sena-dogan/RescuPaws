import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/data/network/location/location_repository.dart';
import 'package:rescupaws/models/location_response.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/ui/features/new_paw/model/new_paw_ui_model.dart';
import 'package:rescupaws/ui/features/new_paw/widgets/save_button.dart';
import 'package:rescupaws/utils/context_extensions.dart';
import 'package:searchable_listview/searchable_listview.dart';

class AddressInputScreen extends ConsumerStatefulWidget {
  const AddressInputScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressInputScreenState();
}

class _AddressInputScreenState extends ConsumerState<AddressInputScreen> {
  @override
  Widget build(BuildContext context) {
    // Load cities for Turkey (countryId = 1)
    AsyncValue<GetLocationsResponse> cities =
        ref.watch(fetchCitiesProvider(1));
    NewPawUiModel newPawLogic = ref.watch(newPawLogicProvider);
    String? city = newPawLogic.city?.name;
    String? district = newPawLogic.district?.name;
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Adres Bilgileri',
          style: context.textTheme.labelSmall,
        ),
      ),
      body: cities.when(
          data: (GetLocationsResponse? data) => SizedBox(
                height: context.height,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Konum'),
                        subtitle: Text('$city, $district'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () async {
                          debugPrint('Konum');
                          await showModalBottomSheet<void>(
                              context: context,
                              useSafeArea: true,
                              isScrollControlled: true,
                              showDragHandle: true,
                              barrierColor: Colors.black54,
                              backgroundColor: context.colorScheme.surface,
                              constraints: BoxConstraints(
                                maxHeight: context.height * 0.8,
                              ),
                              builder: (BuildContext context) {
                                return DraggableScrollableSheet(
                                    initialChildSize: 1,
                                    builder: (BuildContext context,
                                        ScrollController scrollController) {
                                      return Container(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(height: 21),
                                            Text('İl Seçiniz',
                                                style: context
                                                    .textTheme.labelSmall
                                                    ?.copyWith(
                                                        color: Colors.grey)),
                                            const Gap(5),
                                            Expanded(
                                                child: SearchableList<City>(
                                              initialList: data!.cities,
                                              filter: (String query) => data
                                                  .cities
                                                  .where((City c) => c.name
                                                      .toLowerCase()
                                                      .contains(
                                                          query.toLowerCase()))
                                                  .toList(),
                                              inputDecoration:
                                                  const InputDecoration(
                                                hintText: 'İl Ara',
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                              ),
                                              // ❌ builder: (displayedList, index, item) { ... }
                                              // ✅ itemBuilder:
                                              itemBuilder: (City item) {
                                                return ListTile(
                                                  title: Text(item.name),
                                                  onTap: () async {
                                                    GetLocationsResponse
                                                        response = await ref
                                                            .read(
                                                                newPawLogicProvider
                                                                    .notifier)
                                                            .setCity(item);
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                      await _showDistrictsDialog(
                                                          context, response);
                                                    }
                                                  },
                                                );
                                              },
                                            )),
                                          ],
                                        ),
                                      );
                                    });
                              });
                        },
                      ),
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.all(8),
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
                ),
              ),
          error: (Object error, StackTrace stackTrace) => ErrorWidget(error),
          loading: () => const Center(child: CircularProgressIndicator())),
    );
  }

  Future<dynamic> _showDistrictsDialog(
      BuildContext context, GetLocationsResponse? data) {
    return showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        barrierColor: Colors.black54,
        backgroundColor: context.colorScheme.surface,
        constraints: BoxConstraints(
          maxHeight: context.height * 0.8,
        ),
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              initialChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
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
                      Expanded(
                          child: SearchableList<District>(
                            initialList: data!.districts,
                            filter: (String query) => data.districts
                                .where((District d) => d.name
                                    .toLowerCase()
                                    .contains(query.toLowerCase()))
                                .toList(),
                            inputDecoration: const InputDecoration(
                              hintText: 'İlçe Ara',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            // ❌ builder: (displayedList, index, item) { ... }
                            // ✅ itemBuilder:
                            itemBuilder: (District item) {
                              return ListTile(
                                title: Text(item.name),
                                onTap: () async {
                                  ref
                                      .read(newPawLogicProvider.notifier)
                                      .setDistrict(item);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ))
                    ],
                  ),
                );
              });
        });
  }
}
