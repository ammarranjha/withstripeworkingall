import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

class WalletModel {
  String uniqueId;
  String userId;
  int credit;
  num balance;

  WalletModel({
    this.uniqueId,
    this.userId,
    this.credit,
    this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'uniqueId': uniqueId,
      'userId': userId,
      'credit': credit,
      'balance': balance,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      uniqueId: map['uniqueId'].toString(),
      userId: map['userId'].toString(),
      credit: map['credit'],
      balance: map['balance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WalletModel(uniqueId: $uniqueId, userId: $userId, credit: $credit, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletModel &&
        other.uniqueId == uniqueId &&
        other.userId == userId &&
        other.credit == credit &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return uniqueId.hashCode ^
        userId.hashCode ^
        credit.hashCode ^
        balance.hashCode;
  }
}
