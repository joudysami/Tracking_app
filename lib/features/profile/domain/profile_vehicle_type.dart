const profileMotorcycle = 'Motorcycle';
const profileCar = 'Car';

String toProfileVehicleType(String raw) {
  final value = raw.trim().toLowerCase();
  if (value == 'bike' || value == 'motorcycle') return profileMotorcycle;
  if (value == 'car') return profileCar;
  return raw.trim();
}
