import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Profile {
  final String name;
  final int age;
  final String imageUrl;
  final List<String> practicedSports; // 2 sports max pour l'affichage
  final String desiredSport;
  final String description;
  final Set<String> availableDays; // ex : {'Lun', 'Mer', 'Ven'}

  Profile({
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.practicedSports,
    required this.desiredSport,
    required this.description,
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
      name: 'Emma',
      age: 24,
      imageUrl:
          'https://images.pexels.com/photos/414029/pexels-photo-414029.jpeg',
      practicedSports: ['Course', 'Yoga'],
      desiredSport: 'Muscu',
      description:
          'Je cherche quelqu’un pour aller courir 2-3x par semaine et se motiver mutuellement 💪',
      availableDays: {'Lun', 'Mer', 'Ven'},
    ),
    Profile(
      name: 'Lucas',
      age: 27,
      imageUrl:
          'https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg',
      practicedSports: ['Foot', 'Natation'],
      desiredSport: 'Trail',
      description:
          'Plutôt sportif le soir après le travail. Partant pour découvrir de nouveaux sports.',
      availableDays: {'Mar', 'Jeu', 'Sam'},
    ),
  ];

  double _dragDx = 0; // déplacement horizontal courant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tu pourras remplacer par tr('swipe.title') si tu ajoutes la clé
        title: const Text('SportLinker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _profiles.isEmpty
              ? Text(
                  'Plus de profils à afficher',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              : Stack(
                  alignment: Alignment.center,
                  children: _profiles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final profile = entry.value;
                    final isTopCard = index == _profiles.length - 1;

                    if (!isTopCard) {
                      // cartes du dessous : juste affichées
                      return _ProfileCard(profile: profile);
                    }

                    // carte du dessus : pivotée / swipable
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
                        const thresholdRatio = 0.25; // 25% de la largeur écran

                        if (_dragDx > width * thresholdRatio) {
                          _onSwipeRight(profile);
                        } else if (_dragDx < -width * thresholdRatio) {
                          _onSwipeLeft(profile);
                        }

                        // dans tous les cas, on recentre la carte visuellement
                        setState(() {
                          _dragDx = 0;
                        });
                      },
                    );
                  }).toList(),
                ),
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

  const _TopSwipeCard({
    super.key,
    required this.profile,
    required this.dragDx,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // angle max ~ 20°
    const maxAngle = 0.35; // radians
    final normalized = (dragDx / (size.width * 0.5)).clamp(-1.0, 1.0);
    final angle = normalized * maxAngle;

    // petite translation pour accompagner la rotation
    final offsetX = dragDx * 0.05;
    final offsetY = -dragDx.abs() * 0.02;

    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Transform.rotate(
          alignment: Alignment.bottomCenter, // pivot en bas
          angle: angle,
          child: _ProfileCard(profile: profile),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Profile profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.75, // card assez grande mais scrollable
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: isDark ? theme.colorScheme.surface : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // PHOTO
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Image.network(profile.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 12),

                // NOM / ÂGE
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${profile.name}, ${profile.age}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 3 CASES : 2 sports pratiqués + 1 souhaité
                Row(
                  children: [
                    Expanded(
                      child: _InfoBox(
                        label: 'Sport 1',
                        value: profile.practicedSports.isNotEmpty
                            ? profile.practicedSports[0]
                            : '-',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoBox(
                        label: 'Sport 2',
                        value: profile.practicedSports.length > 1
                            ? profile.practicedSports[1]
                            : '-',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _InfoBox(
                        label: 'Souhaité',
                        value: profile.desiredSport,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // DESCRIPTION
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    profile.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 12),

                // JOURS DISPONIBLES
                _DaysCard(availableDays: profile.availableDays),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DaysCard extends StatelessWidget {
  final Set<String> availableDays; // ex: {'Lun', 'Mer'}

  const _DaysCard({required this.availableDays});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jours pour faire du sport',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: days.map((day) {
              final isActive = availableDays.contains(day);
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isActive
                      ? theme.colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: isActive
                        ? theme.colorScheme.primary
                        : Colors.grey.shade400,
                  ),
                ),
                child: Text(
                  day,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
