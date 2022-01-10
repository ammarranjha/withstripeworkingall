import 'dart:convert';

class MiniStatementModel {
  final String fromName;
  final String toName;
  final String fromId;
  final String toId;
  final String from;
  final String to;
  final int amount;
  final String date;
  
  MiniStatementModel({
    this.fromName,
    this.toName,
    this.fromId,
    this.toId,
    this.from,
    this.to,
    this.amount,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromName': fromName,
      'toName': toName,
      'fromId': fromId,
      'toId': toId,
      'from': from,
      'to': to,
      'amount': amount,
      'date': date,
    };
  }

  factory MiniStatementModel.fromMap(Map<String, dynamic> map) {
    return MiniStatementModel(
      fromName: map['fromname'] ?? '',
      toName: map['toname'] ?? '',
      fromId: map['fromId'] ?? '',
      toId: map['toid'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      amount: map['amount'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MiniStatementModel.fromJson(String source) => MiniStatementModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MiniStatementModel(fromName: $fromName, toName: $toName, fromId: $fromId, toId: $toId, from: $from, to: $to, amount: $amount, date: $date)';
  }
}
