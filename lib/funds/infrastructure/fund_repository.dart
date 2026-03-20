import 'package:btg_funds/core/domain/failure.dart';
import 'package:btg_funds/core/domain/typedefs.dart';
import 'package:btg_funds/funds/domain/fund.dart';
import 'package:btg_funds/funds/infrastructure/fund_dto.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

/// Repository that provides access to the available investment funds.
/// Uses mock data simulating a REST API response.
class FundRepository {
  /// Simulated API delay for realistic loading states.
  static const _apiDelay = Duration(milliseconds: 800);

  /// Mock fund data representing the REST API response.
  static const _mockFundsJson = [
    {
      'id': '1',
      'name': 'FPV_BTG_PACTUAL_RECAUDADORA',
      'minimum_amount': 75000.0,
      'category': 'FPV',
    },
    {
      'id': '2',
      'name': 'FPV_BTG_PACTUAL_ECOPETROL',
      'minimum_amount': 125000.0,
      'category': 'FPV',
    },
    {
      'id': '3',
      'name': 'DEUDAPRIVADA',
      'minimum_amount': 50000.0,
      'category': 'FIC',
    },
    {
      'id': '4',
      'name': 'FDO-ACCIONES',
      'minimum_amount': 250000.0,
      'category': 'FIC',
    },
    {
      'id': '5',
      'name': 'FPV_BTG_PACTUAL_DINAMICA',
      'minimum_amount': 100000.0,
      'category': 'FPV',
    },
  ];

  /// Fetches all available funds from the simulated API.
  /// Returns [Either] a [Failure] or a list of [Fund] domain entities.
  FutureEither<List<Fund>> fetchAll() async {
    try {
      // Simulate network latency
      await Future.delayed(_apiDelay);

      final funds = _mockFundsJson
          .map((json) => FundDTO.fromJson(json).toDomain())
          .toList();

      return right(funds);
    } catch (e, st) {
      return left(Failure.unexpected(
        message: 'failure.loadFundsFailed'.tr(),
        cause: e,
        stackTrace: st,
      ));
    }
  }

  /// Fetches a single fund by its [id].
  /// Returns [Either] a [Failure] or the [Fund] domain entity.
  FutureEither<Fund> fetchById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final json = _mockFundsJson.where((f) => f['id'] == id).firstOrNull;
      if (json == null) {
        return left(Failure.fundNotFound(
          message: 'failure.fundNotFound'.tr(namedArgs: {'id': id}),
        ));
      }

      return right(FundDTO.fromJson(json).toDomain());
    } catch (e, st) {
      return left(Failure.unexpected(
        message: 'failure.loadFundFailed'.tr(),
        cause: e,
        stackTrace: st,
      ));
    }
  }
}
