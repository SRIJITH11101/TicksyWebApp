class Message {
  final String? id;
  final String ticketId;
  final String text;
  final String originalLang;
  final String translateLang; // maps from 'translatedLang' backend key
  final String? translatedText;
  final String sentBy;
  final List<String> attachmentUrls;
  final DateTime? createdAt;

  Message({
    this.id,
    required this.ticketId,
    required this.text,
    required this.originalLang,
    required this.translateLang,
    this.translatedText,
    required this.sentBy,
    this.attachmentUrls = const [],
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      ticketId: json['ticketId'] ?? '',
      text: json['text'] ?? '',
      originalLang: json['originalLang'] ?? '',
      // 🔥 Fix for key mismatch
      translateLang: json['translatedLang'] ?? json['translateLang'] ?? '',
      translatedText: json['translatedText'],
      sentBy: json['sentBy'] ?? '',
      attachmentUrls: (json['attachmentUrls'] != null)
          ? List<String>.from(json['attachmentUrls'])
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'ticketId': ticketId,
      'text': text,
      'originalLang': originalLang,
      'translatedLang': translateLang,
      if (translatedText != null) 'translatedText': translatedText,
      'sentBy': sentBy,
      'attachmentUrls': attachmentUrls,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
