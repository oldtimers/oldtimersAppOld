import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/model/competition.dart';

class CompetitionTypeConverter extends TypeConverter<CompetitionType, String> {
  static Map<String, CompetitionType> mappings = CompetitionType.values.asNameMap();

  @override
  CompetitionType decode(String databaseValue) {
    return mappings[databaseValue]!;
  }

  @override
  String encode(CompetitionType value) {
    return value.name;
  }
}
