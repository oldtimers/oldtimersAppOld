import 'package:json_annotation/json_annotation.dart';
import 'package:oldtimers_rally_app/model/competition_field.dart';

part 'competition.g.dart';

@JsonSerializable()
class Competition {
  final int id;
  final String name;
  final String description;
  final String type;
  final double? averageSpeed;
  final List<CompetitionField> fields;

  factory Competition.fromJson(Map<String, dynamic> json) {
    var res = _$CompetitionFromJson(json);
    res.fields.sort((a, b) => a.order.compareTo(b.order));
    return res;
  }

  Competition(this.id, this.name, this.description, this.type, this.averageSpeed, this.fields);
}

enum CompetitionType { REGULAR_DRIVE, BEST_MIN, BEST_MAX, COUNTED }
