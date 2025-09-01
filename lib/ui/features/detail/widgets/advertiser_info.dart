import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdvertiserInfo extends StatelessWidget {
  const AdvertiserInfo({
    super.key,
    required this.imageSize,
    required this.textStyle,
    required this.receiverName,
    required this.receiverProfilePic,
  });

  final double imageSize;
  final TextStyle? textStyle;
  final String? receiverName;
  final String? receiverProfilePic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: imageSize,
          width: imageSize,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha:0.4),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.network(receiverProfilePic ?? '',
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
            receiverName ?? 'Kullanıcı',
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
