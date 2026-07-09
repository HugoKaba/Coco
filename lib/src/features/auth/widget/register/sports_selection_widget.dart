import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../features/filters/application/seeder_constants.dart';
import '../../../../core/data/reference_tables.dart';

class SportsSelectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> selectedSports;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const SportsSelectionWidget({
    super.key,
    required this.selectedSports,
    required this.onChanged,
  });

  @override
  State<SportsSelectionWidget> createState() => _SportsSelectionWidgetState();
}

class _SportsSelectionWidgetState extends State<SportsSelectionWidget> {
  void _toggleSport(int sportId, List<int> levelIds) {
    final index = widget.selectedSports.indexWhere(
      (s) => s['sportId'] == sportId,
    );
    if (index >= 0) {
      setState(() {
        widget.selectedSports.removeAt(index);
      });
    } else {
      setState(() {
        widget.selectedSports.add({
          'sportId': sportId,
          'levelId': levelIds.first,
        });
      });
      _showLevelPicker(sportId, levelIds);
    }
    widget.onChanged(widget.selectedSports);
  }

  void _showLevelPicker(int sportId, List<int> levelIds) {
    final sportName = ReferenceTables.getSportName(sportId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${tr('common.level')} - ${tr(sportName)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...levelIds.map((levelId) {
                final levelKey = ReferenceTables.getLevelName(levelId);
                return ListTile(
                  title: Text(
                    tr(levelKey),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    final index = widget.selectedSports.indexWhere(
                      (s) => s['sportId'] == sportId,
                    );
                    if (index >= 0) {
                      setState(() {
                        widget.selectedSports[index]['levelId'] = levelId;
                      });
                      widget.onChanged(widget.selectedSports);
                    }
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SeederConstants.sports.map((sport) {
            final sportId = sport['id'] as int;
            final sportKey = sport['name'] as String;
            final levelIds = (sport['levels'] as List).cast<int>();

            final isSelected = widget.selectedSports.any(
              (s) => s['sportId'] == sportId,
            );

            String? currentLevelKey;
            if (isSelected) {
              final selectedEntry = widget.selectedSports.firstWhere(
                (s) => s['sportId'] == sportId,
              );
              final levelId = selectedEntry['levelId'] as int;
              currentLevelKey = ReferenceTables.getLevelName(levelId);
            }

            return FilterChip(
              label: Text(
                isSelected
                    ? '${tr(sportKey)} (${tr(currentLevelKey!)})'
                    : tr(sportKey),
              ),
              selected: isSelected,
              onSelected: (_) => _toggleSport(sportId, levelIds),
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              selectedColor: const Color(0xFFF2A33A),
              checkmarkColor: Colors.black,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.black
                    : Theme.of(context).colorScheme.onSurface,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
            );
          }).toList(),
        ),
      ],
    );
  }
}
