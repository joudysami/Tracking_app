import 'package:equatable/equatable.dart';

class LocationReportEntity extends Equatable {
  const LocationReportEntity({
    required this.recordedAt,
    required this.updatedOrderIds,
    required this.broadcast,
  });

  final DateTime recordedAt;
  final List<String> updatedOrderIds;
  final bool broadcast;
  get props => [recordedAt, updatedOrderIds, broadcast];
}
