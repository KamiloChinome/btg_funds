import 'package:btg_funds/funds/domain/fund_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund.freezed.dart';

/// Domain model representing an investment fund.
/// This is a pure domain entity — no infrastructure concerns.
@freezed
sealed class Fund with _$Fund {
  const Fund._();

  const factory Fund({
    required String id,
    required String name,
    required double minimumAmount,
    required FundCategory category,
  }) = _Fund;

  /// Creates an empty fund instance (used as default/fallback).
  factory Fund.empty() => const Fund(
        id: '0',
        name: '',
        minimumAmount: 0,
        category: FundCategory.fpv,
      );
}
