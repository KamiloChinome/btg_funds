import 'package:btg_funds/portfolio/presentation/screens/portfolio_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@TypedGoRoute<PortfolioRoute>(path: '/portfolio')
class PortfolioRoute extends GoRouteData {
  const PortfolioRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PortfolioScreen();
}
