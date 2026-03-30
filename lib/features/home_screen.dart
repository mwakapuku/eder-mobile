import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Using Material 3 color schemes for a unified look
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        title: Text(
          "EDERA",
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w200, letterSpacing: 1.2),
        ),
        centerTitle: false, // Modern apps often left-align titles
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCarousel(context),
            const SizedBox(height: 32),

            Text("Report Fish Health Event", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildReportCard(
                    context,
                    title: "Cage Fish",
                    subtitle: "Tilapia farms",
                    icon: Icons.grid_view_rounded,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildReportCard(
                    context,
                    title: "Wild Cichlids",
                    subtitle: "Monitoring",
                    icon: Icons.waves_rounded,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent Alerts", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text("View All")),
              ],
            ),
            const SizedBox(height: 8),

            _buildAlertCard(
              context,
              "High mortality in Zone A",
              "Responded within 24h",
              Colors.orange,
            ),
            _buildAlertCard(
              context,
              "Suspected fungal infection",
              "Under verification",
              Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

// 1. Add a PageController to your State class
  final PageController _pageController = PageController(viewportFraction: 1.0);

  Widget _buildHeaderCarousel(BuildContext context) {
    return SizedBox(
      height: 220, // Fixed height for the carousel
      child: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildHeaderCard(
            context,
            title: "Early Detection,\nEarly Response",
            subtitle: "Real-time surveillance system active.",
            icon: Icons.analytics_outlined,
            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.tertiary],
          ),
          _buildHeaderCard(
            context,
            title: "Environmental\nMonitoring",
            subtitle: "Water quality sensors are online.",
            icon: Icons.thermostat_outlined,
            colors: [Colors.teal, Colors.green],
          ),
          _buildHeaderCard(
            context,
            title: "System\nDiagnostics",
            subtitle: "All nodes reporting successfully.",
            icon: Icons.memory_outlined,
            colors: [Colors.indigo, Colors.blueAccent],
          ),
        ],
      ),
    );
  }

// 2. Modified Header Card to accept parameters
  Widget _buildHeaderCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required List<Color> colors,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8), // Gap between cards
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(BuildContext context,
      {required String title, required String subtitle, required IconData icon, required Color color}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Theme.of(context).dividerColor.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 28,
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: color.withOpacity(0.2)),
        ),
        leading: Container(
          width: 4,
          height: 30,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: () {},
      ),
    );
  }
}