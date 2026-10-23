
import 'package:equatable/equatable.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';

class HomeState extends Equatable {
  final BaseState<List<AvailableOrderEntity>> ordersState;
  final BaseState<ClaimedOrderEntity> claimOrderState;
  final pagination_entity? pagination;

  const HomeState({
    this.ordersState = const BaseState(),
    this.claimOrderState = const BaseState(),
    this.pagination,
  });

  HomeState copyWith({
    BaseState<List<AvailableOrderEntity>>? ordersState,
    BaseState<ClaimedOrderEntity>? claimOrderState,
    pagination_entity? pagination,
  }) {
    return HomeState(
      ordersState: ordersState ?? this.ordersState,
      claimOrderState: claimOrderState ?? this.claimOrderState,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [
        ordersState,
        claimOrderState,
        pagination,
      ];
}
