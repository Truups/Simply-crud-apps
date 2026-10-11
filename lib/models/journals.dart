class Journals {
  int? id;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;


  // Constructor
  Journals({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt
});

//   Mapping data
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String()
    };
  }

  static Journals fromMap(Map<String, dynamic> map){
    return Journals(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at'])
    );
  }

}