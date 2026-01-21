import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../navigation_button.dart';

class RegisterNavigationBottomBar extends StatelessWidget {
  final int step;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const RegisterNavigationBottomBar({
    super.key,
    required this.step,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NavigationButton(
          text: tr('register.previous_button'),
          alignment: Alignment.centerLeft,
          onPressed: onPrevious,
        ),
        NavigationButton(
          text: step == 2
              ? tr('register.validate_button')
              : tr('register.next_button'),
          alignment: Alignment.centerRight,
          onPressed: onNext,
        ),
      ],
    );
  }
}
