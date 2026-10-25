import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';

class HomeState extends Equatable {
  final BaseState<List<AvailableOrderEntity>> ordersState;
  final BaseState<ClaimedOrderEntity> claimOrderState;
  final PaginationEntity? pagination;
  final String? claimingOrderId;

  const HomeState({
    this.ordersState = const BaseState(),
    this.claimOrderState = const BaseState(),
    this.pagination,
    this.claimingOrderId,
  });

  HomeState copyWith({
    BaseState<List<AvailableOrderEntity>>? ordersState,
    BaseState<ClaimedOrderEntity>? claimOrderState,
    PaginationEntity? pagination,
    String? claimingOrderId,
    bool clearClaimingOrderId = false,
  }) {
    return HomeState(
      ordersState: ordersState ?? this.ordersState,
      claimOrderState: claimOrderState ?? this.claimOrderState,
      pagination: pagination ?? this.pagination,
      claimingOrderId: clearClaimingOrderId
          ? null
          : claimingOrderId ?? this.claimingOrderId,
    );
  }

  @override
  List<Object?> get props => [
    ordersState,
    claimOrderState,
    pagination,
    claimingOrderId,
  ];
}
