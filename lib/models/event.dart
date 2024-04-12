import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final String createdBy;

  Event(
      {required this.id,
      required this.title,
      required this.date,
      required this.description,
      required this.createdBy});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'description': description,
        'createdBy': createdBy,
      };

  static Event fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        title: json['title'],
        date: (json['date'] as Timestamp).toDate(),
        description: json['description'],
        createdBy: json['createdBy'],
      );
}
