import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../controller/report_controller.dart';
import 'report_detail_screen.dart';

class ReportListScreen extends ConsumerWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
      appBar: AppBar(
        title: const Text(
          "Disease Reports",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        scrolledUnderElevation: 2, // Modern M3 shadow on scroll
      ),
      body: reportState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text("Error found: $e")),
        data: (reports) {
          if (reports.isEmpty) {
            return _buildEmptyState(theme);
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(reportProvider.notifier).fetchReports(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final report = reports[index];
                return _buildModernReportCard(context, report, theme);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          ref.read(reportProvider.notifier).fetchReports();
          Navigator.pushNamed(context, "/create-report");
        },
        icon: const Icon(Icons.add),
        label: const Text("New Report"),
      ),
    );
  }

  Widget _buildModernReportCard(
    BuildContext context,
    dynamic report,
    ThemeData theme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportDetailScreen(report: report),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 1. Image Thumbnail with ClipRRect
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: (report.images != null && report.images!.isNotEmpty)
                    ? Image.network(
                        report.images![0].image ?? '',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildImagePlaceholder(theme),
                      )
                    : _buildImagePlaceholder(theme),
              ),
              const SizedBox(width: 16),

              // 2. Report Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${report.title}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Mortality: ${report.mortalityCount} fish",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.createdAt.toString(), // Formatting suggested here
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Status Tag
              _buildStatusChip(report.status ?? 'Unknown'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      width: 70,
      height: 70,
      color: theme.colorScheme.surfaceVariant,
      child: Icon(Icons.image_not_supported_outlined, color: theme.hintColor),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: theme.hintColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text("No reports found", style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text("Tap '+' to create event.", style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
        return AppTheme.success;
      case 'REPORTED':
        return AppTheme.warning;
      case 'CLOSED':
        return AppTheme.danger;
      case "REVIEWED BY EXTENSION OFFICER":
        return Colors.blue;
      default:
        return AppTheme.inactive;
    }
  }

  Color getSeverityColor(String level) {
    switch (level.toUpperCase()) {
      case 'HIGH':
        return AppTheme.danger;
      case 'MEDIUM':
        return AppTheme.warning;
      case 'LOW':
        return AppTheme.success;
      default:
        return AppTheme.inactive;
    }
  }
}
