// ignore_for_file: invalid_use_of_protected_member
part of 'edit_profile_screen.dart';

/// Label au-dessus d'un champ, façon design system (comme la vue swipe).
Widget _labeled(BuildContext context, String label, Widget field) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: AppTextStyles.sm.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      field,
    ],
  );
}

/// Encart « Mon club » : indique si l'utilisateur est déjà membre d'un club et
/// lequel (adhésions actives). Masqué tant que l'uid n'est pas disponible ; en
/// cas d'erreur on n'affiche rien pour ne pas bloquer l'édition du profil.
Widget _buildClubMembershipSection(_EditProfileScreenState s) {
  final userId = s.ref.watch(userProfileProvider).value?.id;
  if (userId == null) return const SizedBox.shrink();

  final cs = Theme.of(s.context).colorScheme;
  final clubsAsync = s.ref.watch(userMemberClubsProvider(userId));

  Widget card(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(color: cs.outlineVariant),
    ),
    child: child,
  );

  return clubsAsync.when(
    loading: () => card(
      const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    ),
    error: (_, __) => const SizedBox.shrink(),
    data: (clubs) {
      if (clubs.isEmpty) {
        return card(
          Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: cs.onSurfaceVariant),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  tr('clubs.membership_none'),
                  style: AppTextStyles.sm.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        );
      }
      return card(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified, size: 20, color: AppColors.brand),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  tr('clubs.membership_member_of'),
                  style: AppTextStyles.sm.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...clubs.map(
              (club) => Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  children: [
                    Icon(Icons.chevron_right, size: 16, color: cs.onSurface),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        club.name,
                        style: AppTextStyles.md.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Initiales de secours (Prénom + Nom) quand aucune photo n'est disponible.
String _profileInitials(UserProfile? p) {
  if (p == null) return '';
  final f = p.firstName.isNotEmpty ? p.firstName[0] : '';
  final l = p.lastName.isNotEmpty ? p.lastName[0] : '';
  return (f + l).toUpperCase();
}

/// Aperçu circulaire de la photo de profil (URL, ex. avatar Google). Retombe sur
/// les initiales — puis une icône — si la photo est absente ou ne charge pas.
Widget _buildPhotoPreview(_EditProfileScreenState s) {
  final profile = s.ref.watch(userProfileProvider).value;
  final photoUrl = profile?.profilePhoto ?? '';
  final initials = _profileInitials(profile);
  final cs = Theme.of(s.context).colorScheme;

  Widget fallback() => Container(
    color: cs.surfaceContainerHighest,
    alignment: Alignment.center,
    child: initials.isNotEmpty
        ? Text(
            initials,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: cs.onSurfaceVariant,
            ),
          )
        : Icon(Icons.person, size: 44, color: cs.onSurfaceVariant),
  );

  return Center(
    child: Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.brand, width: 2),
      ),
      child: ClipOval(
        child: photoUrl.isEmpty
            ? fallback()
            : Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback(),
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
              ),
      ),
    ),
  );
}

Widget _buildProfileForm(_EditProfileScreenState s) {
  return SingleChildScrollView(
    // Padding bas élargi : la tabbar flottante recouvre le bas de l'écran
    // (page poussée sur la branche), il faut pouvoir scroller le dernier champ
    // au-dessus d'elle.
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.lg,
      AppSpacing.lg + kGlassBottomBarClearance,
    ),
    child: Form(
      key: s._formKey,
      child: Column(
        children: [
          _buildPhotoPreview(s),
          const SizedBox(height: AppSpacing.lg),
          _buildClubMembershipSection(s),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _labeled(
                  s.context,
                  'profile.first_name'.tr(),
                  AppTextField(
                    controller: s._firstNameController,
                    validator: (v) => v!.isEmpty ? 'profile.required'.tr() : null,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _labeled(
                  s.context,
                  'profile.last_name'.tr(),
                  AppTextField(
                    controller: s._lastNameController,
                    validator: (v) => v!.isEmpty ? 'profile.required'.tr() : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _labeled(
                  s.context,
                  'profile.age'.tr(),
                  AppTextField(
                    controller: s._ageController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: _labeled(
                  s.context,
                  'profile.gender'.tr(),
                  DropdownButtonFormField<String>(
                    initialValue: s._gender,
                    decoration: appInputDecoration(s.context),
                    items: [
                      DropdownMenuItem(
                        value: 'M',
                        child: Text('profile.gender_male'.tr()),
                      ),
                      DropdownMenuItem(
                        value: 'F',
                        child: Text('profile.gender_female'.tr()),
                      ),
                    ],
                    onChanged: (v) => s.setState(() => s._gender = v!),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _labeled(
            s.context,
            'profile.city'.tr(),
            AppTextField(controller: s._cityController),
          ),
          const SizedBox(height: AppSpacing.lg),
          _labeled(
            s.context,
            'profile.bio'.tr(),
            AppTextField(controller: s._bioController, maxLines: 4),
          ),
          const SizedBox(height: AppSpacing.lg),
          _labeled(
            s.context,
            'profile.sports_goal'.tr(),
            DropdownButtonFormField<String>(
              initialValue:
                  [
                    'Loisir',
                    'Compétition',
                    'Perte de poids',
                  ].contains(s._sportsGoal)
                  ? s._sportsGoal
                  : 'Loisir',
              decoration: appInputDecoration(s.context),
              items: [
                DropdownMenuItem(
                  value: 'Loisir',
                  child: Text('profile.goal_leisure'.tr()),
                ),
                DropdownMenuItem(
                  value: 'Compétition',
                  child: Text('profile.goal_competition'.tr()),
                ),
                DropdownMenuItem(
                  value: 'Perte de poids',
                  child: Text('profile.goal_weight_loss'.tr()),
                ),
              ],
              onChanged: (v) => s.setState(() => s._sportsGoal = v!),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _labeled(
            s.context,
            'profile.training_frequency'.tr(),
            InputDecorator(
              decoration: appInputDecoration(s.context),
              child: Column(
                children: [
                  Slider(
                    value: s._trainingFrequency.toDouble(),
                    min: 0,
                    max: 7,
                    divisions: 7,
                    label: s._trainingFrequency.toString(),
                    onChanged: (v) =>
                        s.setState(() => s._trainingFrequency = v.toInt()),
                  ),
                  Text(tr('profile.times_per_week', namedArgs: {'count': '${s._trainingFrequency}'})),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
