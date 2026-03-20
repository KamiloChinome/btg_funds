import 'package:btg_funds/funds/domain/fund.dart';
import 'package:btg_funds/funds/domain/fund_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund_dto.freezed.dart';
part 'fund_dto.g.dart';

/// Data Transfer Object for [Fund].
/// Handles serialization/deserialization between JSON (API/mock data)
/// and the domain layer.
@freezed
sealed class FundDTO with _$FundDTO {
  const FundDTO._();

  const factory FundDTO({
    required String id,
    required String name,
    @JsonKey(name: 'minimum_amount') required double minimumAmount,
    required String category,
  }) = _FundDTO;

  /// Creates a [FundDTO] from a JSON map.
  factory FundDTO.fromJson(Map<String, dynamic> json) =>
      _$FundDTOFromJson(json);

  /// Creates a [FundDTO] from a domain [Fund] entity.
  factory FundDTO.fromDomain(Fund fund) => FundDTO(
        id: fund.id,
        name: fund.name,
        minimumAmount: fund.minimumAmount,
        category: fund.category.name.toUpperCase(),
      );

  /// Converts this DTO to a domain [Fund] entity.
  Fund toDomain() => Fund(
        id: id,
        name: name,
        minimumAmount: minimumAmount,
        category: FundCategory.fromString(category),
      );
}
