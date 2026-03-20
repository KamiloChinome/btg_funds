import 'package:btg_funds/funds/presentation/screens/funds_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@TypedGoRoute<FundsRoute>(path: '/funds')
class FundsRoute extends GoRouteData {
  const FundsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FundsScreen();
}
