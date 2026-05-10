import 'package:flutter/material.dart';

enum SortType { dateDesc, dateAsc, amountDesc, amountAsc }

class SortButton extends StatelessWidget {
  final SortType currentSort;
  final ValueChanged<SortType> onSortChanged;

  const SortButton({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortType>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort transactions',
      onSelected: onSortChanged,
      itemBuilder: (context) => [
        _buildMenuItem(
          context,
          type: SortType.dateDesc,
          icon: Icons.arrow_downward,
          label: 'Date: Newest first',
        ),
        _buildMenuItem(
          context,
          type: SortType.dateAsc,
          icon: Icons.arrow_upward,
          label: 'Date: Oldest first',
        ),
        _buildMenuItem(
          context,
          type: SortType.amountDesc,
          icon: Icons.arrow_downward,
          label: 'Amount: Highest first',
        ),
        _buildMenuItem(
          context,
          type: SortType.amountAsc,
          icon: Icons.arrow_upward,
          label: 'Amount: Lowest first',
        ),
      ],
    );
  }

  PopupMenuItem<SortType> _buildMenuItem(
    BuildContext context, {
    required SortType type,
    required IconData icon,
    required String label,
  }) {
    final isActive = currentSort == type;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return PopupMenuItem(
      value: type,
      child: Row(
        children: [
          Icon(icon, size: 18, color: isActive ? primaryColor : null),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? primaryColor : null,
              fontWeight: isActive ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
