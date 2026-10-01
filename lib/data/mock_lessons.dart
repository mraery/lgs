import '../models/lesson_models.dart';
import '../models/exam_config.dart';
import 'lgs_units.dart';
import 'lgs_question_bank_builder.dart';

export 'lgs_units.dart';

/// LGS Quest Resmi MEB 8. Sınıf Müfredatı (30.000+ Soru)
final List<LearningUnit> mockUnits = expandUnitsWithQuestionBank(lgsUnits);

/// Aktif Quest sınavına göre müfredat ünitelerini döndürür
List<LearningUnit> getUnitsForExam(ExamFranchise franchise) {
  return mockUnits;
}
