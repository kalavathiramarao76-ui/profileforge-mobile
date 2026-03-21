import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorite.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/prompts.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/summary_card.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  final _profileController = TextEditingController();
  String _targetRole = AppConstants.targetRoles.first;
  bool _isLoading = false;
  bool _hasGenerated = false;

  late TabController _tabController;
  final _tones = ['Professional', 'Creative', 'Executive'];
  final Map<String, _SummaryData> _summaries = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _hasGenerated) {
        final tone = _tones[_tabController.index];
        if (!_summaries.containsKey(tone)) {
          _generateForTone(tone);
        }
      }
    });
  }

  @override
  void dispose() {
    _profileController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _generateAll() async {
    final text = _profileController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste your profile first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasGenerated = true;
      _summaries.clear();
    });

    await _generateForTone(_tones[0]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _generateForTone(String tone) async {
    try {
      final storage = context.read<StorageService>();
      final aiService = AIService(
        endpoint: storage.endpoint,
        model: storage.model,
      );

      final prompt = AIPrompts.generateSummary(
        _profileController.text.trim(),
        _targetRole,
        tone,
      );
      final raw = await aiService.chat(prompt);
      final jsonStr = AIService.extractJson(raw);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (mounted) {
        setState(() {
          _summaries[tone] = _SummaryData(
            summary: data['summary'] as String? ?? '',
            wordCount: (data['wordCount'] as num?)?.toInt() ?? 0,
            keyStrengths: (data['keyStrengths'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating $tone summary: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();

    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Summary Writer',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '3 tone variations for your profile',
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
              ),
              const SizedBox(height: 16),
              if (!_hasGenerated) ...[
                DropdownButtonFormField<String>(
                  value: _targetRole,
                  decoration: const InputDecoration(
                    labelText: 'Target Role',
                    prefixIcon: Icon(Icons.work_outline_rounded),
                  ),
                  items: AppConstants.targetRoles
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _targetRole = v!),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TextFormField(
                    controller: _profileController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Paste your LinkedIn profile text here...',
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const LoadingShimmer(lines: 4)
                else
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _generateAll,
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Generate Summaries'),
                    ),
                  ),
              ] else ...[
                TabBar(
                  controller: _tabController,
                  tabs: _tones.map((t) => Tab(text: t)).toList(),
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tones.map((tone) {
                      final data = _summaries[tone];
                      if (data == null) {
                        return const Center(child: LoadingShimmer(lines: 6));
                      }
                      final favId = 'summary_${tone}_${data.summary.hashCode}';
                      return SummaryCard(
                        summary: data.summary,
                        wordCount: data.wordCount,
                        keyStrengths: data.keyStrengths,
                        isFavorited: storage.isFavorited(favId),
                        onFavorite: () {
                          if (storage.isFavorited(favId)) {
                            storage.removeFavorite(favId);
                          } else {
                            storage.addFavorite(Favorite(
                              id: favId,
                              type: FavoriteType.summary,
                              content: data.summary,
                              label: '$tone Summary',
                              createdAt: DateTime.now(),
                            ));
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() {
                      _hasGenerated = false;
                      _summaries.clear();
                    }),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Start Over'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryData {
  final String summary;
  final int wordCount;
  final List<String> keyStrengths;

  _SummaryData({
    required this.summary,
    required this.wordCount,
    required this.keyStrengths,
  });
}
