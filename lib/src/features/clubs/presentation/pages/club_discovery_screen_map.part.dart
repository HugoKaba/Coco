// ignore_for_file: invalid_use_of_protected_member
part of 'club_discovery_screen.dart';

Widget _buildClubMap(_ClubDiscoveryScreenState s) {
  final center = LatLng(
    s._filters.cityLat ?? 48.8566,
    s._filters.cityLng ?? 2.3522,
  );

  return Stack(
    children: [
      FlutterMap(
        mapController: s._mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: 11,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.coco.app',
          ),
          MarkerLayer(
            markers: s._clubs
                .where((c) => c.lat != 0 && c.lng != 0)
                .map(
                  (club) => Marker(
                    point: LatLng(club.lat, club.lng),
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () => Navigator.of(s.context).push(
                        MaterialPageRoute(
                          builder: (_) => ClubDetailScreen(clubId: club.id),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(s.context).colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sports,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          if (s._filters.deviceLat != null && s._filters.deviceLng != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    s._filters.deviceLat!,
                    s._filters.deviceLng!,
                  ),
                  width: 26,
                  height: 26,
                  child: _buildMyLocationDot(),
                ),
              ],
            ),
        ],
      ),
      Positioned(
        top: 12,
        left: 16,
        right: 16,
        child: _buildCitySearchBar(s),
      ),
      Positioned(
        right: 16,
        bottom: 24,
        child: FloatingActionButton.small(
          heroTag: 'club_locate_me',
          onPressed: s._locateMe,
          tooltip: 'clubs.map.locate_me'.tr(),
          child: const Icon(Icons.my_location),
        ),
      ),
      if (s._isLoading) const Center(child: CircularProgressIndicator()),
    ],
  );
}

/// Point « vous êtes ici » : pastille bleue avec anneau blanc, style position
/// actuelle classique. Affiché à la position de l'appareil sur la carte.
Widget _buildMyLocationDot() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withValues(alpha: 0.4),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),
  );
}

Widget _buildCitySearchBar(_ClubDiscoveryScreenState s) {
  return Material(
    elevation: 4,
    borderRadius: BorderRadius.circular(28),
    child: Autocomplete<CityData>(
      displayStringForOption: (city) => city.nomStandard,
      optionsBuilder: (value) {
        if (!s._citiesLoaded || value.text.trim().isEmpty) {
          return const Iterable<CityData>.empty();
        }
        return CityService.instance.searchCities(value.text.trim());
      },
      onSelected: (city) {
        s.setState(() {
          s._filters = s._filters.copyWith(
            cityName: city.nomStandard,
            cityLat: city.latitude,
            cityLng: city.longitude,
            isAroundMe: false,
          );
        });
        s._mapController.move(LatLng(city.latitude, city.longitude), 13);
        s._searchClubs();
      },
      fieldViewBuilder: (context, controller, focusNode, _) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'clubs.map.search_city_hint'.tr(),
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 14),
          ),
        );
      },
    ),
  );
}
