import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rescupaws/config/router/app_router.dart';
import 'package:rescupaws/constants/assets.dart';
import 'package:rescupaws/data/enums/paw_entry_status.dart';
import 'package:rescupaws/models/paw_entry.dart';
import 'package:rescupaws/ui/home/logic/home_screen_logic.dart';
import 'package:rescupaws/ui/widgets/adaptive_image.dart';
import 'package:rescupaws/utils/context_extensions.dart';

class MyEntriesScreen extends ConsumerWidget {
  const MyEntriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<GetPawEntryResponse> pawEntryLogic =
        ref.watch(fetchUserPawEntriesProvider);
    return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('İlanlarım'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Start with image selection for a better flow
                  context.push(SGRoute.pawimage.route);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: pawEntryLogic.when(
                data: (GetPawEntryResponse pawEntries) {
                  return ListView.separated(
                    separatorBuilder: (_, __) {
                      return const Gap(10);
                    },
                    itemCount: pawEntries.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      PawEntry pawEntry = pawEntries.data[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            if (pawEntry.statusEnum ==
                                PawEntryStatus.approved) {
                              context.push(SGRoute.detail.route,
                                  extra: pawEntry.id);
                            } else {
                              context.showErrorSnackBar(
                                  title: 'İlan Yayında Değil',
                                  message:
                                      'İlanınız onaylandıktan sonra detayları görebilirsiniz');
                            }
                          },
                          title: Text(pawEntry.name ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                pawEntry.description ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (pawEntry.statusEnum ==
                                  PawEntryStatus.approved)
                                Text('Onaylandı',
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold))
                              else
                                PawEntryStatus.pending == pawEntry.statusEnum
                                    ? Text('Onay Bekliyor',
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                          color: Colors.yellow[700],
                                          fontWeight: FontWeight.bold,
                                        ))
                                    : Text('Reddedildi',
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          ),
                          leading: SizedBox(
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: (pawEntry.image != null &&
                                          pawEntry.image!.isNotEmpty)
                                      ? AdaptiveImage(
                                          imageUrl: pawEntry
                                                  .image?[pawEntry
                                                      .selectedImageIndex] ??
                                              '',
                                        )
                                      : Image.asset(
                                          Assets.Hearts,
                                          fit: BoxFit.cover,
                                          frameBuilder: (BuildContext context,
                                              Widget child,
                                              int? frame,
                                              bool wasSynchronouslyLoaded) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: child,
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (Object error, StackTrace stackTrace) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ),
        ));
  }
}
