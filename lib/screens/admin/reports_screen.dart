import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final lowStockCount = provider.getLowStockMaterials().length;
        final completedCount = provider.getProductionsByStatus('completed').length;
        final inProgressCount = provider.getProductionsByStatus('in_progress').length;
        final pendingCount = provider.getProductionsByStatus('pending').length;

        return ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text('Reports & Analytics', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSummaryCard(
                  icon: Icons.warning,
                  color: Colors.red,
                  title: 'Low Stock Materials',
                  value: lowStockCount.toString(),
                  context: context,
                ),
                _buildSummaryCard(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  title: 'Completed Productions',
                  value: completedCount.toString(),
                  context: context,
                ),
                _buildSummaryCard(
                  icon: Icons.timelapse,
                  color: Colors.orange,
                  title: 'In Progress',
                  value: inProgressCount.toString(),
                  context: context,
                ),
                _buildSummaryCard(
                  icon: Icons.pending,
                  color: Colors.blueGrey,
                  title: 'Pending',
                  value: pendingCount.toString(),
                  context: context,
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Add more analytics widgets here as needed
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 12),
                    Text('Total Materials: ${provider.materials.length}'),
                    Text('Total Processes: ${provider.processes.length}'),
                    Text('Total Productions: ${provider.productions.length}'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 40,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
