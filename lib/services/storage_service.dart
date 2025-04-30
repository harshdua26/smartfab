import 'package:hive_flutter/hive_flutter.dart';
import '../models/material_model.dart';
import '../models/process_model.dart';
import '../models/production_model.dart';

class StorageService {
  static const String materialsBox = 'materials';
  static const String processesBox = 'processes';
  static const String productionsBox = 'productions';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(MaterialAdapter());
    Hive.registerAdapter(ManufacturingProcessAdapter());
    Hive.registerAdapter(ProductionAdapter());

    // Open boxes
    await Hive.openBox<Material>(materialsBox);
    await Hive.openBox<ManufacturingProcess>(processesBox);
    await Hive.openBox<Production>(productionsBox);
  }

  // Materials CRUD
  Future<void> saveMaterial(Material material) async {
    final box = Hive.box<Material>(materialsBox);
    await box.put(material.id, material);
  }

  List<Material> getAllMaterials() {
    final box = Hive.box<Material>(materialsBox);
    return box.values.toList();
  }

  Material? getMaterial(String id) {
    final box = Hive.box<Material>(materialsBox);
    return box.get(id);
  }

  Future<void> deleteMaterial(String id) async {
    final box = Hive.box<Material>(materialsBox);
    await box.delete(id);
  }

  // Processes CRUD
  Future<void> saveProcess(ManufacturingProcess process) async {
    final box = Hive.box<ManufacturingProcess>(processesBox);
    await box.put(process.id, process);
  }

  List<ManufacturingProcess> getAllProcesses() {
    final box = Hive.box<ManufacturingProcess>(processesBox);
    return box.values.toList();
  }

  ManufacturingProcess? getProcess(String id) {
    final box = Hive.box<ManufacturingProcess>(processesBox);
    return box.get(id);
  }

  Future<void> deleteProcess(String id) async {
    final box = Hive.box<ManufacturingProcess>(processesBox);
    await box.delete(id);
  }

  // Productions CRUD
  Future<void> saveProduction(Production production) async {
    final box = Hive.box<Production>(productionsBox);
    await box.put(production.id, production);
  }

  List<Production> getAllProductions() {
    final box = Hive.box<Production>(productionsBox);
    return box.values.toList();
  }

  Production? getProduction(String id) {
    final box = Hive.box<Production>(productionsBox);
    return box.get(id);
  }

  Future<void> deleteProduction(String id) async {
    final box = Hive.box<Production>(productionsBox);
    await box.delete(id);
  }

  // Query helpers
  List<Material> getLowStockMaterials() {
    return getAllMaterials().where((m) => m.isLowStock).toList();
  }

  List<Production> getProductionsByDateRange(DateTime start, DateTime end) {
    return getAllProductions()
        .where((p) => p.date.isAfter(start) && p.date.isBefore(end))
        .toList();
  }

  List<Production> getProductionsByStatus(String status) {
    return getAllProductions().where((p) => p.status == status).toList();
  }

  Future<void> seedDemoMaterials() async {
    final box = Hive.box<Material>(materialsBox);
    if (box.isEmpty) {
      final demoMaterials = [
        Material(
          name: 'Steel Rod',
          unitCost: 120.0,
          unitType: 'kg',
          currentStock: 500,
          minimumStock: 100,
          barcode: 'STEEL001',
        ),
        Material(
          name: 'Aluminum Sheet',
          unitCost: 200.0,
          unitType: 'sheet',
          currentStock: 200,
          minimumStock: 50,
          barcode: 'ALU002',
        ),
        Material(
          name: 'Copper Wire',
          unitCost: 80.0,
          unitType: 'meter',
          currentStock: 1000,
          minimumStock: 200,
          barcode: 'COP003',
        ),
        Material(
          name: 'Plastic Granules',
          unitCost: 60.0,
          unitType: 'kg',
          currentStock: 800,
          minimumStock: 150,
          barcode: 'PLS004',
        ),
      ];
      for (final m in demoMaterials) {
        await box.put(m.id, m);
      }
    }
  }
}
