import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/models/club_entity.dart';
import '../../domain/models/club_filter_criteria.dart';
import '../../application/club_providers.dart';
import '../widgets/club_filters_sheet.dart';
import 'package:coco/src/core/city_service.dart';
import 'package:coco/src/core/providers.dart';
import 'club_detail_screen.dart';

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
    radiusKm: 50.0,
    isAroundMe: false,
  );
  List<ClubEntity> _clubs = [];
  bool _showOnlyMyClubs = false;
  bool _isLoading = false; // Restored

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _filters = _filters.copyWith(
          deviceLat: position.latitude,
          deviceLng: position.longitude,
        );
      });
      // Ensure cities are loaded for search
      if (!CityService.instance.isLoaded) {
        // Trigger load if possible or assume it's loaded by app init
      }
      _searchClubs();
    } catch (e) {
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
          final clubIds = memberships
              .where((m) => m.isActive)
              .map((m) => m.clubId)
              .toList();

          final clubs = <ClubEntity>[];
          final clubRepo = ref.read(clubRepositoryProvider);
          for (final id in clubIds) {
            final club = await clubRepo.getClubById(id);
            if (club != null) {
              clubs.add(club);
            }
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

      final searchService = ref.read(clubSearchServiceProvider);
      final results = await searchService.searchNearby(
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
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _showFilters() {
    showClubFiltersSheet(context, _filters, (newFilters) {
      setState(() {
        _filters = newFilters;
      });
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
          _buildQuickFilters(),
          Expanded(child: _buildClubsList()),
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // My Clubs Toggle
          FilterChip(
            label: const Text('Mes Clubs'),
            selected: _showOnlyMyClubs,
            onSelected: (bool selected) {
              setState(() {
                _showOnlyMyClubs = selected;
              });
              _searchClubs();
            },
            avatar: _showOnlyMyClubs ? const Icon(Icons.check, size: 16) : null,
          ),
          const SizedBox(width: 8),

          // Sport Chips
          ...['Tennis', 'Padel', 'Football', 'Badminton'].map((sport) {
            final isSelected = _filters.selectedSports.contains(sport);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(sport),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    final newSports = Set<String>.from(_filters.selectedSports);
                    if (selected) {
                      // Single selection behavior for simplicity as requested "sort by sport"
                      newSports.clear();
                      newSports.add(sport);
                    } else {
                      newSports.remove(sport);
                    }
                    _filters = _filters.copyWith(selectedSports: newSports);
                  });
                  _searchClubs();
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildClubsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_clubs.isEmpty) {
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
              onPressed: _showFilters,
              icon: const Icon(Icons.filter_list),
              label: Text('filters.title'.tr()),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _clubs.length,
      itemBuilder: (context, index) => _buildClubCard(_clubs[index]),
    );
  }

  Widget _buildClubCard(ClubEntity club) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ClubDetailScreen(clubId: club.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                      ),
                    )
                  else
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.sports,
                        color: Theme.of(context).colorScheme.primary,
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
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
