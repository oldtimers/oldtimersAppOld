import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final int id;
  final String name;
  final String description;
  final String url;
  final String stage;
  // final String? mainPhoto;
  final DateTime startDate;
  final DateTime endDate;

  Event(this.id, this.name, this.description, this.url, this.stage, this.startDate, this.endDate);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
