import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/model/result.dart';

@dao
abstract class ResultDao {
  @Query('select * from Result where eventId = :eventId and userId = :userId')
  Future<List<Result>> findByEventAndUser(int eventId, int userId);

  @insert
  Future<void> insertResult(Result result);

  @delete
  Future<void> deleteResult(Result result);

  @delete
  Future<void> deleteResults(List<Result> results);
}
