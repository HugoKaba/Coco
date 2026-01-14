import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/profile.dart';
import 'widgets/profile_card.dart';
import 'widgets/top_swipe_card.dart';

class SwipeMatchPage extends ConsumerStatefulWidget {
  const SwipeMatchPage({super.key});

  @override
  ConsumerState<SwipeMatchPage> createState() => _SwipeMatchPageState();
}

class _SwipeMatchPageState extends ConsumerState<SwipeMatchPage>
    with SingleTickerProviderStateMixin {
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
  double _rawDragDx = 0;
  bool _isDragActive = false;
  static const double _deadZone = 30.0;

  double _animationStartDx = 0;
  double _animationTargetDx = 0;
  late AnimationController _animationController;
  late Animation<double> _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _curvedAnimation.addListener(() {
      if (_animationController.isAnimating) {
        setState(() {
          _dragDx = _animationStartDx +
              (_animationTargetDx - _animationStartDx) * _curvedAnimation.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _profiles.isEmpty ? _buildEmptyState() : _buildCardStack(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Plus de profils',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildCardStack() {
    return Stack(
      children: _profiles.asMap().entries.map((entry) {
        final index = entry.key;
        final profile = entry.value;
        final isTopCard = index == _profiles.length - 1;

        if (!isTopCard) {
          return Positioned.fill(
            child: ProfileCard(
              profile: profile,
              onSwipeLeft: () {},
              onSwipeRight: () {},
            ),
          );
        }

        return Positioned.fill(
          child: TopSwipeCard(
            profile: profile,
            dragDx: _dragDx,
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            onSwipeLeft: () => _triggerSwipe(isRight: false),
            onSwipeRight: () => _triggerSwipe(isRight: true),
          ),
        );
      }).toList(),
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_animationController.isAnimating) return;

    _rawDragDx += details.delta.dx;

    if (!_isDragActive && _rawDragDx.abs() > _deadZone) {
      _isDragActive = true;
      _dragDx = 0;
    }

    if (_isDragActive) {
      setState(() {
        _dragDx += details.delta.dx;
      });
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_animationController.isAnimating) return;

    _rawDragDx = 0;
    _isDragActive = false;

    final width = MediaQuery.of(context).size.width;
    const thresholdRatio = 0.25;

    if (_dragDx > width * thresholdRatio) {
      _triggerSwipe(isRight: true);
    } else if (_dragDx < -width * thresholdRatio) {
      _triggerSwipe(isRight: false);
    } else {
      setState(() {
        _dragDx = 0;
      });
    }
  }

  void _triggerSwipe({required bool isRight}) {
    if (_animationController.isAnimating) return;

    final width = MediaQuery.of(context).size.width;
    _animationStartDx = _dragDx;
    _animationTargetDx = isRight ? width * 0.5 : -width * 0.5;

    _animationController.forward(from: 0).then((_) {
      final profile = _profiles.last;
      debugPrint('${isRight ? "LIKE" : "NOPE"} sur ${profile.name}');
      setState(() {
        _profiles.removeLast();
        _dragDx = 0;
      });
      _animationController.reset();
    });
  }
}
