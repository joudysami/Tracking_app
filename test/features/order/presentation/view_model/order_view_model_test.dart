import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/confirm_delivery_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';
import 'package:tracking_app/features/order/domain/repo/order_repo.dart';
import 'package:tracking_app/features/order/domain/use_case/confirm_delivery_usecase.dart';
import 'package:tracking_app/features/order/domain/use_case/order_status_use_case.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_event.dart';
import 'package:tracking_app/features/order/presentation/view_model/order_view_model.dart';

class FakeOrderRepo implements OrderRepo {
  String? lastUpdatedOrderId;
  String? lastUpdatedStatus;
  String? lastUpdatedNote;
  String? lastConfirmedOrderId;
  bool shouldFailUpdate = false;
  bool shouldFailConfirm = false;

  @override
  Future<BaseResponse<OrderDetailsEntity>> updateStatus({
    required String orderId,
    required String status,
    required String note,
  }) async {
    lastUpdatedOrderId = orderId;
    lastUpdatedStatus = status;
    lastUpdatedNote = note;
    if (shouldFailUpdate) {
      return ErrorResponse(
        appError: BadResponseError('Failed to update status'),
      );
    }
    return SuccessResponse(
      OrderDetailsEntity(
        orderId: orderId,
        orderNumber: orderId,
        status: status,
        createdAt: '2024-09-03T11:00:00.000',
        customerName: 'Nour mohamed',
        customerAddress: '20th st, Sheikh Zayed, Giza',
        storeName: 'Flowery store',
        storeAddress: '20th st, Sheikh Zayed, Giza',
        totalAmount: 3000,
        paymentMethod: 'Cash on delivery',
        items: const [],
      ),
    );
  }

  @override
  Future<BaseResponse<ConfirmDeliveryEntity>> confirmDelivery({
    required String orderId,
  }) async {
    lastConfirmedOrderId = orderId;
    if (shouldFailConfirm) {
      return ErrorResponse(
        appError: BadResponseError('Failed to confirm delivery'),
      );
    }
    return SuccessResponse(
      ConfirmDeliveryEntity(
        orderId: orderId,
        status: 'Delivered',
        confirmedAt: '2024-09-03T12:00:00.000',
      ),
    );
  }
}

void main() {
  late FakeOrderRepo fakeRepo;
  late UpdateOrderStatusUseCase updateUseCase;
  late ConfirmDeliveryUseCase confirmUseCase;
  late OrderViewModel viewModel;

  setUp(() {
    fakeRepo = FakeOrderRepo();
    updateUseCase = UpdateOrderStatusUseCase(fakeRepo);
    confirmUseCase = ConfirmDeliveryUseCase(fakeRepo);
    viewModel = OrderViewModel(
      updateOrderStatusUseCase: updateUseCase,
      confirmDeliveryUseCase: confirmUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  test('initializes order from AvailableOrderEntity', () {
    final available = AvailableOrderEntity(
      orderId: '123456',
      customerName: 'Nour mohamed',
      customerAddress: '20th st, Sheikh Zayed, Giza',
      storeId: 'store-1',
      storeName: 'Flowery store',
      storeAddress: '20th st, Sheikh Zayed, Giza',
      totalAmount: 3000,
      status: 'accepted',
      createdAt: DateTime(2024, 9, 3, 11),
    );

    viewModel.doEvent(InitializeOrderEvent(available));

    expect(viewModel.state.order?.orderId, '123456');
    expect(viewModel.state.order?.status, 'accepted');
    expect(viewModel.state.order?.items.length, 2);
  });

  test('advances status from accepted to picked on AdvanceOrderStepEvent',
      () async {
    final available = AvailableOrderEntity(
      orderId: '123456',
      customerName: 'Nour mohamed',
      customerAddress: '20th st, Sheikh Zayed, Giza',
      storeId: 'store-1',
      storeName: 'Flowery store',
      storeAddress: '20th st, Sheikh Zayed, Giza',
      totalAmount: 3000,
      status: 'accepted',
      createdAt: DateTime(2024, 9, 3, 11),
    );

    viewModel.doEvent(InitializeOrderEvent(available));
    viewModel.doEvent(const AdvanceOrderStepEvent());
    await pumpEventQueue();

    expect(fakeRepo.lastUpdatedOrderId, '123456');
    expect(fakeRepo.lastUpdatedStatus, 'picked');
    expect(viewModel.state.order?.status, 'picked');
    expect(viewModel.state.updateStatusState.isLoading, isFalse);
  });

  test('calls confirmDelivery when order reaches arrived status', () async {
    final available = AvailableOrderEntity(
      orderId: '123456',
      customerName: 'Nour mohamed',
      customerAddress: '20th st, Sheikh Zayed, Giza',
      storeId: 'store-1',
      storeName: 'Flowery store',
      storeAddress: '20th st, Sheikh Zayed, Giza',
      totalAmount: 3000,
      status: 'arrived',
      createdAt: DateTime(2024, 9, 3, 11),
    );

    viewModel.doEvent(InitializeOrderEvent(available));
    viewModel.doEvent(const AdvanceOrderStepEvent());
    await pumpEventQueue();

    expect(fakeRepo.lastConfirmedOrderId, '123456');
    expect(viewModel.state.order?.status, 'delivered');
  });

  test('surfaces error message when status update fails', () async {
    fakeRepo.shouldFailUpdate = true;

    final available = AvailableOrderEntity(
      orderId: '123456',
      customerName: 'Nour mohamed',
      customerAddress: '20th st, Sheikh Zayed, Giza',
      storeId: 'store-1',
      storeName: 'Flowery store',
      storeAddress: '20th st, Sheikh Zayed, Giza',
      totalAmount: 3000,
      status: 'accepted',
      createdAt: DateTime(2024, 9, 3, 11),
    );

    viewModel.doEvent(InitializeOrderEvent(available));
    viewModel.doEvent(const AdvanceOrderStepEvent());
    await pumpEventQueue();

    expect(
      viewModel.state.updateStatusState.errorMessage,
      'Failed to update status',
    );
  });
}
