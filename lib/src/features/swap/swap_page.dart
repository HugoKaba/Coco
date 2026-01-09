import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile {
  final String name;
  final String username;
  final String imageUrl;
  final List<IconData> sportIcons;
  final String description;
  final String activityFrequency;
  final Set<String> availableDays;

  Profile({
    required this.name,
    required this.username,
    required this.imageUrl,
    required this.sportIcons,
    required this.description,
    required this.activityFrequency,
    required this.availableDays,
  });
}

class SwipeMatchPage extends ConsumerStatefulWidget {
  const SwipeMatchPage({super.key});

  @override
  ConsumerState<SwipeMatchPage> createState() => _SwipeMatchPageState();
}

class _SwipeMatchPageState extends ConsumerState<SwipeMatchPage> {
  final List<Profile> _profiles = [
    Profile(
      name: 'Garance Turpin',
      username: '@aelysee',
      imageUrl:
          'https://images.pexels.com/photos/414029/pexels-photo-414029.jpeg',
      sportIcons: [Icons.fitness_center, Icons.hiking],
      description: '"c\'est pas acheter radin, c\'est acheter malin"',
      activityFrequency: '2 fois par mois',
      availableDays: {'Lun', 'Mer', 'Ven'},
    ),
    Profile(
      name: 'Lucas Martin',
      username: '@lucas_m',
      imageUrl:
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
      sportIcons: [Icons.sports_soccer, Icons.pool],
      description: 'Plutot sportif le soir apres le travail.',
      activityFrequency: '3 fois par semaine',
      availableDays: {'Mar', 'Jeu', 'Sam'},
    ),
  ];

  double _dragDx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _profiles.isEmpty
            ? Center(
                child: Text(
                  'Plus de profils',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: _profiles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final profile = entry.value;
                  final isTopCard = index == _profiles.length - 1;

                  if (!isTopCard) {
                    return _ProfileCard(
                      profile: profile,
                      onSwipeLeft: () {},
                      onSwipeRight: () {},
                    );
                  }

                  return _TopSwipeCard(
                    profile: profile,
                    dragDx: _dragDx,
                    onPanUpdate: (details) {
                      setState(() {
                        _dragDx += details.delta.dx;
                      });
                    },
                    onPanEnd: (details) {
                      final width = MediaQuery.of(context).size.width;
                      const thresholdRatio = 0.25;

                      if (_dragDx > width * thresholdRatio) {
                        _onSwipeRight(profile);
                      } else if (_dragDx < -width * thresholdRatio) {
                        _onSwipeLeft(profile);
                      }

                      setState(() {
                        _dragDx = 0;
                      });
                    },
                    onSwipeLeft: () => _onSwipeLeft(profile),
                    onSwipeRight: () => _onSwipeRight(profile),
                  );
                }).toList(),
              ),
      ),
    );
  }

  void _onSwipeRight(Profile profile) {
    debugPrint('LIKE sur ${profile.name}');
    setState(() {
      _profiles.removeLast();
    });
  }

  void _onSwipeLeft(Profile profile) {
    debugPrint('NOPE sur ${profile.name}');
    setState(() {
      _profiles.removeLast();
    });
  }
}

class _TopSwipeCard extends StatelessWidget {
  final Profile profile;
  final double dragDx;
  final void Function(DragUpdateDetails) onPanUpdate;
  final void Function(DragEndDetails) onPanEnd;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const _TopSwipeCard({
    required this.profile,
    required this.dragDx,
    required this.onPanUpdate,
    required this.onPanEnd,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    const maxAngle = 0.35;
    final normalized = (dragDx / (size.width * 0.5)).clamp(-1.0, 1.0);
    final angle = normalized * maxAngle;

    final offsetX = dragDx * 0.05;
    final offsetY = -dragDx.abs() * 0.02;

    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Transform.rotate(
          alignment: Alignment.bottomCenter,
          angle: angle,
          child: _ProfileCard(
            profile: profile,
            onSwipeLeft: onSwipeLeft,
            onSwipeRight: onSwipeRight,
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const _ProfileCard({
    required this.profile,
    required this.onSwipeLeft,
    required this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    const orangeColor = Color(0xFFD4913D);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Photo + Boutons swipe
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bouton X
                GestureDetector(
                  onTap: onSwipeLeft,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: orangeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Photo de profil ronde
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[800],
                    image: DecorationImage(
                      image: NetworkImage(profile.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Bouton V
                GestureDetector(
                  onTap: onSwipeRight,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: orangeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nom
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),

            // Username
            Text(
              profile.username,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // Icones de sports
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: profile.sportIcons.map((icon) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: orangeColor, width: 2),
                    ),
                    child: Icon(icon, color: orangeColor, size: 28),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Description label
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Description',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),

            // Description box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                profile.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),

            // Frequence d'activite label
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Frequence d'activite",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),

            // Frequence box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                profile.activityFrequency,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),

            // Preference journaliere
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preference journaliere',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),

            // Jours de la semaine
            _DaysRow(availableDays: profile.availableDays),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DaysRow extends StatelessWidget {
  final Set<String> availableDays;

  const _DaysRow({required this.availableDays});

  @override
  Widget build(BuildContext context) {
    final days = [
      ('Lun.', 'Lun'),
      ('Mar.', 'Mar'),
      ('Mer.', 'Mer'),
      ('Jeu.', 'Jeu'),
      ('Ven.', 'Ven'),
      ('Sam.', 'Sam'),
      ('Dim.', 'Dim'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isActive = availableDays.contains(day.$2);
        return Column(
          children: [
            Text(
              day.$1,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 2),
                color: isActive ? Colors.black87 : Colors.transparent,
              ),
              child: isActive
                  ? const Icon(Icons.circle, color: Colors.black87, size: 16)
                  : null,
            ),
          ],
        );
      }).toList(),
    );
  }
}
