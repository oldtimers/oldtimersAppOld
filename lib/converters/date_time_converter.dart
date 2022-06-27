import 'package:floor/floor.dart';

class DateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) {
    if (databaseValue != null) {
      return DateTime.fromMillisecondsSinceEpoch(databaseValue);
    } else {
      return null;
    }
  }

  @override
  int? encode(DateTime? value) {
    if (value != null) {
      return value.millisecondsSinceEpoch;
    } else {
      return null;
    }
  }
}
