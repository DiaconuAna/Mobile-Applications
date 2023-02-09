import 'dart:convert';

const String mainTable = 'records';
const String auxTable = 'days';

List<Record> entriesFromJsonApi(String str) =>
    List<Record>.from(json.decode(str).map((x) => Record.fromJsonApi(x)));

String recordToJsonApi(List<Record> entries) =>
    json.encode(List<dynamic>.from(entries.map((x) => x.toJsonApi())));

class RecordFields {
  static final List<String> values = [
    id,
    date,
    type,
    amount,
    category,
    description
  ];
  static const String id = '_id';
  static const String date = 'date';
  static const String type = 'type';
  static const String amount = 'amount';
  static const String category = 'category';
  static const String description = 'description';
}

class Record {
  int? id;
  String date;
  String type;
  int amount;
  String category;
  String description;

  Record({
    this.id,
    required this.date,
    required this.type,
    required this.description,
    required this.amount,
    required this.category,
  });

  Record copy({
    int? id,
    String? date,
    String? type,
    String? description,
    String? category,
    int? amount,
  }) =>
      Record(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        category: category ?? this.category,
      );

  Map<String, Object?> toJson() => {
        RecordFields.id: id,
        RecordFields.date: date,
        RecordFields.type: type,
        RecordFields.description: description,
        RecordFields.amount: amount,
        RecordFields.category: category,
      };

  static Record fromJson(Map<String, Object?> json) => Record(
        id: json[RecordFields.id] as int?,
        date: json[RecordFields.date] as String,
        type: json[RecordFields.type] as String,
        description: json[RecordFields.description] as String,
        category: json[RecordFields.category] as String,
        amount: json[RecordFields.amount] as int,
      );

  Map<String, dynamic> toJsonApi() => {
        "id": id,
        "date": date,
        "type": type,
        "description": description,
        "category": category,
        "amount": amount
      };

  factory Record.fromJsonApi(Map<String, dynamic> json) => Record(
        id: json['id'],
        date: json['date'],
        type: json['type'],
        description: json['description'],
        category: json['category'],
        amount: json['amount'],
      );
}
