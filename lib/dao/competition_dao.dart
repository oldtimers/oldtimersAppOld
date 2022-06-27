import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/model/competition.dart';

@dao
abstract class CompetitionDao {
  @Query('select * from Competition where eventId = :eventId order by id')
  Future<List<Competition>> findCompetitionsByEvent(int eventId);

  @insert
  Future<void> insertCompetitions(List<Competition> competitions);

  @delete
  Future<void> deleteCompetitions(List<Competition> competitions);

  @transaction
  Future<void> synchronizeCompetitions(List<Competition> competitions, int eventId) async {
    var old = await findCompetitionsByEvent(eventId);
    await deleteCompetitions(old);
    await insertCompetitions(competitions);
  }
}
