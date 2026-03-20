import 'package:btg_funds/funds/infrastructure/fund_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// Module constant for the funds feature.
const fundsModule = 'funds';

/// Provides a singleton instance of [FundRepository].
@riverpod
FundRepository fundRepository(Ref ref) => FundRepository();
