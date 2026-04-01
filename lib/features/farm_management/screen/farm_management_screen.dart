import 'package:flutter/material.dart';

class FarmManagementScreen extends StatelessWidget {
  const FarmManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farm Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Row(
              children: [
                _statCard('2', 'My farms', theme),
                const SizedBox(width: 10),
                _statCard('5', 'Total cages', theme),
                const SizedBox(width: 10),
                _statCard('12k', 'Total fish', theme),
              ],
            ),

            const SizedBox(height: 24),
            _sectionTitle('My farms'),

            _farmCard(
              context,
              name: 'Mwanza Cage Farm A',
              meta: '3 cages · 7,500 fish · Lake Victoria',
              isActive: true,
              theme: theme,
            ),
            const SizedBox(height: 10),
            _farmCard(
              context,
              name: 'Ruvu River Unit B',
              meta: '2 cages · 4,500 fish · Ruvu River',
              isActive: false,
              theme: theme,
            ),

            const SizedBox(height: 10),

            // Add farm button
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.4),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: theme.hintColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Add new farm',
                      style: TextStyle(color: theme.hintColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 16),
            _sectionTitle('Coming soon'),

            _comingSoonCard(
              context,
              icon: Icons.monitor_outlined,
              iconColor: const Color(0xFF534AB7),
              iconBg: const Color(0xFFEEEDFE),
              title: 'Farm analytics dashboard',
              subtitle: 'Advanced monitoring & insights',
              pillColor: const Color(0xFFEEEDFE),
              pillTextColor: const Color(0xFF3C3489),
              features: const [
                'Water quality monitoring (pH, DO, temperature)',
                'Feed tracking and FCR calculations',
                'Growth rate charts per cage unit',
                'Disease risk alerts and predictions',
                'Harvest planning and yield estimates',
              ],
              dotColor: const Color(0xFFAFA9EC),
              theme: theme,
            ),

            const SizedBox(height: 10),

            _comingSoonCard(
              context,
              icon: Icons.group_outlined,
              iconColor: const Color(0xFF0F6E56),
              iconBg: const Color(0xFFE1F5EE),
              title: 'Staff & access management',
              subtitle: 'Invite team members to your farm',
              pillColor: const Color(0xFFE1F5EE),
              pillTextColor: const Color(0xFF085041),
              features: const [
                'Assign roles — farmer, observer, vet',
                'Per-farm access permissions',
                'Activity logs per team member',
              ],
              dotColor: const Color(0xFF5DCAA5),
              theme: theme,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );

  Widget _statCard(String value, String label, ThemeData theme) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: theme.hintColor)),
        ],
      ),
    ),
  );

  Widget _farmCard(
    BuildContext context, {
    required String name,
    required String meta,
    required bool isActive,
    required ThemeData theme,
  }) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
    ),
    child: Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFE1F5EE)
                : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.home_work_outlined,
            color: isActive ? const Color(0xFF0F6E56) : theme.hintColor,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                meta,
                style: TextStyle(fontSize: 12, color: theme.hintColor),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFE1F5EE)
                : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFF0F6E56) : theme.hintColor,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _comingSoonCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Color pillColor,
    required Color pillTextColor,
    required List<String> features,
    required Color dotColor,
    required ThemeData theme,
  }) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: pillColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Coming soon',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: pillTextColor,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...features.map(
          (f) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    f,
                    style: TextStyle(fontSize: 13, color: theme.hintColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
