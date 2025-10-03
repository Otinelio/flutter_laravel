class Todo {
  Todo({
    required this.id,
    required this.title,
    required this.createdBy,
    this.description,
    this.pathName,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String createdBy;
  final String? description;
  final String? pathName;
  final DateTime createdAt;

  factory Todo.fromjson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      createdBy: json['created_by'],
      description: json['description'],
      pathName: json['path_name'],
      createdAt: json['created_at'],
    );
  }
}
