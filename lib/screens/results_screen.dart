import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/analysis_result.dart';
import '../models/favorite.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/gradient_background.dart';
import '../widgets/score_ring.dart';
import '../widgets/section_card.dart';
import '../widgets/favorite_button.dart';

class ResultsScreen extends StatelessWidget {
  final AnalysisResult result;
  final String profileText;
  final String targetRole;

  const ResultsScreen({
    super.key,
    required this.result,
    required this.profileText,
    required this.targetRole,
  });

  String get _shareText {
    final buf = StringBuffer();
    buf.writeln('ProfileForge AI Analysis');
    buf.writeln('Overall Score: ${result.overallScore}/100');
    buf.writeln('Target Role: $targetRole');
    buf.writeln();
    for (final s in result.sections) {
      buf.writeln('${s.name}: ${s.score}/100');
    }
    buf.writeln();
    buf.writeln('Recommendations:');
    for (final r in result.recommendations) {
      buf.writeln('- $r');
    }
    return buf.toString();
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final favId = 'analysis_${result.overallScore}_${DateTime.now().millisecondsSinceEpoch}';

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                title: const Text('Analysis Results'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_rounded),
                    onPressed: () => Share.share(_shareText),
                  ),
                  FavoriteButton(
                    isFavorited: storage.isFavorited(favId),
                    onToggle: () {
                      if (storage.isFavorited(favId)) {
                        storage.removeFavorite(favId);
                      } else {
                        storage.addFavorite(Favorite(
                          id: favId,
                          type: FavoriteType.analysis,
                          content: _shareText,
                          label: 'Score: ${result.overallScore}/100 ($targetRole)',
                          createdAt: DateTime.now(),
                        ));
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Score ring
                    Center(child: ScoreRing(score: result.overallScore)),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _scoreLabel(result.overallScore),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.scoreColor(result.overallScore),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Section breakdown
                    const Text(
                      'Section Breakdown',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    ...result.sections.map((s) => SectionCard(section: s)),

                    const SizedBox(height: 20),
                    // Recommendations
                    const Text(
                      'Recommendations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    ...result.recommendations.asMap().entries.map(
                      (e) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  '${e.key + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                e.value,
                                style: const TextStyle(fontSize: 14, height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _scoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Average';
    if (score >= 20) return 'Needs Work';
    return 'Poor';
  }
}
