import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/home/domain/use_case/claim_order_usecase.dart';
import 'package:tracking_app/features/home/domain/use_case/get_available_order_usecase.dart';

import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetAvailableOrdersUseCase getAvailableOrdersUseCase;
  final ClaimOrderUseCase claimOrderUseCase;

  HomeCubit({
    required this.getAvailableOrdersUseCase,
    required this.claimOrderUseCase,
  }) : super(const HomeState());

  void doEvent(HomeEvent event) {
    switch (event) {
      case GetAvailableOrdersEvent():
        _getAvailableOrders(page: event.page, pageSize: event.pageSize);
        break;

      case ClaimOrderEvent():
        _claimOrder(event.orderId);
        break;
    }
  }

  void loadNextPage() {
    if (state.ordersState.isLoading) return;

    final pagination = state.pagination;

    if (pagination == null || !pagination.hasNextPage) return;

    doEvent(
      GetAvailableOrdersEvent(
        page: pagination.page + 1,
        pageSize: pagination.pageSize,
      ),
    );
  }

  Future<void> _getAvailableOrders({int page = 1, int pageSize = 20}) async {
    if (state.ordersState.isLoading) return;

    emit(
      state.copyWith(
        ordersState: state.ordersState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final result = await getAvailableOrdersUseCase(
      page: page,
      pageSize: pageSize,
    );

    switch (result) {
      case SuccessResponse(data: final data):
        if (data == null) {
          emit(
            state.copyWith(
              ordersState: state.ordersState.copyWith(
                isLoading: false,
                errorMessage: 'No data received',
              ),
            ),
          );
          return;
        }

        final currentOrders = state.ordersState.data ?? [];

        final updatedOrders = page == 1
            ? data.orders
            : [
                ...currentOrders,
                ...data.orders.where(
                  (newOrder) => !currentOrders.any(
                    (order) => order.orderId == newOrder.orderId,
                  ),
                ),
              ];

        emit(
          state.copyWith(
            ordersState: state.ordersState.copyWith(
              isLoading: false,
              errorMessage: '',
              data: updatedOrders,
            ),
            pagination: data.pagination,
          ),
        );

      case ErrorResponse(appError: final appError):
        emit(
          state.copyWith(
            ordersState: state.ordersState.copyWith(
              isLoading: false,
              errorMessage: appError.message,
            ),
          ),
        );
    }
  }

  Future<void> _claimOrder(String orderId) async {
    if (state.claimOrderState.isLoading) return;

    emit(
      state.copyWith(
        claimOrderState: state.claimOrderState.copyWith(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
    );

    final result = await claimOrderUseCase(orderId: orderId);

    switch (result) {
      case SuccessResponse(data: final claimedOrder):
        if (claimedOrder == null) {
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
          return;
        }

        final updatedOrders = (state.ordersState.data ?? [])
            .where((order) => order.orderId != orderId)
            .toList();

        emit(
          state.copyWith(
            ordersState: state.ordersState.copyWith(data: updatedOrders),
            claimOrderState: state.claimOrderState.copyWith(
              isLoading: false,
              errorMessage: '',
              data: claimedOrder,
            ),
          ),
        );

      case ErrorResponse(appError: final appError):
        emit(
          state.copyWith(
            claimOrderState: state.claimOrderState.copyWith(
              isLoading: false,
              errorMessage: appError.message,
            ),
          ),
        );
    }
  }
}
