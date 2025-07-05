class Category_ {
  final String name;

  Category_({required this.name});

  factory Category_.fromJson(dynamic json) {
    return Category_(name: json as String);
  }

  dynamic toJson() {
    return name;
  }
}
