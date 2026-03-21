import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/analysis_result.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/prompts.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_shimmer.dart';
import 'results_screen.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final _profileController = TextEditingController();
  String _targetRole = AppConstants.targetRoles.first;
  bool _isLoading = false;

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    final text = _profileController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste your profile first')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final storage = context.read<StorageService>();
      final aiService = AIService(
        endpoint: storage.endpoint,
        model: storage.model,
      );

      final prompt = AIPrompts.analyzeProfile(text, _targetRole);
      final raw = await aiService.chat(prompt);
      final jsonStr = AIService.extractJson(raw);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final result = AnalysisResult.fromJson(data);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            result: result,
            profileText: text,
            targetRole: _targetRole,
          ),
        ),
      );
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
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analyze Profile',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Paste your LinkedIn profile to get an AI score',
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _profileController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Paste your LinkedIn profile text here...\n\nInclude: headline, summary, experience, skills, education',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading) ...[
                const LoadingShimmer(lines: 4),
              ] else
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _analyze,
                    icon: const Icon(Icons.auto_awesome_rounded),
                    label: const Text('Analyze Profile'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
