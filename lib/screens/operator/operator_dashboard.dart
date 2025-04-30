import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_provider.dart';
import '../../models/material_model.dart' as model;

class OperatorDashboard extends StatefulWidget {
  const OperatorDashboard({super.key});

  @override
  State<OperatorDashboard> createState() => _OperatorDashboardState();
}


class _OperatorDashboardState extends State<OperatorDashboard> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final materials = provider.materials
              .where(
                  (m) => m.name.toLowerCase().contains(_search.toLowerCase()))
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search materials...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (val) => setState(() => _search = val),
                ),
              ),
              Expanded(
                child: materials.isEmpty
                    ? const Center(child: Text('No materials found.'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: materials.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final material = materials[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: material.isLowStock
                                  ? const BorderSide(
                                      color: Colors.red, width: 2)
                                  : BorderSide.none,
                            ),
                            child: ListTile(
                              leading: Icon(
                                material.isLowStock
                                    ? Icons.warning
                                    : Icons.inventory_2,
                                color: material.isLowStock
                                    ? Colors.red
                                    : Colors.blue,
                              ),
                              title: Text(
                                material.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Stock: ${material.currentStock} ${material.unitType}\nUnit Cost: ₹${material.unitCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: material.isLowStock
                                      ? Colors.red
                                      : Colors.black87,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.qr_code_scanner),
                                    tooltip: 'Scan Material',
                                    onPressed: () {
                                      // TODO: Implement QR scanning
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    tooltip: 'Purchase',
                                    onPressed: () async {
                                      final qty = await showDialog<double>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) =>
                                            _PurchaseDialog(material: material),
                                      );
                                      if (qty != null && qty > 0) {
                                        if (qty > material.currentStock) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Cannot purchase $qty ${material.unitType}. Only ${material.currentStock} in stock.',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } else {
                                          await Provider.of<InventoryProvider>(
                                                  context,
                                                  listen: false)
                                              .updateMaterial(
                                            model.Material(
                                              id: material.id,
                                              name: material.name,
                                              unitCost: material.unitCost,
                                              unitType: material.unitType,
                                              currentStock:
                                                  material.currentStock - qty,
                                              minimumStock:
                                                  material.minimumStock,
                                              barcode: material.barcode,
                                            ),
                                          );
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Purchased $qty ${material.unitType} of ${material.name}',
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan'),
        onPressed: () {
          // TODO: Implement QR/barcode scanning
        },
      ),
    );
  }
}

class _PurchaseDialog extends StatefulWidget {
  final model.Material material;
  const _PurchaseDialog({required this.material});

  @override
  State<_PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<_PurchaseDialog> {
  final _controller = TextEditingController();
  String? _error;
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Purchase ${widget.material.name}'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: 'Quantity',
          errorText: _error,
        ),
        enabled: !_isProcessing,
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isProcessing
              ? null
              : () {
                  final qty = double.tryParse(_controller.text);
                  if (qty == null || qty <= 0) {
                    setState(() => _error = 'Enter a valid quantity');
                  } else {
                    setState(() => _isProcessing = true);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.pop(context, qty);
                    });
                  }
                },
          child: _isProcessing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Purchase'),
        ),
      ],
    );
  }
}
