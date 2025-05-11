const String idField = "_id";
const String photoField = "photo";
const String nameField = "name";
const String descriptionField = "description";
const String valueField = "value";

const List<String> produtoColumns = [
  idField,
  photoField,
  nameField,
  descriptionField,
  valueField
];



class Produto{
  final int? id;
  final String? photo;
  final String name;
  final String? description;
  final double value;

  const Produto({
    this.id,
    this.photo,
    required this.name,
    this.description,
    required this.value
  });

  static Produto fromJson(Map<String, dynamic> json) => Produto(
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

  Produto copyWith({
    int? id,
    String? photo,
    String? name,
    String? description,
    double? value,
  }) => 
  Produto(
    id: id ?? this.id,
    photo: photo ?? this.photo,
    name: name ?? this.name,
    description: description ?? this.description, 
    value: value ?? this.value);
}