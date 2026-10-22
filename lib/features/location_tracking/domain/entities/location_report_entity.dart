class LocationReportEntity {
  const LocationReportEntity({
    required this.recordedAt,
    required this.updatedOrderIds,
    required this.broadcast,
  });

  final DateTime recordedAt;
  final List<String> updatedOrderIds;
  final bool broadcast;
}
