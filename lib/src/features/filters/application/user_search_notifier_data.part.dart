part of 'user_search_service.dart';

Future<List<City>> _loadCitiesData() async {
  final cityString = await rootBundle.loadString('assets/city/villes_idf.json');
  final cities = (json.decode(cityString) as List)
      .map((e) => City.fromJson(e))
      .toList();
  cities.sort((a, b) => a.name.compareTo(b.name));
  return cities;
}

Future<void> _initUserLocation(UserSearchNotifier n) async {
  final pos = await LocationHelper.initLocation();
  n.ref
      .read(filterProvider.notifier)
      .setDeviceLocation(pos?.latitude ?? 48.8566, pos?.longitude ?? 2.3522);
}
