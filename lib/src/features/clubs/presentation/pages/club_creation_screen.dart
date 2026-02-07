import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:coco/src/core/city_service.dart';
import '../../domain/models/club_entity.dart';
import '../../domain/models/opening_hours.dart';
import '../../domain/models/subscription_tier.dart';
import '../../application/club_providers.dart';
import '../../../auth/widget/dark_text_field.dart';
import '../../../auth/widget/input_label.dart';

class ClubCreationScreen extends ConsumerStatefulWidget {
  final SubscriptionType subscriptionType;

  const ClubCreationScreen({super.key, required this.subscriptionType});

  @override
  ConsumerState<ClubCreationScreen> createState() => _ClubCreationScreenState();
}

class _ClubCreationScreenState extends ConsumerState<ClubCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;

  static const Color _accentColor = Color(0xFFCD8232);
  static const Color _bgColor = Color(0xFF121212);
  static const Color _fieldColor = Color(0xFF1F1F1F);
  static final Color _inputInnerShadow = Colors.black.withValues(alpha: 0.55);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _sportType = 'tennis';
  bool _citiesLoaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _clubNameController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCities() async {
    await CityService.instance.loadCities();
    if (!mounted) return;
    setState(() => _citiesLoaded = CityService.instance.isLoaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        foregroundColor: Colors.white,
        title: const Text('Créer un Club'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: _fieldColor,
            valueColor: const AlwaysStoppedAnimation<Color>(_accentColor),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildAccountStep(),
            _buildClubInfoStep(),
            _buildReviewStep(),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigation(),
    );
  }

  Widget _buildAccountStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Compte Professionnel',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Créez votre compte pour gérer votre club',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 32),
          InputLabel(label: 'Email'),
          DarkTextField(
            controller: _emailController,
            hintText: 'votre@email.com',
            keyboardType: TextInputType.emailAddress,
            fieldColor: _fieldColor,
            innerShadow: _inputInnerShadow,
          ),
          const SizedBox(height: 20),
          InputLabel(label: 'Mot de passe'),
          DarkTextField(
            controller: _passwordController,
            hintText: 'Minimum 6 caractères',
            obscureText: true,
            fieldColor: _fieldColor,
            innerShadow: _inputInnerShadow,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _fieldColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: _accentColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Vous pourrez vous reconnecter avec ces identifiants',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations du Club',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          InputLabel(label: 'Nom du club'),
          DarkTextField(
            controller: _clubNameController,
            hintText: 'Ex: Tennis Club Paris',
            fieldColor: _fieldColor,
            innerShadow: _inputInnerShadow,
          ),
          const SizedBox(height: 20),
          InputLabel(label: 'Sport'),
          _buildSportDropdown(),
          const SizedBox(height: 20),
          InputLabel(label: 'Description'),
          DarkTextField(
            controller: _descriptionController,
            hintText: 'Décrivez votre club...',
            maxLines: 3,
            fieldColor: _fieldColor,
            innerShadow: _inputInnerShadow,
          ),
          const SizedBox(height: 20),
          InputLabel(label: 'Ville'),
          _buildCityAutocomplete(),
          const SizedBox(height: 20),
          InputLabel(label: 'Adresse'),
          DarkTextField(
            controller: _addressController,
            hintText: '123 Rue Example',
            fieldColor: _fieldColor,
            innerShadow: _inputInnerShadow,
          ),
          const SizedBox(height: 20),
          InputLabel(label: 'Téléphone (optionnel)'),
          DarkTextField(
            controller: _phoneController,
            hintText: '+33 6 12 34 56 78',
            keyboardType: TextInputType.phone,
            fieldColor: _fieldColor,
            innerShadow: _inputInnerShadow,
          ),
        ],
      ),
    );
  }

  Widget _buildSportDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _inputInnerShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: -4,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _sportType,
        dropdownColor: _fieldColor,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
        style: const TextStyle(color: Colors.white),
        items: ['tennis', 'gym', 'football', 'athletics']
            .map(
              (s) => DropdownMenuItem(
                value: s,
                child: Text(s[0].toUpperCase() + s.substring(1)),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _sportType = v!),
      ),
    );
  }

  Widget _buildCityAutocomplete() {
    return Container(
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _inputInnerShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: -4,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Autocomplete<CityData>(
        displayStringForOption: (city) => city.nomStandard,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (!_citiesLoaded) return const Iterable<CityData>.empty();
          final query = textEditingValue.text.trim();
          if (query.isEmpty) return const Iterable<CityData>.empty();
          return CityService.instance.searchCities(query);
        },
        onSelected: (CityData city) {
          _cityController.text = city.nomStandard;
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          if (controller.text.isEmpty && _cityController.text.isNotEmpty) {
            controller.text = _cityController.text;
          }
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Rechercher une ville...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
            ),
            onChanged: (value) => _cityController.text = value,
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: _fieldColor,
              borderRadius: BorderRadius.circular(12),
              elevation: 8,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final city = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(city),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        child: Text(
                          city.nomStandard,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vérification',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          _buildReviewSection('Compte', [
            _buildReviewItem('Email', _emailController.text),
            _buildReviewItem('Mot de passe', '••••••••'),
          ]),
          const SizedBox(height: 16),
          _buildReviewSection('Club', [
            _buildReviewItem('Nom', _clubNameController.text),
            _buildReviewItem('Sport', _sportType),
            _buildReviewItem('Ville', _cityController.text),
            _buildReviewItem('Adresse', _addressController.text),
            if (_phoneController.text.isNotEmpty)
              _buildReviewItem('Téléphone', _phoneController.text),
          ]),
          const SizedBox(height: 16),
          _buildReviewSection('Abonnement', [
            _buildReviewItem(
              'Formule',
              widget.subscriptionType == SubscriptionType.monthly
                  ? 'Mensuel'
                  : 'Annuel',
            ),
            _buildReviewItem(
              'Prix',
              widget.subscriptionType == SubscriptionType.monthly
                  ? '29.99€/mois'
                  : '299.99€/an',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String title, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _fieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...items,
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Non renseigné' : value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _previousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Précédent'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : (_currentStep < 2 ? _nextStep : _submitForm),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  disabledBackgroundColor: _accentColor.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        _currentStep < 2 ? 'Suivant' : 'Créer mon club',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_emailController.text.isEmpty ||
          _passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email et mot de passe requis (6+ caractères)'),
          ),
        );
        return;
      }
    } else if (_currentStep == 1) {
      if (_clubNameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _cityController.text.isEmpty ||
          _addressController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez remplir tous les champs requis'),
          ),
        );
        return;
      }
    }

    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousStep() {
    setState(() => _currentStep--);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      final userId = userCredential.user?.uid;
      if (userId == null) throw Exception('User creation failed');

      final city = CityService.instance.findCityByName(_cityController.text);
      final lat = city?.latitude ?? 0.0;
      final lng = city?.longitude ?? 0.0;

      final now = DateTime.now();
      final expiresAt = widget.subscriptionType == SubscriptionType.monthly
          ? now.add(const Duration(days: 30))
          : now.add(const Duration(days: 365));

      final club = ClubEntity(
        id: '',
        ownerId: userId,
        name: _clubNameController.text,
        sportType: _sportType,
        description: _descriptionController.text,
        address: _addressController.text,
        city: _cityController.text,
        lat: lat,
        lng: lng,
        photoUrls: [],
        weeklyHours: {
          'Monday': OpeningHours.standard(),
          'Tuesday': OpeningHours.standard(),
          'Wednesday': OpeningHours.standard(),
          'Thursday': OpeningHours.standard(),
          'Friday': OpeningHours.standard(),
          'Saturday': OpeningHours.standard(),
          'Sunday': OpeningHours.closed(),
        },
        maxCapacity: 50,
        createdAt: now,
        subscriptionType: widget.subscriptionType,
        subscriptionExpiresAt: expiresAt,
        isActive: true,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      );

      final clubRepo = ref.read(clubRepositoryProvider);
      await clubRepo.createClub(club);

      if (mounted) {
        context.go('/account');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }
}
