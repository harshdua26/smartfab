import 'package:flutter/foundation.dart';
import '../models/material_model.dart';
import '../models/process_model.dart';
import '../models/production_model.dart';
import '../services/storage_service.dart';

class InventoryProvider with ChangeNotifier {
  final StorageService _storage;

  List<Material> _materials = [];
  List<ManufacturingProcess> _processes = [];
  List<Production> _productions = [];
  bool _isLoading = false;

  InventoryProvider(this._storage) {
    _loadData();
  }

  // Getters
  List<Material> get materials => _materials;
  List<ManufacturingProcess> get processes => _processes;
  List<Production> get productions => _productions;
  bool get isLoading => _isLoading;

  // Materials
  Future<void> addMaterial(Material material) async {
    await _storage.saveMaterial(material);
    _materials.add(material);
    notifyListeners();
  }

  Future<void> updateMaterial(Material material) async {
    await _storage.saveMaterial(material);
    final index = _materials.indexWhere((m) => m.id == material.id);
    if (index != -1) {
      _materials[index] = material;
      notifyListeners();
    }
  }

  Future<void> deleteMaterial(String id) async {
    await _storage.deleteMaterial(id);
    _materials.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  // Processes
  Future<void> addProcess(ManufacturingProcess process) async {
    await _storage.saveProcess(process);
    _processes.add(process);
    notifyListeners();
  }

  Future<void> updateProcess(ManufacturingProcess process) async {
    await _storage.saveProcess(process);
    final index = _processes.indexWhere((p) => p.id == process.id);
    if (index != -1) {
      _processes[index] = process;
      notifyListeners();
    }
  }

  Future<void> deleteProcess(String id) async {
    await _storage.deleteProcess(id);
    _processes.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Productions
  Future<void> addProduction(Production production) async {
    await _storage.saveProduction(production);
    _productions.add(production);
    notifyListeners();
  }

  Future<void> updateProduction(Production production) async {
    await _storage.saveProduction(production);
    final index = _productions.indexWhere((p) => p.id == production.id);
    if (index != -1) {
      _productions[index] = production;
      notifyListeners();
    }
  }

  Future<void> deleteProduction(String id) async {
    await _storage.deleteProduction(id);
    _productions.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Queries
  List<Material> getLowStockMaterials() {
    return _materials.where((m) => m.isLowStock).toList();
  }

  List<Production> getProductionsByDateRange(DateTime start, DateTime end) {
    return _productions
        .where((p) => p.date.isAfter(start) && p.date.isBefore(end))
        .toList();
  }

  List<Production> getProductionsByStatus(String status) {
    return _productions.where((p) => p.status == status).toList();
  }

  // Loading data
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _materials = _storage.getAllMaterials();
      _processes = _storage.getAllProcesses();
      _productions = _storage.getAllProductions();
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Refresh data
  Future<void> refreshData() async {
    await _loadData();
  }
}
