import 'package:btg_funds/funds/domain/fund.dart';
import 'package:btg_funds/funds/shared/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'funds_notifier.g.dart';

/// Notifier that manages the list of available investment funds.
/// Loads fund data from the repository on initialization.
@riverpod
class FundsNotifier extends _$FundsNotifier {
  @override
  FutureOr<List<Fund>> build() async {
    final repository = ref.watch(fundRepositoryProvider);
    final result = await repository.fetchAll();

    return result.fold(
      (failure) => throw Exception(failure.displayMessage),
      (funds) => funds,
    );
  }

  /// Reloads the fund list from the repository.
  Future<void> refresh() async {
    state = const AsyncLoading();

    final repository = ref.read(fundRepositoryProvider);
    final result = await repository.fetchAll();

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      AsyncData.new,
    );
  }
}
