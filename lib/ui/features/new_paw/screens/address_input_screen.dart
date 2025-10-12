import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/data/network/location/location_repository.dart';
import 'package:rescupaws/models/location_response.dart';
import 'package:rescupaws/ui/features/new_paw/logic/new_paw_logic.dart';
import 'package:rescupaws/ui/features/new_paw/model/new_paw_ui_model.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Konum Bilgileri',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: cities.when(
            data: (GetLocationsResponse? data) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Header section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: context.colorScheme.primary,
                              size: 24,
                            ),
                            const Gap(12),
                            Expanded(
                              child: Text(
                                'Patili dostunuzun bulunduğu konumu seçin',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: context.colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),
                      
                      // Location Selection Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: (city != null && district != null)
                                ? context.colorScheme.primary.withValues(alpha: 0.5)
                                : Colors.grey[300]!,
                            width: (city != null && district != null) ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
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
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: context.colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.location_city,
                                        color: context.colorScheme.primary,
                                        size: 28,
                                      ),
                                    ),
                                    const Gap(16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Konum',
                                            style: context.textTheme.titleSmall?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const Gap(4),
                                          Text(
                                            (city != null && district != null)
                                                ? '$city, $district'
                                                : 'İl ve İlçe Seçiniz',
                                            style: context.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: (city != null && district != null)
                                                  ? context.colorScheme.onSurface
                                                  : Colors.grey[400],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: context.colorScheme.primary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      if (city == null || district == null) ...<Widget>[
                        const Gap(16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                                size: 20,
                              ),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  'Konum bilgisi zorunludur. Lütfen il ve ilçe seçiniz.',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const Gap(40),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (city != null && district != null)
                              ? () {
                                  // Set a default address based on city and district
                                  ref.read(newPawLogicProvider.notifier).setAddress('$city, $district');
                                  context.push(SGRoute.imageManagement.route);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colorScheme.primary,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Devam Et',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
            error: (Object error, StackTrace stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const Gap(16),
                      Text('Bir hata oluştu: $error'),
                    ],
                  ),
                ),
            loading: () => const Center(child: CircularProgressIndicator())),
      ),
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
