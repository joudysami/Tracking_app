import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';
import 'package:tracking_app/features/home/domain/use_case/claim_order_usecase.dart';
import 'package:tracking_app/features/home/domain/use_case/get_available_order_usecase.dart';
import 'package:tracking_app/features/home/presentation/view/screen/home_screen.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/accept_button.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_view_model.dart';

void main() {
  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
  });

  testWidgets('shows a loader, then the loaded orders', (tester) async {
    final gate = Completer<void>();
    final repo = _FakeOrderRepo()
      ..delay = gate.future
      ..pages.add([_order('a')]);
    final cubit = _cubit(repo);
    addTearDown(cubit.close);

    await tester.pumpWidget(_app(cubit));
    final loading = cubit.doEvent(const GetAvailableOrdersEvent());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    gate.complete();
    await loading;
    await tester.pumpAndSettle();

    expect(find.text('Store a'), findsOneWidget);
    expect(repo.requestedPages, [1]);
  });

  testWidgets('shows the empty state', (tester) async {
    final repo = _FakeOrderRepo()..pages.add([]);
    final cubit = _cubit(repo);
    addTearDown(cubit.close);
    await cubit.doEvent(const GetAvailableOrdersEvent());

    await tester.pumpWidget(_app(cubit));
    await tester.pumpAndSettle();

    expect(find.text('No available orders'), findsOneWidget);
  });

  testWidgets('shows an error and retries the same request', (tester) async {
    final repo = _FakeOrderRepo()
      ..failures.add(Exception('offline'))
      ..pages.add([_order('a')]);
    final cubit = _cubit(repo);
    addTearDown(cubit.close);
    await cubit.doEvent(const GetAvailableOrdersEvent());

    await tester.pumpWidget(_app(cubit));
    await tester.pumpAndSettle();

    expect(find.textContaining('offline'), findsWidgets);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Store a'), findsOneWidget);
    expect(repo.requestedPages, [1, 1]);
  });

  testWidgets('pull to refresh waits for the next page of orders', (
    tester,
  ) async {
    final repo = _FakeOrderRepo()
      ..pages.add([_order('a')])
      ..pages.add([_order('a'), _order('b')]);
    final cubit = _cubit(repo);
    addTearDown(cubit.close);
    await cubit.doEvent(const GetAvailableOrdersEvent());

    await tester.pumpWidget(_app(cubit));
    await tester.pumpAndSettle();

    await tester.fling(find.byType(ListView), const Offset(0, 400), 1200);
    await tester.pumpAndSettle();

    expect(find.text('Store b'), findsOneWidget);
    expect(repo.requestedPages, [1, 1]);
  });

  testWidgets('only the tapped order shows a claim loader', (tester) async {
    final gate = Completer<void>();
    final repo = _FakeOrderRepo()
      ..pages.add([_order('a'), _order('b')])
      ..claimDelay = gate.future;
    final cubit = _cubit(repo);
    addTearDown(cubit.close);
    await cubit.doEvent(const GetAvailableOrdersEvent());

    await tester.pumpWidget(_app(cubit));
    await tester.pumpAndSettle();

    final claim = cubit.doEvent(const ClaimOrderEvent(orderId: 'a'));
    await tester.pump();
    await tester.pump();

    final buttons = tester
        .widgetList<AcceptButton>(find.byType(AcceptButton))
        .toList();
    expect(buttons.map((button) => button.isLoading).toList(), [true, false]);

    await tester.tap(find.byType(AcceptButton).at(1));
    await tester.pump();
    gate.complete();
    await claim;
    await tester.pump();

    expect(repo.claimedIds, ['a']);
  });

  testWidgets('a claim snackbar is not repeated by a later refresh', (
    tester,
  ) async {
    final repo = _FakeOrderRepo()
      ..pages.add([_order('a'), _order('b')])
      ..pages.add([_order('b')]);
    final cubit = _cubit(repo);
    addTearDown(cubit.close);
    await cubit.doEvent(const GetAvailableOrdersEvent());

    await tester.pumpWidget(_app(cubit));
    await tester.pumpAndSettle();

    await cubit.doEvent(const ClaimOrderEvent(orderId: 'a'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    await cubit.doEvent(const GetAvailableOrdersEvent());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Store a'), findsNothing);
  });

  testWidgets('a claim error snackbar is not repeated by a later refresh', (
    tester,
  ) async {
    final repo = _FakeOrderRepo()
      ..pages.add([_order('a')])
      ..pages.add([_order('a')])
      ..claimFailure = Exception('claim failed');
    final cubit = _cubit(repo);
    addTearDown(cubit.close);
    await cubit.doEvent(const GetAvailableOrdersEvent());

    await tester.pumpWidget(_app(cubit));
    await tester.pumpAndSettle();

    await cubit.doEvent(const ClaimOrderEvent(orderId: 'a'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('claim failed'), findsOneWidget);

    await cubit.doEvent(const GetAvailableOrdersEvent());
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}

HomeCubit _cubit(_FakeOrderRepo repo) {
  return HomeCubit(
    getAvailableOrdersUseCase: GetAvailableOrdersUseCase(repo),
    claimOrderUseCase: ClaimOrderUseCase(repo),
  );
}

Widget _app(HomeCubit cubit) {
  return MaterialApp(
    home: BlocProvider.value(value: cubit, child: const HomeScreen()),
  );
}

class _FakeOrderRepo implements OrderRepo {
  final List<List<AvailableOrderEntity>> pages = [];
  final List<Exception> failures = [];
  final List<int> requestedPages = [];
  final List<String> claimedIds = [];
  Future<void>? delay;
  Future<void>? claimDelay;
  Exception? claimFailure;

  @override
  Future<({List<AvailableOrderEntity> orders, PaginationEntity pagination})>
  getAvailableOrders({required int page, required int pageSize}) async {
    final pending = delay;
    delay = null;
    if (pending != null) await pending;
    requestedPages.add(page);
    if (failures.isNotEmpty) {
      throw failures.removeAt(0);
    }
    final orders = pages.removeAt(0);
    return (
      orders: orders,
      pagination: PaginationEntity(
        page: page,
        pageSize: pageSize,
        totalCount: orders.length,
        totalPages: 1,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );
  }

  @override
  Future<ClaimedOrderEntity> claimOrder({required String orderId}) async {
    final pending = claimDelay;
    claimDelay = null;
    if (pending != null) await pending;
    final failure = claimFailure;
    claimFailure = null;
    if (failure != null) throw failure;
    claimedIds.add(orderId);
    return ClaimedOrderEntity(
      orderId: orderId,
      orderNumber: 'ORD-$orderId',
      status: 'PLACED',
      assignmentStatus: 'Accepted',
      assignedAt: DateTime.utc(2026, 9, 12),
    );
  }
}

AvailableOrderEntity _order(String id) {
  return AvailableOrderEntity(
    orderId: id,
    customerName: 'Customer $id',
    customerAddress: 'User $id',
    storeId: 'store-$id',
    storeName: 'Store $id',
    storeAddress: 'Pickup $id',
    totalAmount: 10,
    status: 'Placed',
    createdAt: DateTime(2024, 9, 3, 11),
  );
}
