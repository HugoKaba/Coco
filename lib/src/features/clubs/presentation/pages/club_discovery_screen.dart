import 'package:coco/src/core/city_service.dart';
import 'package:coco/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../application/club_providers.dart';
import '../../domain/models/club_entity.dart';
import '../../domain/models/club_filter_criteria.dart';
import '../widgets/club_filters_sheet.dart';
import 'club_detail_screen.dart';

part 'club_discovery_screen_ui.part.dart';
part 'club_discovery_screen_map.part.dart';

class ClubDiscoveryScreen extends ConsumerStatefulWidget {
  const ClubDiscoveryScreen({super.key});
  @override
  ConsumerState<ClubDiscoveryScreen> createState() =>
      _ClubDiscoveryScreenState();
}

class _ClubDiscoveryScreenState extends ConsumerState<ClubDiscoveryScreen> {
  ClubFilterCriteria _filters = const ClubFilterCriteria(
    cityName: 'Paris',
    cityLat: 48.8566,
    cityLng: 2.3522,
    radiusKm: 50,
    isAroundMe: false,
  );
  List<ClubEntity> _clubs = [];
  bool _showOnlyMyClubs = false;
  bool _isLoading = false;
  bool _isMapView = true;
  bool _citiesLoaded = false;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Chargement des villes pour l'autocomplete de recherche sur la carte (com-94).
    CityService.instance.loadCities().then((_) {
      if (mounted) setState(() => _citiesLoaded = true);
    });
    // Recherche immédiate (villes par défaut = Paris) puis re-recherche une fois
    // la position de l'appareil obtenue dans _initializeLocation() (venu de main).
    _searchClubs();
    _initializeLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(
        () => _filters = _filters.copyWith(
          deviceLat: position.latitude,
          deviceLng: position.longitude,
        ),
      );
      _searchClubs();
    } catch (_) {
      _searchClubs();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('errors.location_error'.tr())));
      }
      if (mounted) {
        _searchClubs();
      }
    }
  }

  Future<void> _searchClubs() async {
    setState(() => _isLoading = true);
    try {
      if (_showOnlyMyClubs) {
        final user = ref.read(authServiceProvider).currentUser;
        if (user != null) {
          final memberships = await ref
              .read(membershipRepositoryProvider)
              .getUserMemberships(user.uid);
          final clubRepo = ref.read(clubRepositoryProvider);
          final clubs = <ClubEntity>[];
          for (final id
              in memberships.where((m) => m.isActive).map((m) => m.clubId)) {
            final club = await clubRepo.getClubById(id);
            if (club != null) clubs.add(club);
          }
          setState(() {
            _clubs = clubs;
            _isLoading = false;
          });
          return;
        }
      }

      final searchLat = _filters.searchLat ?? _filters.cityLat;
      final searchLng = _filters.searchLng ?? _filters.cityLng;
      if (searchLat == null || searchLng == null) {
        setState(() => _isLoading = false);
        return;
      }

      final results = await ref
          .read(clubSearchServiceProvider)
          .searchNearby(
            lat: searchLat,
            lng: searchLng,
            radiusKm: _filters.radiusKm,
            sportType: _filters.selectedSports.isEmpty
                ? null
                : _filters.selectedSports.first,
          );
      setState(() {
        _clubs = results;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _showFilters() {
    showClubFiltersSheet(context, _filters, (newFilters) {
      setState(() => _filters = newFilters);
      _searchClubs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('clubs.discover'.tr()),
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map_outlined),
            tooltip: _isMapView ? 'clubs.view.list'.tr() : 'clubs.view.map'.tr(),
            onPressed: () => setState(() => _isMapView = !_isMapView),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildClubQuickFilters(this),
          Expanded(
            child: _isMapView ? _buildClubMap(this) : _buildClubList(this),
          ),
        ],
      ),
    );
  }
}
