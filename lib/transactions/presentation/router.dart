import 'package:btg_funds/transactions/presentation/screens/transactions_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'router.g.dart';

@TypedGoRoute<TransactionsRoute>(path: '/transactions')
class TransactionsRoute extends GoRouteData {
  const TransactionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TransactionsScreen();
}
