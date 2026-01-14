import 'package:flutter/material.dart';

class EventPlacesSlider extends StatelessWidget {
  final int maxPlaces;
  final ValueChanged<double> onChanged;

  const EventPlacesSlider({
    super.key,
    required this.maxPlaces,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nombre de places : $maxPlaces',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Slider(
          value: maxPlaces.toDouble(),
          min: 2,
          max: 50,
          divisions: 48,
          label: '$maxPlaces places',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
