import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';
import '../../models/material_model.dart' as model;
import 'materials_list.dart';
import 'processes_list.dart';
import 'production_list.dart';
import 'reports_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.inventory), text: 'Materials'),
              Tab(icon: Icon(Icons.precision_manufacturing), text: 'Processes'),
              Tab(
                  icon: Icon(Icons.production_quantity_limits),
                  text: 'Production'),
              Tab(icon: Icon(Icons.analytics), text: 'Reports'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Show low stock notifications
                final lowStockMaterials =
                    context.read<InventoryProvider>().getLowStockMaterials();
                _showLowStockAlert(context, lowStockMaterials);
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            MaterialsList(),
            ProcessesList(),
            ProductionList(),
            ReportsScreen(),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final tabIndex = DefaultTabController.of(context).index;
            return _buildFloatingActionButton(context, tabIndex);
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            // Show add material dialog
          },
          child: const Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () {
            // Show add process dialog
          },
          child: const Icon(Icons.add),
        );
      case 2:
        return FloatingActionButton(
          onPressed: () {
            // Show add production dialog
          },
          child: const Icon(Icons.add),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showLowStockAlert(
      BuildContext context, List<model.Material> materials) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Low Stock Alert'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return ListTile(
                title: Text(material.name),
                subtitle: Text(
                  'Current Stock: ${material.currentStock} ${material.unitType}',
                ),
                leading: const Icon(Icons.warning, color: Colors.orange),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
