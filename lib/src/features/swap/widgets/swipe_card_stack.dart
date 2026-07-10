import 'package:flutter/material.dart';
import '../../filters/domain/models/person_entity.dart';
import '../widgets/profile_card.dart';
import '../widgets/top_swipe_card.dart';
import 'person_mapper.dart';

class SwipeCardStack extends StatefulWidget {
  final List<PersonEntity> people;
  final Function(PersonEntity, bool) onSwipe;

  const SwipeCardStack({
    super.key,
    required this.people,
    required this.onSwipe,
  });

  @override
  State<SwipeCardStack> createState() => _SwipeCardStackState();
}

class _SwipeCardStackState extends State<SwipeCardStack>
    with SingleTickerProviderStateMixin {
  double _dragDx = 0;

  late AnimationController _animationController;
  late Animation<double> _curvedAnimation;

  double _animationStartDx = 0;
  double _animationTargetDx = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _curvedAnimation.addListener(() {
      if (_animationController.isAnimating) {
        setState(() {
          _dragDx =
              _animationStartDx +
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

  /// Nombre de cartes réellement rendues au sommet de la pile. Les cartes en
  /// dessous ont un fond opaque et se recouvrent totalement : en rendre plus
  /// serait invisible ET coûteux (chaque carte charge une image réseau et est
  /// reconstruite à chaque frame d'animation via setState). On se limite donc
  /// aux quelques cartes du dessus, quelle que soit la taille de la liste.
  static const int _kVisibleCards = 3;

  @override
  Widget build(BuildContext context) {
    final people = widget.people;
    if (people.isEmpty) return const SizedBox.shrink();

    final total = people.length;
    // Fenêtre des dernières cartes (la carte du dessus est `people.last`).
    final firstVisible = (total - _kVisibleCards).clamp(0, total);

    final cards = <Widget>[];
    // Ordre croissant : la carte du dessus est ajoutée en dernier, donc peinte
    // par-dessus les autres.
    for (var index = firstVisible; index < total; index++) {
      final person = people[index];
      final isTopCard = index == total - 1;

      if (!isTopCard) {
        cards.add(
          Positioned.fill(
            key: ValueKey('card_${person.id}'),
            child: ProfileCard(
              profile: person.toProfile(),
              onSwipeLeft: () {},
              onSwipeRight: () {},
            ),
          ),
        );
      } else {
        cards.add(
          Positioned.fill(
            key: ValueKey('top_card_${person.id}'),
            child: TopSwipeCard(
              profile: person.toProfile(),
              dragDx: _dragDx,
              onPanUpdate: _handlePanUpdate,
              onPanEnd: _handlePanEnd,
              onSwipeLeft: () => _triggerSwipe(isRight: false),
              onSwipeRight: () => _triggerSwipe(isRight: true),
            ),
          ),
        );
      }
    }

    return Stack(clipBehavior: Clip.none, children: cards);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_animationController.isAnimating) return;
    setState(() => _dragDx += details.delta.dx);
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_animationController.isAnimating) return;

    final width = MediaQuery.of(context).size.width;
    final threshold = width * 0.3;

    if (_dragDx > threshold) {
      _triggerSwipe(isRight: true);
    } else if (_dragDx < -threshold) {
      _triggerSwipe(isRight: false);
    } else {
      _resetPosition();
    }
  }

  void _resetPosition() {
    _animationStartDx = _dragDx;
    _animationTargetDx = 0;
    _animationController.forward(from: 0);
  }

  void _triggerSwipe({required bool isRight}) {
    if (_animationController.isAnimating) return;

    final width = MediaQuery.of(context).size.width;
    _animationStartDx = _dragDx;
    _animationTargetDx = isRight ? width * 1.5 : -width * 1.5;

    final swipedPerson = widget.people.last;

    _animationController.forward(from: 0).then((_) {
      _dragDx = 0;
      _animationController.reset();
      widget.onSwipe(swipedPerson, isRight);
    });
  }
}
