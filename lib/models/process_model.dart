import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'process_model.g.dart';

@HiveType(typeId: 1)
class ManufacturingProcess extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double laborCostPerHour;

  @HiveField(3)
  double energyCostPerHour;

  @HiveField(4)
  double otherCostsPerHour;

  @HiveField(5)
  String description;

  ManufacturingProcess({
    String? id,
    required this.name,
    required this.laborCostPerHour,
    required this.energyCostPerHour,
    this.otherCostsPerHour = 0.0,
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  double get totalCostPerHour =>
      laborCostPerHour + energyCostPerHour + otherCostsPerHour;

  double calculateCost(double hours) {
    return totalCostPerHour * hours;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'laborCostPerHour': laborCostPerHour,
      'energyCostPerHour': energyCostPerHour,
      'otherCostsPerHour': otherCostsPerHour,
      'description': description,
    };
  }

  factory ManufacturingProcess.fromJson(Map<String, dynamic> json) {
    return ManufacturingProcess(
      id: json['id'],
      name: json['name'],
      laborCostPerHour: json['laborCostPerHour'],
      energyCostPerHour: json['energyCostPerHour'],
      otherCostsPerHour: json['otherCostsPerHour'],
      description: json['description'],
    );
  }
}
