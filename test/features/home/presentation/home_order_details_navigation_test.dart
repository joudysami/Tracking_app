import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';
import 'package:tracking_app/features/home/domain/repo/order_repo.dart';
import 'package:tracking_app/features/home/domain/use_case/claim_order_usecase.dart';
import 'package:tracking_app/features/home/domain/use_case/get_available_order_usecase.dart';
import 'package:tracking_app/features/home/presentation/view/screen/home_screen.dart';
import 'package:tracking_app/features/home/presentation/view/widgets/accept_button.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_event.dart';
import 'package:tracking_app/features/home/presentation/view_model/home_view_model.dart';
import 'package:tracking_app/features/order/presentation/order_details/view/screen/order_details_page.dart';
import 'package:tracking_app/features/order/presentation/screen/order_details_screen.dart';

void main() {
  setUpAll(() async {
    EasyLocalization.logger.enableBuildModes = [];
  });

  testWidgets('opens details for the tapped order and keeps accept separate', (
    tester,
  ) async {
    final cubit = _RecordingHomeCubit()..show([_order('a'), _order('b')]);
    addTearDown(cubit.close);

    await tester.pumpWidget(_app(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Store b'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderDetailsScreen), findsOneWidget);
    expect(find.textContaining(': b'), findsOneWidget);
    expect(find.text('Store b'), findsOneWidget);
    expect(find.text('Store a'), findsNothing);
    expect(cubit.events, isEmpty);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AcceptButton).first);
    await tester.pump();

    expect(cubit.events, hasLength(1));
    expect(cubit.events.single, isA<ClaimOrderEvent>());
    expect((cubit.events.single as ClaimOrderEvent).orderId, 'a');
    expect(find.byType(OrderDetailsScreen), findsNothing);
  });
}

Widget _app(HomeCubit cubit) {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return BlocProvider.value(value: cubit, child: const HomeScreen());
        },
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (context, state) => buildOrderDetailsPage(state.extra),
      ),
    ],
  );
  return MaterialApp.router(routerConfig: router);
}

class _RecordingHomeCubit extends HomeCubit {
  _RecordingHomeCubit()
    : super(
        getAvailableOrdersUseCase: GetAvailableOrdersUseCase(_UnusedRepo()),
        claimOrderUseCase: ClaimOrderUseCase(_UnusedRepo()),
      );

  final List<HomeEvent> events = [];

  @override
  Future<void> doEvent(HomeEvent event) async => events.add(event);

  void show(List<AvailableOrderEntity> orders) {
    emit(state.copyWith(ordersState: BaseState(data: orders)));
  }
}

class _UnusedRepo implements OrderRepo {
  @override
  Future<ClaimedOrderEntity> claimOrder({required String orderId}) {
    throw UnimplementedError();
  }

  @override
  Future<({List<AvailableOrderEntity> orders, PaginationEntity pagination})>
  getAvailableOrders({required int page, required int pageSize}) {
    throw UnimplementedError();
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
    status: 'pending',
    createdAt: DateTime(2024, 9, 3, 11),
  );
}
