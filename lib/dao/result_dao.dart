import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/model/result.dart';

@dao
abstract class ResultDao {
  @Query('select * from Result where eventId = :eventId and userId = :userId and type = :type')
  Future<List<Result>> findByEventAndUser(int eventId, int userId, int type);

  @Query('select * from Result where id = :id')
  Future<Result?> findById(int id);

  @insert
  Future<int> insertResult(Result result);

  @delete
  Future<void> deleteResult(Result result);

  @delete
  Future<void> deleteResults(List<Result> results);
}
