enum StationType { bike, eBike, scooter, smartParking }

class Station {
  String id;
  String name;
  double lat;
  double lng;
  String description;
  String iconAsset;
  int availableBikes;
  int numberOfStation;
  int availableParking;
  String workTime;
  double distanceKm;
  StationType type; // 👈 نوع ایستگاه

  Station({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.description,
    required this.iconAsset,
    required this.numberOfStation,
    required this.availableParking,
    required this.workTime,
    required this.type, // 👈 اضافه شد
    this.availableBikes = 3,
    this.distanceKm = -1,
  });
}
