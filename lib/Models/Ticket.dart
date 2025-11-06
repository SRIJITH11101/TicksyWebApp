class Ticket {
  final String id;
  final String userId;
  final String subject;
  final String description;
  final String translatedSubject;
  final String translatedDescription;
  final String department;
  final String priority;
  final String status;
  final bool isOpen;
  final String originalLang;
  final String translateLang;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.description,
    required this.translatedSubject,
    required this.translatedDescription,
    required this.department,
    required this.priority,
    required this.status,
    required this.isOpen,
    required this.originalLang,
    required this.translateLang,
    required this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['userId'],
      subject: json['subject'],
      description: json['description'],
      translatedSubject: json['translatedSubject'],
      translatedDescription: json['translatedDescription'],
      department: json['department'],
      priority: json['priority'],
      status: json['status'],
      isOpen: json['isOpen'],
      originalLang: json['originalLang'],
      translateLang: json['translateLang'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'subject': subject,
      'description': description,
      'translatedSubject': translatedSubject,
      'translatedDescription': translatedDescription,
      'department': department,
      'priority': priority,
      'status': status,
      'isOpen': isOpen,
      'originalLang': originalLang,
      'translateLang': translateLang,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
