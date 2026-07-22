import 'dart:io';

import 'package:coco/src/features/clubs/domain/models/subscription_tier.dart';
import 'package:coco/src/features/clubs/domain/models/club_sport_catalog.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_creation/club_creation_account_step.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_creation/club_creation_info_step.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_creation/club_creation_navigation_bar.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_creation/club_creation_review_step.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_creation/club_creation_submission.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_creation/club_creation_style.dart';
import 'package:coco/src/features/clubs/presentation/widgets/club_creation/club_creation_validators.dart';
import 'package:coco/src/core/city_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part '../widgets/club_creation/club_creation_screen_logic.part.dart';

class ClubCreationScreen extends ConsumerStatefulWidget {
  const ClubCreationScreen({super.key, required this.subscriptionType});
  final SubscriptionType subscriptionType;

  @override
  ConsumerState<ClubCreationScreen> createState() => _ClubCreationScreenState();
}

class _ClubCreationScreenState extends ConsumerState<ClubCreationScreen> {
  final _pageController = PageController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _clubName = TextEditingController();
  final _description = TextEditingController();
  final _facilities = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  int _step = 0;
  List<String> _activities = const [ClubSportCatalog.defaultSportKey];
  File? _clubImageFile;
  bool _citiesLoaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in [
      _email,
      _password,
      _clubName,
      _description,
      _facilities,
      _city,
      _address,
      _phone,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClubCreationStyle.background(context),
      appBar: AppBar(
        backgroundColor: ClubCreationStyle.background(context),
        title: Text('clubs.create.title'.tr()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_step + 1) / 3,
            backgroundColor: ClubCreationStyle.field(context),
            valueColor: const AlwaysStoppedAnimation<Color>(
              ClubCreationStyle.accent,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ClubCreationAccountStep(
            emailController: _email,
            passwordController: _password,
          ),
          ClubCreationInfoStep(
            clubNameController: _clubName,
            descriptionController: _description,
            facilitiesController: _facilities,
            onImageSelected: (file) => setState(() => _clubImageFile = file),
            cityController: _city,
            addressController: _address,
            phoneController: _phone,
            activities: _activities,
            onActivitiesChanged: (v) => setState(
              () => _activities = v.isEmpty
                  ? const [ClubSportCatalog.defaultSportKey]
                  : v,
            ),
            citiesLoaded: _citiesLoaded,
          ),
          ClubCreationReviewStep(
            email: _email.text,
            clubName: _clubName.text,
            activities: _activities,
            facilities: _facilities.text,
            city: _city.text,
            address: _address.text,
            phone: _phone.text,
            subscriptionType: widget.subscriptionType,
          ),
        ],
      ),
      bottomNavigationBar: ClubCreationNavigationBar(
        currentStep: _step,
        isLoading: _isLoading,
        onPrevious: _previousStep,
        onNextOrSubmit: _step < 2 ? _nextStep : _submitForm,
      ),
    );
  }
}
