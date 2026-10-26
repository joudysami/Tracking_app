import 'package:latlong2/latlong.dart';

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