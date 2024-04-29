import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../models/user_data.dart';

class AdvertiserInfo extends StatelessWidget {
  const AdvertiserInfo({
    super.key,
    required this.user,
    required this.imageSize,
    required this.textStyle,
  });

  final UserData? user;
  final double imageSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: imageSize,
          width: imageSize,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.network(user?.photoUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) =>
                    const Icon(
                      Icons.error,
                      color: Colors.white,
                    )),
          ),
        ),
        const Gap(20),
        Expanded(
          flex: 2,
          child: Text(
            user?.displayName ?? 'Kullanıcı',
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
