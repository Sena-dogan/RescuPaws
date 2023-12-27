import 'package:freezed_annotation/freezed_annotation.dart';
import 'meta_data.dart';
import 'provider_data.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  factory UserData({
  String? uid,
  String? email,
  bool? emailVerified,
  String? displayName,
  String? phoneNumber,
  String? photoUrl,
  bool? disabled,
  Metadata? metadata,
  List<ProviderData>? providerData,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
