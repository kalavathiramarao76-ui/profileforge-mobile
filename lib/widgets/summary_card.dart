import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class SummaryCard extends StatelessWidget {
  final String summary;
  final int wordCount;
  final List<String> keyStrengths;
  final bool isFavorited;
  final VoidCallback onFavorite;

  const SummaryCard({
    super.key,
    required this.summary,
    required this.wordCount,
    required this.keyStrengths,
    required this.isFavorited,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              summary,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Chip(label: '$wordCount words'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: summary));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Summary copied')),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  isFavorited ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 24,
                  color: isFavorited ? AppColors.favoriteGold : null,
                ),
                onPressed: onFavorite,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Key Strengths',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...keyStrengths.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 16, color: AppColors.scoreExcellent),
                  const SizedBox(width: 8),
                  Expanded(child: Text(s, style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.accent),
      ),
    );
  }
}
