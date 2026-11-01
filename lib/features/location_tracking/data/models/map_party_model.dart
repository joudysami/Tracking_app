import 'package:latlong2/latlong.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_details_entity.dart';

class MapPartyModel {
  final String name;
  final String address;
  final String? imageUrl;
  final LatLng location;

  const MapPartyModel({
    required this.name,
    required this.address,
    required this.location,
    this.imageUrl,
  });
}

class OrderMapModel {
  final MapPartyModel store;
  final MapPartyModel user;
  final LatLng driverLocation;
  final List<LatLng> pickupRoute;
  final List<LatLng> userRoute;

  const OrderMapModel({
    required this.store,
    required this.user,
    required this.driverLocation,
    required this.pickupRoute,
    required this.userRoute,
  });
}

final orderMapMock = OrderMapModel(
  store: const MapPartyModel(
    name: 'Flowery store',
    address: '20th st, Sheikh Zayed, Giza',
    location: LatLng(30.0200, 30.9800),
  ),
  user: const MapPartyModel(
    name: 'Nour mohamed',
    address: '20th st, Sheikh Zayed, Giza',
    location: LatLng(30.0120, 30.9950),
  ),
  driverLocation: const LatLng(30.0260, 30.9880),
  pickupRoute: const [
    LatLng(30.0260, 30.9880),
    LatLng(30.0260, 30.9840),
    LatLng(30.0200, 30.9840),
    LatLng(30.0200, 30.9800),
  ],
  userRoute: const [
    LatLng(30.0260, 30.9880),
    LatLng(30.0260, 30.9920),
    LatLng(30.0120, 30.9920),
    LatLng(30.0120, 30.9950),
  ],
);

/// The map for one order: names, addresses and coordinates come from the
/// assigned-order payload, and [orderMapMock] fills in whatever the backend
/// did not send (the claim response and the available-orders list carry no
/// coordinates, and there is no route geometry yet either).
OrderMapModel orderMapFor(OrderDetailsEntity? order) {
  if (order == null) return orderMapMock;

  LatLng? point(double? latitude, double? longitude) {
    if (latitude == null || longitude == null) return null;
    return LatLng(latitude, longitude);
  }

  String fallback(String value, String sample) =>
      value.trim().isEmpty ? sample : value.trim();

  return OrderMapModel(
    store: MapPartyModel(
      name: fallback(order.storeName, orderMapMock.store.name),
      address: fallback(order.storeAddress, orderMapMock.store.address),
      location:
          point(order.storeLatitude, order.storeLongitude) ??
          orderMapMock.store.location,
    ),
    user: MapPartyModel(
      name: fallback(order.customerName, orderMapMock.user.name),
      address: fallback(order.customerAddress, orderMapMock.user.address),
      location:
          point(order.customerLatitude, order.customerLongitude) ??
          orderMapMock.user.location,
    ),
    driverLocation: orderMapMock.driverLocation,
    pickupRoute: orderMapMock.pickupRoute,
    userRoute: orderMapMock.userRoute,
  );
}
