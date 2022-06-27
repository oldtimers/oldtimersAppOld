import 'package:floor/floor.dart';

import '../model/competition_field.dart';

class FieldTypeConverter extends TypeConverter<FieldType, String> {
  static Map<String, FieldType> mappings = FieldType.values.asNameMap();

  @override
  FieldType decode(String databaseValue) {
    return mappings[databaseValue]!;
  }

  @override
  String encode(FieldType value) {
    return value.name;
  }
}
