
const String idField = "_id";
const String photoField = "photo";
const String nameField = "name";
const String descriptionField = "description";
const String valueField = "value";

const List<String> sushiColumns = [
  idField,
  photoField,
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
  final String? photo;
  final String name;
  final String? description;
  final double value;

  const Sushi({
    this.id,
    this.photo,
    required this.name,
    this.description,
    required this.value
  });

  static Sushi fromJson(Map<String, dynamic> json) => Sushi(
    id: json[idField] as int?,
    photo: json[photoField] as String?,
    name: json[nameField] as String,
    description: json[descriptionField] as String?,
    value: json[valueField] as double,
  );

  Map<String, dynamic> toJson() => {
    idField: id,
    photoField: photo,
    nameField: name,
    descriptionField: description,
    valueField: value,
  };

  Sushi copyWith({
    int? id,
    String? photo,
    String? name,
    String? description,
    double? value,
  }) => 
  Sushi(
    id: id ?? this.id,
    photo: photo ?? this.photo,
    name: name ?? this.name,
    description: description ?? this.description, 
    value: value ?? this.value);
}