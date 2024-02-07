import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../utils/context_extensions.dart';

class VaccineScreen extends ConsumerWidget {
  const VaccineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Container(
                height: 50,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                context.pop();
              },
            ),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Aşılar',
              style: context.textTheme.labelSmall,
            ),
          ),
          body: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HaveVaccineWidget(
                      title: 'Rabies Aşısı',
                      haveVaccine: true,
                    ),
                    HaveVaccineWidget(
                      title: 'Distemper Aşısı',
                      haveVaccine: false,
                    ),
                    HaveVaccineWidget(
                      title: 'Hepatitis Aşısı',
                      haveVaccine: false,
                    ),
                    HaveVaccineWidget(
                      title: 'Parvovirus Aşısı',
                      haveVaccine: true,
                    ),
                    HaveVaccineWidget(
                      title: 'Bordotella Aşısı',
                      haveVaccine: true,
                    ),
                    HaveVaccineWidget(
                      title: 'Leptospirosis Aşısı',
                      haveVaccine: false,
                    ),
                    HaveVaccineWidget(
                      title: 'Panleukopenia Aşısı',
                      haveVaccine: true,
                    ),
                    HaveVaccineWidget(
                      title: 'Herpesvirus and Calicivirus Aşısı',
                      haveVaccine: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class HaveVaccineWidget extends StatelessWidget {
  const HaveVaccineWidget({
    required this.title,
    required this.haveVaccine,
    super.key,
  });

  final String title;
  final bool haveVaccine;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: haveVaccine
                ? Colors.green.withOpacity(0.4)
                : Colors.red.withOpacity(0.4),
            width: 2,
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: context.textTheme.bodyLarge,
            selectionColor: context.colorScheme.scrim,
          ),
          trailing: haveVaccine
              ? Icon(Icons.done_outline_rounded,
                  color: Colors.green.withOpacity(0.8), size: 30)
              : Icon(Icons.close_rounded,
                  color: Colors.red.withOpacity(0.8), size: 30),
        ),
      ),
    );
  }
}
