import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/behavior_controller.dart';
import '../controller/clinical_sign_controller.dart';

final selectedSignsProvider = StateProvider<List<int>>((ref) => []);
final selectedBehaviorsProvider = StateProvider<List<int>>((ref) => []);

// todo get location longitude and latitude
// todo upload images for a report

class CreateReportScreen extends ConsumerStatefulWidget {
  const CreateReportScreen({super.key});

  @override
  ConsumerState<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends ConsumerState<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _otherSignsController = TextEditingController();
  final _otherBehaviorController = TextEditingController();
  final _mortalityController = TextEditingController();
  String? selectedLevel;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch data from your providers
    final signsAsync = ref.watch(clinicalSignProvider);
    final behaviorsAsync = ref.watch(behaviorProvider);

    // Watch current selections
    final selectedSigns = ref.watch(selectedSignsProvider);
    final selectedBehaviors = ref.watch(selectedBehaviorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Surveillance",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Basic Information"),
              _buildEntryCard(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _titleController,
                      label: "Incidence Title",
                      hint: "e.g., High mortality in Pond A",
                      icon: Icons.title_rounded,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descController,
                      label: "Description",
                      hint: "Describe what you observed...",
                      icon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("Incident Data"),
              _buildEntryCard(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration(
                        "Fish Category",
                        Icons.category,
                      ),
                      items: ["CAGE", "WILD"]
                          .map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedCategory = val),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _mortalityController,
                      label: "Mortality Count",
                      hint: "Number of dead fish",
                      icon: Icons.trending_up_rounded,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration(
                        "Severity Level",
                        Icons.warning_amber_rounded,
                      ),
                      items: ["Low", "Medium", "High"]
                          .map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => selectedLevel = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("Clinical Signs & Behaviors"),

              // Multi-select for Signs
              _buildSelectionCard(
                title: "Signs Observed",
                icon: Icons.medical_services_outlined,
                color: Colors.blue,
                currentSelection: selectedSigns,
                asyncData: signsAsync,
                onTap: () => _showMultiSelect(
                  context,
                  "Clinical Signs",
                  signsAsync,
                  selectedSignsProvider,
                  Colors.blue,
                ),
                onRemove: (id) =>
                    ref.read(selectedSignsProvider.notifier).state =
                        selectedSigns.where((i) => i != id).toList(),
              ),

              const SizedBox(height: 12),

              // Multi-select for Behaviors
              _buildSelectionCard(
                title: "Abnormal Behaviors",
                icon: Icons.psychology_outlined,
                color: Colors.teal,
                currentSelection: selectedBehaviors,
                asyncData: behaviorsAsync,
                onTap: () => _showMultiSelect(
                  context,
                  "Behaviors",
                  behaviorsAsync,
                  selectedBehaviorsProvider,
                  Colors.teal,
                ),
                onRemove: (id) =>
                    ref.read(selectedBehaviorsProvider.notifier).state =
                        selectedBehaviors.where((i) => i != id).toList(),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("Other Clinical signs and Behaviors"),

              _buildEntryCard(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _otherSignsController,
                      label: "Other Sign Observed",
                      hint: "Please specify if any other sign observer...",
                      icon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _otherBehaviorController,
                      label: "Other Behavior Observed",
                      hint: "Please specify if any other behavior observer...",
                      icon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _submitReport,
                  child: const Text(
                    "Continue to Upload Photos",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Multi-Select Bottom Sheet ---
  void _showMultiSelect(
    BuildContext context,
    String title,
    AsyncValue<List<dynamic>> asyncData,
    StateProvider<List<int>> provider,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Text(
              "Select $title",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: asyncData.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
                data: (items) => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Consumer(
                      builder: (context, ref, _) {
                        final isSelected = ref
                            .watch(provider)
                            .contains(item.id);
                        return CheckboxListTile(
                          activeColor: color,
                          title: Text(item.name),
                          value: isSelected,
                          onChanged: (val) {
                            final current = ref.read(provider);
                            ref.read(provider.notifier).state = val!
                                ? [...current, item.id]
                                : current.where((id) => id != item.id).toList();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEntryCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: child,
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<int> currentSelection,
    required AsyncValue<List<dynamic>> asyncData,
    required VoidCallback onTap,
    required Function(int) onRemove,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${currentSelection.length} selected"),
            trailing: const Icon(Icons.add_circle_outline_rounded),
            onTap: onTap,
          ),
          if (currentSelection.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 0,
                children: currentSelection.map((id) {
                  final name = asyncData.maybeWhen(
                    data: (items) => items.firstWhere((e) => e.id == id).name,
                    orElse: () => "...",
                  );
                  return Chip(
                    label: Text(name, style: const TextStyle(fontSize: 11)),
                    onDeleted: () => onRemove(id),
                    deleteIconColor: color,
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label, icon).copyWith(hintText: hint),
    );
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // Collect your state values for the API call
      // final signs = ref.read(selectedSignsProvider);
      // final behaviors = ref.read(selectedBehaviorsProvider);

      Navigator.pushNamed(
        context,
        '/upload-images',
        arguments: {'reportId': 101},
      );
    }
  }
}
