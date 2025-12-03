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

                    final card = _ProfileCard(profile: profile);

                    if (!isTopCard) {
                      // Les cartes du dessous : juste affichées
                      return card;
                    }

                    // Carte du dessus : Draggable (swipe)
                    return Draggable(
                      child: card,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: card,
                        ),
                      ),
                      childWhenDragging: const SizedBox.shrink(),
                      onDragEnd: (details) {
                        const threshold = 100; // seuil px
                        if (details.offset.dx > threshold) {
                          _onSwipeRight(profile);
                        } else if (details.offset.dx < -threshold) {
                          _onSwipeLeft(profile);
                        }
                      },
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }

  void _onSwipeRight(Profile profile) {
    // Ici tu pourras brancher un provider pour stocker les "likes"
    debugPrint('LIKE sur ${profile.name}');
    setState(() {
      _profiles.removeLast();
    });
  }

  void _onSwipeLeft(Profile profile) {
    // Ici tu pourras brancher un provider pour stocker les "dislikes"
    debugPrint('NOPE sur ${profile.name}');
    setState(() {
      _profiles.removeLast();
    });
  }
}

class _ProfileCard extends StatelessWidget {
  final Profile profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: isDark ? theme.colorScheme.surface : Colors.white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(12),
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
