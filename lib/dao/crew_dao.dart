import 'package:floor/floor.dart';
import 'package:oldtimers_rally_app/model/crew.dart';

@dao
abstract class CrewDao {
  @Query('select * from Crew where eventId = :eventId order by number')
  Future<List<Crew>> findCrewsByEvent(int eventId);

  @Query('select * from Crew where qr = :qr and eventId = :eventId')
  Future<Crew?> findCrewByQr(String qr, int eventId);

  @insert
  Future<void> insertCrews(List<Crew> crews);

  @delete
  Future<void> deleteCrews(List<Crew> crews);
}
