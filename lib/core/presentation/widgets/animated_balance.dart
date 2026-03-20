import 'package:btg_funds/core/presentation/extensions.dart';
import 'package:flutter/material.dart';

/// Animates a numeric balance value using [TweenAnimationBuilder].
/// When [balance] changes, the displayed number smoothly counts
/// from the old value to the new one.
class AnimatedBalance extends StatelessWidget {
  const AnimatedBalance({
    super.key,
    required this.balance,
    required this.style,
  });

  /// The target balance value to animate towards.
  final double balance;

  /// Text style applied to the formatted balance.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: balance),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text(
          value.toCOP(),
          style: style,
        );
      },
    );
  }
}
