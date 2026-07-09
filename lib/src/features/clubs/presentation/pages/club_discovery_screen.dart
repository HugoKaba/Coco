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

  /// Récupère la position de l'appareil en gérant permission + timeout.
  /// Renvoie `null` si le service est coupé, la permission refusée, ou si le GPS
  /// ne répond pas dans le délai (fréquent sur simulateur) — ne bloque jamais.
  Future<Position?> _getDevicePosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 8));
    } catch (_) {
      return null;
    }
  }

  /// Pré-charge silencieusement la position au démarrage (sans snackbar pour ne
  /// pas polluer l'ouverture). Le fallback ville reste actif si indisponible.
  Future<void> _initializeLocation() async {
    final position = await _getDevicePosition();
    if (position == null || !mounted) return;
    setState(
      () => _filters = _filters.copyWith(
        deviceLat: position.latitude,
        deviceLng: position.longitude,
      ),
    );
    if (_filters.isAroundMe) _searchClubs();
  }

  /// Bouton « me localiser » : récupère la position, passe en mode « autour de
  /// moi », recentre la carte et relance la recherche. Feedback si indisponible.
  Future<void> _locateMe() async {
    final position = await _getDevicePosition();
    if (!mounted) return;
    if (position == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('errors.location_error'.tr())));
      return;
    }
    setState(
      () => _filters = _filters.copyWith(
        deviceLat: position.latitude,
        deviceLng: position.longitude,
        isAroundMe: true,
      ),
    );
    _mapController.move(LatLng(position.latitude, position.longitude), 13);
    _searchClubs();
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
