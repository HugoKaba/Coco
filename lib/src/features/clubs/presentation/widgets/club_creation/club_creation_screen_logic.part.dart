// ignore_for_file: invalid_use_of_protected_member
part of 'package:coco/src/features/clubs/presentation/pages/club_creation_screen.dart';

extension _ClubCreationScreenLogic on _ClubCreationScreenState {
  Future<void> _loadCities() async {
    await CityService.instance.loadCities();
    if (mounted) setState(() => _citiesLoaded = CityService.instance.isLoaded);
  }

  void _nextStep() {
    final error = clubCreationStepError(
      step: _step,
      email: _email.text,
      password: _password.text,
      clubName: _clubName.text,
      activities: _activities,
      description: _description.text,
      city: _city.text,
      address: _address.text,
    );
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => _step++);
    _pageController.animateToPage(
      _step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousStep() {
    setState(() => _step--);
    _pageController.animateToPage(
      _step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);
    try {
      await submitClubCreation(
        ref: ref,
        subscriptionType: widget.subscriptionType,
        email: _email.text,
        password: _password.text,
        clubName: _clubName.text,
        activities: _activities,
        description: _description.text,
        address: _address.text,
        cityName: _city.text,
        phone: _phone.text,
      );
      if (mounted) context.go('/account');
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }
}
