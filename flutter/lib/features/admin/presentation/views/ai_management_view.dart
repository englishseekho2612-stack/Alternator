import 'package:flutter/material.dart';
import '../../domain/models/ai_config.dart';
import '../controllers/admin_controller.dart';

class AiManagementView extends StatefulWidget {
  final AdminController controller;
  final String adminUser;

  const AiManagementView({
    Key? key,
    required this.controller,
    required this.adminUser,
  }) : super(key: key);

  @override
  State<AiManagementView> createState() => _AiManagementViewState();
}

class _AiManagementViewState extends State<AiManagementView> {
  late TextEditingController _promptTemplateController;
  late TextEditingController _usageLimitController;
  bool _safetyFilters = true;
  String _personality = 'conversational';

  @override
  void initState() {
    super.initState();
    final config = widget.controller.aiConfig;
    _promptTemplateController = TextEditingController(text: config?.promptTemplate ?? '');
    _usageLimitController = TextEditingController(text: '${config?.dailyFreeUsageLimit ?? 3}');
    _safetyFilters = config?.safetyFiltersEnabled ?? true;
    _personality = config?.currentPersonality ?? 'conversational';
  }

  @override
  void dispose() {
    _promptTemplateController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanvi AI Core Tuning'),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sanvi Assistant Prompt & Behavioral Rules',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _promptTemplateController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter AI Instruction set...',
                    helperText: 'System level directives that govern Gemini model outputs.',
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Personality Presets',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPersonalityChoice('conversational', 'Conversational'),
                    const SizedBox(width: 8),
                    _buildPersonalityChoice('educational', 'Educational'),
                    const SizedBox(width: 8),
                    _buildPersonalityChoice('concise', 'Concise / Brief'),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Usage Caps & Safe Search Configurations',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Daily Free Interaction Caps'),
                  subtitle: const Text('Maximum free queries per user per day before prompting for Razorpay upgrades.'),
                  trailing: SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _usageLimitController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Filter Vulgar & Malicious Queries'),
                  subtitle: const Text('Pre-evaluate queries to block requests seeking illegal or harmful crack files.'),
                  value: _safetyFilters,
                  onChanged: (val) {
                    setState(() {
                      _safetyFilters = val;
                    });
                  },
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final updatedConfig = AIConfig(
                      promptTemplate: _promptTemplateController.text,
                      dailyFreeUsageLimit: int.tryParse(_usageLimitController.text) ?? 3,
                      safetyFiltersEnabled: _safetyFilters,
                      currentPersonality: _personality,
                      supportedLanguages: widget.controller.aiConfig?.supportedLanguages ?? ['en'],
                    );

                    final success = await widget.controller.updateAIConfiguration(updatedConfig, widget.adminUser);
                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('AI Tuning rules synchronized with model parameters.')),
                      );
                    }
                  },
                  child: const Text('Synchronize AI Rules'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalityChoice(String id, String label) {
    final active = _personality == id;
    return Expanded(
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: active,
        onSelected: (val) {
          if (val) {
            setState(() {
              _personality = id;
            });
          }
        },
      ),
    );
  }
}
