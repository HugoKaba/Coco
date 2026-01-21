import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/city_service.dart';
import 'input_wrapper.dart';

class CityAutocomplete extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController zipController;
  final bool citiesLoaded;
  final Function(bool) setCitiesLoaded;
  final Color fieldColor;
  final Color innerShadow;

  const CityAutocomplete({
    super.key,
    required this.cityController,
    required this.zipController,
    required this.citiesLoaded,
    required this.setCitiesLoaded,
    required this.fieldColor,
    required this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    if (!citiesLoaded) {
      CityService.instance.loadCities().then((_) {
        setCitiesLoaded(CityService.instance.isLoaded);
      });
    }

    return InputWrapper(
      borderRadius: 20,
      fieldColor: fieldColor,
      innerShadow: innerShadow,
      child: Autocomplete<CityData>(
        key: ValueKey('autocomplete_$citiesLoaded'),
        displayStringForOption: (CityData option) => option.nomStandard,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (!CityService.instance.isLoaded) {
            return const Iterable<CityData>.empty();
          }
          final query = textEditingValue.text.trim();
          if (query.isEmpty) {
            return const Iterable<CityData>.empty();
          }
          return CityService.instance.searchCities(query);
        },
        onSelected: (CityData selection) {
          cityController.text = selection.nomStandard;
          zipController.text = selection.zipCodes.isNotEmpty
              ? selection.zipCodes.first
              : '';
        },
        fieldViewBuilder:
            (context, fieldTextEditingController, focusNode, onFieldSubmitted) {
              if (fieldTextEditingController.text.isEmpty &&
                  cityController.text.isNotEmpty) {
                fieldTextEditingController.text = cityController.text;
              }
              return TextFormField(
                controller: fieldTextEditingController,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: tr('register.city'),
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) => cityController.text = value,
                onFieldSubmitted: (value) {
                  onFieldSubmitted();
                  final city = CityService.instance.findCityByName(value);
                  if (city != null && city.zipCodes.isNotEmpty) {
                    zipController.text = city.zipCodes.first;
                  }
                },
              );
            },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(12),
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.nomStandard,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            if (option.zipCodes.isNotEmpty)
                              Text(
                                option.zipCodes.join(', '),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                          ],
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
}
