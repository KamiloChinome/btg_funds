import 'package:btg_funds/funds/domain/fund.dart';
import 'package:btg_funds/funds/domain/fund_category.dart';
import 'package:btg_funds/funds/infrastructure/fund_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FundDTO', () {
    test('fromJson creates correct DTO', () {
      final json = {
        'id': '1',
        'name': 'FPV_BTG_PACTUAL_RECAUDADORA',
        'minimum_amount': 75000.0,
        'category': 'FPV',
      };

      final dto = FundDTO.fromJson(json);

      expect(dto.id, '1');
      expect(dto.name, 'FPV_BTG_PACTUAL_RECAUDADORA');
      expect(dto.minimumAmount, 75000.0);
      expect(dto.category, 'FPV');
    });

    test('toDomain converts DTO to domain model', () {
      const dto = FundDTO(
        id: '3',
        name: 'DEUDAPRIVADA',
        minimumAmount: 50000,
        category: 'FIC',
      );

      final fund = dto.toDomain();

      expect(fund.id, '3');
      expect(fund.name, 'DEUDAPRIVADA');
      expect(fund.minimumAmount, 50000);
      expect(fund.category, FundCategory.fic);
    });

    test('fromDomain creates DTO from domain model', () {
      const fund = Fund(
        id: '5',
        name: 'FPV_BTG_PACTUAL_DINAMICA',
        minimumAmount: 100000,
        category: FundCategory.fpv,
      );

      final dto = FundDTO.fromDomain(fund);

      expect(dto.id, '5');
      expect(dto.name, 'FPV_BTG_PACTUAL_DINAMICA');
      expect(dto.minimumAmount, 100000);
      expect(dto.category, 'FPV');
    });

    test('round-trip domain -> DTO -> domain preserves data', () {
      const original = Fund(
        id: '2',
        name: 'FPV_BTG_PACTUAL_ECOPETROL',
        minimumAmount: 125000,
        category: FundCategory.fpv,
      );

      final roundTripped = FundDTO.fromDomain(original).toDomain();

      expect(roundTripped, original);
    });

    test('round-trip JSON -> DTO -> JSON preserves data', () {
      final json = {
        'id': '4',
        'name': 'FDO-ACCIONES',
        'minimum_amount': 250000.0,
        'category': 'FIC',
      };

      final roundTripped = FundDTO.fromJson(json).toJson();

      expect(roundTripped, json);
    });
  });
}
