import 'package:json_annotation/json_annotation.dart';

part 'crew.g.dart';

@JsonSerializable()
class Crew {
  final int id;
  final int number;
  final int yearOfProduction;
  final String phone;
  final String car;
  final String driverName;

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);

  Crew(this.id, this.number, this.yearOfProduction, this.phone, this.car, this.driverName);
}
