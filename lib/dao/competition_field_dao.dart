import 'package:floor/floor.dart';

import '../model/competition_field.dart';

@dao
abstract class CompetitionFieldDao {
  @Query('select * from CompetitionField where competitionId = :competitionId order by order_f')
  Future<List<CompetitionField>> findCompetitionFieldsByCompetition(int competitionId);

  @insert
  Future<void> insertCompetitionFields(List<CompetitionField> competitionFields);

  @delete
  Future<void> deleteCompetitionFields(List<CompetitionField> competitionFields);
}
