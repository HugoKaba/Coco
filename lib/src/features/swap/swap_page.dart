import 'package:firebase_auth/firebase_auth.dart';
import 'package:coco/src/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/swipe_repository.dart';
import 'widgets/swipe_card_stack.dart';
import 'widgets/swipe_filter_sheet.dart';
import 'widgets/match_dialog.dart';
import 'widgets/empty_search_state.dart';
import '../filters/application/user_search_service.dart';
import '../filters/domain/models/person_entity.dart';

class SwapMatchPage extends ConsumerStatefulWidget {
  const SwapMatchPage({super.key});

  @override
  ConsumerState<SwapMatchPage> createState() => _SwapMatchPageState();
}

class _SwapMatchPageState extends ConsumerState<SwapMatchPage> {
  final SwipeRepository _swipeRepo = SwipeRepository();

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(userSearchProvider);

    return Scaffold(
      body: Stack(
        children: [
          searchState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : searchState.filteredUsers.isEmpty
              ? const EmptySearchState()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 90, 16, 0),
                  child: SwipeCardStack(
                    people: searchState.filteredUsers,
                    onSwipe: _handleSwipe,
                  ),
                ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: GestureDetector(
              onTap: () => _showFilters(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.brand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.brand,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SwipeFilterSheet(),
    );
  }

  Future<void> _handleSwipe(PersonEntity person, bool isRight) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'user_test_me';
    final isMatch = await _swipeRepo.recordSwipe(
      userId: userId,
      targetId: person.id,
      isLike: isRight,
    );
    if (isMatch && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MatchDialog(person: person),
      );
    }
  }
}
