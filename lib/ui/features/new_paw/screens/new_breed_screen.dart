import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../../../../utils/firebase_utils.dart';
import '../../profile/user_logic.dart';
import '../../profile/user_ui_model.dart';

class NewPawScreen extends ConsumerWidget {
  const NewPawScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseUser? user = FirebaseAuth.instance.currentUser;
    final UserUiModel userLogic = ref.watch(userLogicProvider);
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
        body: Column(
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
                    child: userLogic.isImageLoading
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
                                            errorBuilder: (BuildContext context,
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
                userLogic.user?.displayName ?? 'Kullanici',
                style: context.textTheme.labelMedium,
              ),
              subtitle: Text(userLogic.user?.email ?? '',
                  style: context.textTheme.bodyMedium),
            ),
            const Divider(),
            PhoneFormField(),
          ],
        ),
      ),
    );
  }
}
