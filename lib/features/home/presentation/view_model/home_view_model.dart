import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/home/domain/use_case/claim_order_usecase.dart';
import 'package:tracking_app/features/home/domain/use_case/get_available_order_usecase.dart';

import 'home_event.dart';
import 'home_state.dart';

@Injectable()
class HomeCubit extends Cubit<HomeState> {
  final GetAvailableOrdersUseCase getAvailableOrdersUseCase;
  final ClaimOrderUseCase claimOrderUseCase;

  HomeCubit({
    required this.getAvailableOrdersUseCase,
    required this.claimOrderUseCase,
  }) : super(const HomeState());

  Future<void> doEvent(HomeEvent event) {
    switch (event) {
      case GetAvailableOrdersEvent():
        return getAvailableOrders(page: event.page, pageSize: event.pageSize);
      case ClaimOrderEvent():
        return claimOrder(event.orderId);
    }
  }

  Future<void> getAvailableOrders({int page = 1, int pageSize = 20}) async {
    emit(
      state.copyWith(
        ordersState: state.ordersState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    try {
      final result = await getAvailableOrdersUseCase(
        page: page,
        pageSize: pageSize,
      );

      emit(
        state.copyWith(
          ordersState: state.ordersState.copyWith(
            isLoading: false,
            errorMessage: '',
            data: result.orders,
          ),
          pagination: result.pagination,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          ordersState: state.ordersState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> claimOrder(String orderId) async {
    if (state.claimingOrderId != null) return;

    emit(
      state.copyWith(
        claimingOrderId: orderId,
        claimOrderState: state.claimOrderState.copyWith(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
    );

    try {
      final claimedOrder = await claimOrderUseCase(orderId: orderId);

      final updatedOrders = (state.ordersState.data ?? [])
          .where((order) => order.orderId != orderId)
          .toList();

      emit(
        state.copyWith(
          clearClaimingOrderId: true,
          ordersState: state.ordersState.copyWith(data: updatedOrders),
          claimOrderState: state.claimOrderState.copyWith(
            isLoading: false,
            errorMessage: '',
            data: claimedOrder,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          clearClaimingOrderId: true,
          claimOrderState: state.claimOrderState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ),
      );
    }
  }
}
