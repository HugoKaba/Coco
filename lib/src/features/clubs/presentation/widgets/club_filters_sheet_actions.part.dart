// ignore_for_file: invalid_use_of_protected_member
part of 'club_filters_sheet.dart';

Widget _buildClubFilterBottomBar(_ClubFiltersSheetState s) {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => s.setState(() {
              s._filters = const ClubFilterCriteria();
              s._isAroundMe = true;
              s._radiusKm = 10;
              s._ageRange = const RangeValues(18, 60);
              s._cityController.clear();
            }),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text('filters.reset'.tr()),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              var finalFilters = s._filters.copyWith(
                minAge: s._ageRange.start,
                maxAge: s._ageRange.end,
                isAroundMe: s._isAroundMe,
                radiusKm: s._radiusKm,
              );
              if (!s._isAroundMe && s._cityController.text.isNotEmpty) {
                final city = CityService.instance.findCityByName(
                  s._cityController.text,
                );
                if (city != null) {
                  finalFilters = finalFilters.copyWith(
                    cityName: city.nomStandard,
                    cityLat: city.latitude,
                    cityLng: city.longitude,
                  );
                }
              }
              s.widget.onApply(finalFilters);
              Navigator.pop(s.context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _ClubFiltersSheetState._accentColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'filters.apply'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
