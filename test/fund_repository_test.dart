import 'package:btg_funds/core/domain/failure.dart';
import 'package:btg_funds/funds/domain/fund_category.dart';
import 'package:btg_funds/funds/infrastructure/fund_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FundRepository repository;

  setUp(() {
    repository = FundRepository();
  });

  group('FundRepository', () {
    test('fetchAll returns all 5 funds', () async {
      final result = await repository.fetchAll();

      result.fold(
        (failure) => fail('Should not fail: ${failure.displayMessage}'),
        (funds) {
          expect(funds.length, 5);
        },
      );
    });

    test('fetchAll returns funds with correct data', () async {
      final result = await repository.fetchAll();

      result.fold(
        (failure) => fail('Should not fail'),
        (funds) {
          // Verify first fund
          final fund1 = funds.firstWhere((f) => f.id == '1');
          expect(fund1.name, 'FPV_BTG_PACTUAL_RECAUDADORA');
          expect(fund1.minimumAmount, 75000);
          expect(fund1.category, FundCategory.fpv);

          // Verify FIC fund
          final fund3 = funds.firstWhere((f) => f.id == '3');
          expect(fund3.name, 'DEUDAPRIVADA');
          expect(fund3.minimumAmount, 50000);
          expect(fund3.category, FundCategory.fic);
        },
      );
    });

    test('fetchById returns correct fund', () async {
      final result = await repository.fetchById('2');

      result.fold(
        (failure) => fail('Should not fail'),
        (fund) {
          expect(fund.id, '2');
          expect(fund.name, 'FPV_BTG_PACTUAL_ECOPETROL');
          expect(fund.minimumAmount, 125000);
          expect(fund.category, FundCategory.fpv);
        },
      );
    });

    test('fetchById returns failure for non-existent fund', () async {
      final result = await repository.fetchById('999');

      result.fold(
        (failure) => expect(failure, isA<FundNotFound>()),
        (_) => fail('Should have failed'),
      );
    });
  });
}
