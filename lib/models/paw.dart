import 'package:freezed_annotation/freezed_annotation.dart';

part 'paw.freezed.dart';

@freezed
class Paw with _$Paw {
  const factory Paw({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String videoUrl,
    required String createdAt,
    required String updatedAt,
  }) = _Paw;

  factory Paw.fromJson(Map<String, dynamic> json) => _$PawFromJson(json);
}
