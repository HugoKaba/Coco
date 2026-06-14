// ignore_for_file: invalid_use_of_protected_member
part of 'club_discovery_screen.dart';

Widget _buildClubQuickFilters(_ClubDiscoveryScreenState s) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      children: [
        FilterChip(
          label: const Text('Mes Clubs'),
          selected: s._showOnlyMyClubs,
          onSelected: (selected) {
            s.setState(() => s._showOnlyMyClubs = selected);
            s._searchClubs();
          },
          avatar: s._showOnlyMyClubs ? const Icon(Icons.check, size: 16) : null,
        ),
        const SizedBox(width: 8),
        ...['Tennis', 'Padel', 'Football', 'Badminton'].map((sport) {
          final isSelected = s._filters.selectedSports.contains(sport);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(sport),
              selected: isSelected,
              onSelected: (selected) {
                s.setState(() {
                  final sports = Set<String>.from(s._filters.selectedSports);
                  if (selected) {
                    sports
                      ..clear()
                      ..add(sport);
                  } else {
                    sports.remove(sport);
                  }
                  s._filters = s._filters.copyWith(selectedSports: sports);
                });
                s._searchClubs();
              },
            ),
          );
        }),
      ],
    ),
  );
}

Widget _buildClubList(_ClubDiscoveryScreenState s) {
  if (s._isLoading) return const Center(child: CircularProgressIndicator());
  if (s._clubs.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'clubs.no_clubs_found'.tr(),
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: s._showFilters,
            icon: const Icon(Icons.filter_list),
            label: Text('filters.title'.tr()),
          ),
        ],
      ),
    );
  }
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: s._clubs.length,
    itemBuilder: (_, i) => _clubCard(s, s._clubs[i]),
  );
}

Widget _clubCard(_ClubDiscoveryScreenState s, ClubEntity club) {
  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () => Navigator.of(s.context).push(
        MaterialPageRoute(builder: (_) => ClubDetailScreen(clubId: club.id)),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (club.logoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  club.logoUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  cacheWidth: 120,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(s.context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.sports, color: Theme.of(s.context).colorScheme.primary),
                  ),
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(
                    s.context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.sports,
                  color: Theme.of(s.context).colorScheme.primary,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    club.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    club.sportType,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

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
        ],
      ),
      Positioned(
        top: 12,
        left: 16,
        right: 16,
        child: _buildCitySearchBar(s),
      ),
      if (s._isLoading)
        const Center(child: CircularProgressIndicator()),
    ],
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
          decoration: const InputDecoration(
            hintText: 'Rechercher une ville en Île-de-France...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          ),
        );
      },
    ),
  );
}
