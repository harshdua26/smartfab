import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'material_model.dart';
import 'process_model.dart';

part 'production_model.g.dart';

@HiveType(typeId: 2)
class Production extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final Map<String, double> materialQuantities; // Material ID -> Quantity Used

  @HiveField(4)
  final Map<String, double> processHours; // Process ID -> Hours Used

  @HiveField(5)
  final double desiredMargin; // Percentage (e.g., 0.25 for 25%)

  @HiveField(6)
  String status; // 'pending', 'in_progress', 'completed'

  Production({
    String? id,
    DateTime? date,
    required this.productName,
    required this.materialQuantities,
    required this.processHours,
    required this.desiredMargin,
    this.status = 'pending',
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  double calculateRawMaterialCost(Map<String, Material> materials) {
    double totalCost = 0;
    materialQuantities.forEach((materialId, quantity) {
      if (materials.containsKey(materialId)) {
        totalCost += materials[materialId]!.unitCost * quantity;
      }
    });
    return totalCost;
  }

  double calculateProcessingCost(Map<String, ManufacturingProcess> processes) {
    double totalCost = 0;
    processHours.forEach((processId, hours) {
      if (processes.containsKey(processId)) {
        totalCost += processes[processId]!.calculateCost(hours);
      }
    });
    return totalCost;
  }

  double calculateManufacturingCost(
    Map<String, Material> materials,
    Map<String, ManufacturingProcess> processes,
  ) {
    return calculateRawMaterialCost(materials) +
        calculateProcessingCost(processes);
  }

  double calculateFinalPrice(
    Map<String, Material> materials,
    Map<String, ManufacturingProcess> processes,
  ) {
    final manufacturingCost = calculateManufacturingCost(materials, processes);
    return manufacturingCost * (1 + desiredMargin);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'productName': productName,
      'materialQuantities': materialQuantities,
      'processHours': processHours,
      'desiredMargin': desiredMargin,
      'status': status,
    };
  }

  factory Production.fromJson(Map<String, dynamic> json) {
    return Production(
      id: json['id'],
      date: DateTime.parse(json['date']),
      productName: json['productName'],
      materialQuantities: Map<String, double>.from(json['materialQuantities']),
      processHours: Map<String, double>.from(json['processHours']),
      desiredMargin: json['desiredMargin'],
      status: json['status'],
    );
  }
} 