import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_request.freezed.dart';
part 'token_request.g.dart';

@freezed
class TokenRequest with _$TokenRequest {
  factory TokenRequest({
    @Default('mail@mail.com') String email,
    @Default('asdsdxda') String password,
  }) = _TokenRequest;

  factory TokenRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenRequestFromJson(json);
}

