import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/app_router.dart';
import '../../../constants/assets.dart';
import '../../../models/paw_entry.dart';
import '../../../utils/context_extensions.dart';
import '../../home/logic/home_screen_logic.dart';

class MyEntriesScreen extends ConsumerWidget {
  const MyEntriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GetPawEntryResponse> pawEntryLogic =
        ref.watch(fetchUserPawEntriesProvider);
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('İlanlarım'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  context.push(SGRoute.breed.route);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: pawEntryLogic.when(
              data: (GetPawEntryResponse pawEntries) {
                return ListView.builder(
                  itemCount: pawEntries.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PawEntry pawEntry = pawEntries.data[index];
                    return ListTile(
                      title: Text(pawEntry.name ?? ''),
                      subtitle: Text(pawEntry.description ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          
                        },
                      ),
                      leading: CircleAvatar(
                        child: 
                        (pawEntry.images_uploads != null && pawEntry.images_uploads!.isNotEmpty) ?
                          ClipOval(
                            child: Image.network(
                            pawEntry.images_uploads?[pawEntry.selectedImageIndex]
                                    .image_url ??
                                '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, Object error, __) {
                              debugPrint('Error: $error');
                              return const Icon(Icons.error);
                            },
                                                    ),
                          ) : const Icon(Icons.error),
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
        ));
  }
}
