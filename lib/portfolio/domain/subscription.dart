import 'package:btg_funds/core/domain/notification_method.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';

/// Domain model representing an active fund subscription.
/// Tracks the user's participation in a specific fund.
@freezed
sealed class Subscription with _$Subscription {
  const Subscription._();

  const factory Subscription({
    required String fundId,
    required String fundName,
    required double amount,
    required DateTime date,
    required NotificationMethod notificationMethod,
  }) = _Subscription;
}
