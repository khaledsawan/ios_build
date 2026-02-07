class LocationEntity {
  final String locationID;
  final String userID;
  final String label;
  final String phoneNumber;
  final String floor;
  final String address;
  final String flat;
  final bool isDefault;

  LocationEntity({
    required this.userID,
    required this.label,
    required this.floor,
    required this.address,
    required this.flat,
    required this.isDefault,
    required this.phoneNumber,
    required this.locationID,
  });
}
