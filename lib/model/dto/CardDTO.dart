class CardDTO {
  final String internalCode;
  final String editDateTime;
  final String front;
  final String back;
  final String example;
  final int status;

  CardDTO({
    required this.internalCode,
    required this.editDateTime,
    required this.front,
    required this.back,
    required this.example,
    required this.status,
  });

  factory CardDTO.fromJson(Map<String, dynamic> json) {
    return CardDTO(
      internalCode: json['internalCode'],
      editDateTime: json['editDateTime'],
      front: json['front'],
      back: json['back'],
      example: json['example'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'internalCode': internalCode,
      'editDateTime': editDateTime,
      'front': front,
      'back': back,
      'example': example,
      'status': status,
    };
  }
}
