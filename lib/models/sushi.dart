
const String idField = "_id";
const String nameField = "name";
const String descriptionField = "description";
const String valueField = "value";

const List<String> sushiColumns = [
  idField,
  nameField,
  descriptionField,
  valueField
];

const String boolType = "BOOLEAN NOT NULL";
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNullable = "TEXT";
const String textType = "TEXT NOT NULL";
const String doubleType = "REAL NOT NULL";
class Sushi{
  final int? id;
  final String name;
  final String? description;
  final double value;

  const Sushi({
    this.id,
    required this.name,
    this.description,
    required this.value
  });

  static Sushi fromJson(Map<String, dynamic> json) => Sushi(
    id: json[idField] as int?,
    name: json[nameField] as String,
    description: json[descriptionField] as String?,
    value: json[valueField] as double,
  );

  Map<String, dynamic> toJson() => {
    idField: id,
    nameField: name,
    descriptionField: description,
    valueField: value,
  };

  Sushi copyWith({
    int? id,
    String? name,
    String? description,
    double? value,
  }) => 
  Sushi(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description, 
    value: value ?? this.value);
}