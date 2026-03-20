import 'package:btg_funds/core/domain/notification_method.dart';
import 'package:btg_funds/transactions/domain/fund_transaction.dart';
import 'package:btg_funds/transactions/domain/transaction_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund_transaction_dto.freezed.dart';
part 'fund_transaction_dto.g.dart';

/// Data Transfer Object for [FundTransaction].
/// Handles serialization between JSON and the domain layer.
@freezed
sealed class FundTransactionDTO with _$FundTransactionDTO {
  const FundTransactionDTO._();

  const factory FundTransactionDTO({
    required String id,
    @JsonKey(name: 'fund_id') required String fundId,
    @JsonKey(name: 'fund_name') required String fundName,
    required String type,
    required double amount,
    required String date,
    @JsonKey(name: 'notification_method') String? notificationMethod,
  }) = _FundTransactionDTO;

  /// Creates a [FundTransactionDTO] from a JSON map.
  factory FundTransactionDTO.fromJson(Map<String, dynamic> json) =>
      _$FundTransactionDTOFromJson(json);

  /// Creates a [FundTransactionDTO] from a domain [FundTransaction] entity.
  factory FundTransactionDTO.fromDomain(FundTransaction transaction) =>
      FundTransactionDTO(
        id: transaction.id,
        fundId: transaction.fundId,
        fundName: transaction.fundName,
        type: transaction.type.name,
        amount: transaction.amount,
        date: transaction.date.toIso8601String(),
        notificationMethod: transaction.notificationMethod?.name,
      );

  /// Converts this DTO to a domain [FundTransaction] entity.
  FundTransaction toDomain() => FundTransaction(
        id: id,
        fundId: fundId,
        fundName: fundName,
        type: TransactionType.values.firstWhere((e) => e.name == type),
        amount: amount,
        date: DateTime.parse(date),
        notificationMethod: notificationMethod != null
            ? NotificationMethod.values
                .firstWhere((e) => e.name == notificationMethod)
            : null,
      );
}
