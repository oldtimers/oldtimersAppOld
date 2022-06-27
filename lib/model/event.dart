import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/date_time_converter.dart';

part 'event.g.dart';

@JsonSerializable()
@TypeConverters([DateTimeConverter])
@Entity(primaryKeys: ['id'])
class Event {
  final int id;
  final String name;
  final String description;
  final String url;
  final String stage;
  final String? mainPhoto;
  final DateTime? startDate;
  final DateTime? endDate;

  Event(this.id, this.name, this.description, this.url, this.stage, this.mainPhoto, this.startDate, this.endDate);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
