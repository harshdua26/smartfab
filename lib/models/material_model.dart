import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'material_model.g.dart';

@HiveType(typeId: 0)
class Material extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double unitCost;

  @HiveField(3)
  String unitType;

  @HiveField(4)
  double currentStock;

  @HiveField(5)
  double minimumStock;

  @HiveField(6)
  String barcode;

  @HiveField(7)
  DateTime lastUpdated;

  Material({
    String? id,
    required this.name,
    required this.unitCost,
    required this.unitType,
    required this.currentStock,
    required this.minimumStock,
    required this.barcode,
  }) : id = id ?? const Uuid().v4(),
       lastUpdated = DateTime.now();

  bool get isLowStock => currentStock <= minimumStock;

  void updateStock(double quantity) {
    currentStock += quantity;
    lastUpdated = DateTime.now();
    save(); // Hive auto-save
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unitCost': unitCost,
      'unitType': unitType,
      'currentStock': currentStock,
      'minimumStock': minimumStock,
      'barcode': barcode,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      name: json['name'],
      unitCost: json['unitCost'],
      unitType: json['unitType'],
      currentStock: json['currentStock'],
      minimumStock: json['minimumStock'],
      barcode: json['barcode'],
    );
  }
} 