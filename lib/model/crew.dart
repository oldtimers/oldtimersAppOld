import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oldtimers_rally_app/model/event.dart';

part 'crew.g.dart';

@JsonSerializable()
@Entity(indices: [
  Index(value: ['qr'], unique: true)
], foreignKeys: [
  ForeignKey(childColumns: ['eventId'], parentColumns: ['id'], entity: Event)
])
class Crew {
  @primaryKey
  final int id;
  final int number;
  final int yearOfProduction;
  final String phone;
  final String car;
  final String driverName;
  final String qr;
  final int eventId;

  Crew(this.id, this.number, this.yearOfProduction, this.phone, this.car, this.driverName, this.qr, this.eventId);

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);
}
