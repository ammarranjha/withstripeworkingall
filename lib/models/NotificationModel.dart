import 'dart:convert';

class NotificationModel {
  final ride;
  final String message;
  final bool read;

  NotificationModel({
    this.ride,
    this.message,
    this.read,
  });


  NotificationModel copyWith({
    ride,
    String message,
    bool read,
  }) {
    return NotificationModel(
      message: message ?? this.message,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ride': message,
      'message': message,
      'read': read,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      ride: map['ride'],
      message: map['message'],
      read: map['read'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source));

  @override
  String toString() => 'NotificationModelDart(ride: $ride, message: $message, read: $read)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NotificationModel &&
      other.ride == ride &&
      other.message == message &&
      other.read == read;
  }

  @override
  int get hashCode => message.hashCode ^ read.hashCode;
}
