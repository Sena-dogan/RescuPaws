import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_data.freezed.dart';
part 'provider_data.g.dart';

@freezed
class ProviderData with _$ProviderData {
  factory ProviderData({
    String? uid,
    String? providerId,
    String? displayName,
    String? email,
    String? phoneNumber,
    String? photoUrl,
  }) = _ProviderData;

  factory ProviderData.fromJson(Map<String, dynamic> json) =>
      _$ProviderDataFromJson(json);
}
