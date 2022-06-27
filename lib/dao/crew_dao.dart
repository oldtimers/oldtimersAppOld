import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/model/crew.dart';

@dao
abstract class CrewDao {
  @Query('select * from Crew where eventId = :eventId order by number')
  Future<List<Crew>> findCompetitionsByEvent(int eventId);

  @insert
  Future<void> insertCompetitions(List<Crew> crews);

  @delete
  Future<void> deleteCompetitions(List<Crew> crews);
}
