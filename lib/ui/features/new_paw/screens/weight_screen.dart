import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:wheel_slider/wheel_slider.dart';

import '../../../../config/router/app_router.dart';
import '../../../../constants/assets.dart';
import '../../../../utils/context_extensions.dart';
import '../widgets/wheel_box.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  int totalCount = 10;
  num initValue = 0.5;
  num currentValue = 0.5;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Kilo Bilgisi',
                style: context.textTheme.labelSmall,
              )),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Lottie.asset(
                Assets.Success,
                repeat: true,
                height: size.height * 0.3,
              ),
              Center(
                child: WheelBox(
                  wheelSlider: WheelSlider(
                    interval: 0.1,
                    totalCount: totalCount,
                    initValue: initValue,
                    onValueChanged: (dynamic val) {
                      //how can i update the value of currentValue with riverpod 2.0.
                    },
                    pointerColor: Colors.white,
                    pointerWidth: 10.0,
                    pointerHeight: 70.0,
                    lineColor: context.colorScheme.secondary,
                  ),
                  valueText: Text(
                    currentValue.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.push(SGRoute.address.route);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      context.colorScheme.primary),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                        horizontal: size.width * 0.3, vertical: 15.0),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: context.textTheme.labelSmall,
                ),
              ),
            ],
          )),
    );
  }
}
