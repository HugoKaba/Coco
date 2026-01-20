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

  @override
  Widget build(BuildContext context) {
    if (widget.people.isEmpty) return const SizedBox.shrink();

    final cardList = widget.people.toList();

    return Stack(
      clipBehavior: Clip.none,
      children: cardList.asMap().entries.map((entry) {
        final index = entry.key;
        final person = entry.value;
        final isTopCard = index == cardList.length - 1;

        if (!isTopCard) {
          return Positioned.fill(
            key: ValueKey('card_${person.id}'),
            child: ProfileCard(
              profile: person.toProfile(),
              onSwipeLeft: () {},
              onSwipeRight: () {},
            ),
          );
        }

        return Positioned.fill(
          key: ValueKey('top_card_${person.id}'),
          child: TopSwipeCard(
            profile: person.toProfile(),
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
