import 'package:btg_funds/funds/presentation/widgets/fund_card_shimmer.dart';
import 'package:flutter/material.dart';

/// A list of shimmer placeholders displayed while funds are loading.
/// Shows 5 skeleton cards to indicate content is being fetched.
class FundsShimmerList extends StatelessWidget {
  const FundsShimmerList({super.key});

  /// Number of shimmer cards to display.
  static const _shimmerCount = 5;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _shimmerCount,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: FundCardShimmer(),
      ),
    );
  }
}
