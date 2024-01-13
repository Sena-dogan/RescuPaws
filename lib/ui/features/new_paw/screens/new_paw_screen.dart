import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/assets.dart';
import '../../../../models/new_paw_model.dart';
import '../../../../utils/context_extensions.dart';
import '../../../../utils/firebase_utils.dart';
import '../../profile/user_logic.dart';
import '../../profile/user_ui_model.dart';
import '../logic/new_paw_logic.dart';
import '../model/new_paw_ui_model.dart';

class NewPawScreen extends ConsumerWidget {
  const NewPawScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseUser? user = FirebaseAuth.instance.currentUser;
    final UserUiModel userModel = ref.watch(userLogicProvider);
    final NewPawUiModel newPawModel = ref.watch(newPawLogicProvider);
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
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
          title: Text(
            'Bilgilerini Gözden Gecir',
            style: context.textTheme.titleLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Stack(
                  children: <Widget>[
                    // Edit icon
                    InkWell(
                      onTap: () {
                        final bool resp = ref
                            .read(userLogicProvider.notifier)
                            .updateUserImage();
                        if (resp == false) {
                          context.showErrorSnackBar(
                              title: 'Hata',
                              message: 'Resim yüklenirken bir hata oluştu.');
                        }
                      },
                      child: userModel.isImageLoading
                          ? const SizedBox(
                              width: 40,
                              height: 40,
                              child: CupertinoActivityIndicator(),
                            )
                          : Stack(
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: FirebaseAuth.instance.currentUser
                                                  ?.photoURL !=
                                              null
                                          ? Image.network(
                                              FirebaseAuth.instance.currentUser!
                                                  .photoURL!,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                debugPrint(
                                                    'AAAAAAAAAAAAAAAAAAAAA');
                                                return Image.network(
                                                    //TODO: Add an placeholder image to Assets
                                                    'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg');
                                              },
                                            ).image
                                          : Image.network(
                                                  'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg')
                                              .image,
                                      fit: BoxFit.cover,
                                    ),
                                    shape: const OvalBorder(),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: context.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
                title: Text(
                  userModel.user?.displayName ?? 'Kullanici',
                  style: context.textTheme.labelMedium,
                ),
                subtitle: Text(userModel.user?.email ?? '',
                    style: context.textTheme.bodyMedium),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () async {
                  //            final AsyncValue<List<Category>> categories = ref.watch(
                  // fetchSubCategoriesProvider(ref.read(newPawLogicProvider).category_id!));
                  final AsyncValue<NewPawResponse> response = await ref.watch(
                      createPawEntryProvider(newPawModel.toNewPawModel()));
                  response.when(
                    data: (NewPawResponse data) {
                      if (data.status == 'success') {
                        context.showAwesomeMaterialBanner(
                            title: 'Başarılı',
                            message: 'Yeni pati başarıyla eklendi.');
                      } else {
                        context.showErrorSnackBar(
                            title: 'Hata',
                            message: 'Yeni pati eklenirken bir hata oluştu.');
                      }
                    },
                    loading: () {
                      debugPrint('Loading');
                    },
                    error: (Object error, StackTrace? stackTrace) {
                      context.showErrorSnackBar(
                          title: 'Hata',
                          message: 'Yeni pati eklenirken bir hata oluştu.');
                      debugPrint('Error: $error');
                    },
                  );
                },
                child: const Text('Yeni Pati Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
