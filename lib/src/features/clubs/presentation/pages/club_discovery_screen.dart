import 'package:coco/src/core/city_service.dart';
import 'package:coco/src/core/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/club_providers.dart';
import '../../domain/models/club_entity.dart';
import '../../domain/models/club_filter_criteria.dart';
import '../widgets/club_filters_sheet.dart';
import 'club_detail_screen.dart';

part 'club_discovery_screen_ui.part.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeLocation();
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
      if (!CityService.instance.isLoaded) {}
      _searchClubs();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('errors.location_error'.tr())));
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

      if (_filters.searchLat == null || _filters.searchLng == null) {
        setState(() => _isLoading = false);
        return;
      }

      final results = await ref
          .read(clubSearchServiceProvider)
          .searchNearby(
            lat: _filters.searchLat!,
            lng: _filters.searchLng!,
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
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildClubQuickFilters(this),
          Expanded(child: _buildClubList(this)),
        ],
      ),
    );
  }
}
