import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/headline.dart';
import '../models/favorite.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/prompts.dart';
import '../widgets/gradient_background.dart';
import '../widgets/headline_card.dart';
import '../widgets/loading_shimmer.dart';

class HeadlinesScreen extends StatefulWidget {
  const HeadlinesScreen({super.key});

  @override
  State<HeadlinesScreen> createState() => _HeadlinesScreenState();
}

class _HeadlinesScreenState extends State<HeadlinesScreen> {
  final _profileController = TextEditingController();
  String _targetRole = AppConstants.targetRoles.first;
  bool _isLoading = false;
  List<Headline> _headlines = [];

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final text = _profileController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste your profile first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _headlines = [];
    });

    try {
      final storage = context.read<StorageService>();
      final aiService = AIService(
        endpoint: storage.endpoint,
        model: storage.model,
      );

      final prompt = AIPrompts.generateHeadlines(text, _targetRole);
      final raw = await aiService.chat(prompt);
      final jsonStr = AIService.extractJson(raw);
      final data = jsonDecode(jsonStr) as List<dynamic>;
      setState(() {
        _headlines = data
            .map((e) => Headline.fromJson(e as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                'Headline Generator',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Generate 10 optimized headlines',
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
              ),
              const SizedBox(height: 16),
              if (_headlines.isEmpty) ...[
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
                  const LoadingShimmer(lines: 6)
                else
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _generate,
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Generate Headlines'),
                    ),
                  ),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: _headlines.length,
                    itemBuilder: (context, index) {
                      final h = _headlines[index];
                      final favId = 'headline_${h.text.hashCode}';
                      return HeadlineCard(
                        headline: h,
                        index: index,
                        isFavorited: storage.isFavorited(favId),
                        onFavorite: () {
                          if (storage.isFavorited(favId)) {
                            storage.removeFavorite(favId);
                          } else {
                            storage.addFavorite(Favorite(
                              id: favId,
                              type: FavoriteType.headline,
                              content: h.text,
                              label: h.style,
                              createdAt: DateTime.now(),
                            ));
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _headlines = []),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Generate New'),
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
