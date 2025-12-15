// Request model placeholder
// TODO: Implement request model with Supabase integration

class RequestModel {
  final String id;
  final String clientId;
  final String title;
  final String description;
  final String category;
  final String location;
  final String status; // 'pending', 'accepted', 'in_progress', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? updatedAt;

  RequestModel({
    required this.id,
    required this.clientId,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      clientId: json['client_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

