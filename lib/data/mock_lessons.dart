import '../models/lesson_models.dart';
import '../models/exam_config.dart';
import 'lgs_units.dart';
import 'lgs_question_bank_builder.dart';

export 'lgs_streaming_units.dart';

/// LGS Quest Resmi MEB 8. Sınıf Müfredatı (30.000+ Soru)
final List<LearningUnit> mockUnits = expandUnitsWithQuestionBank(lgsUnits);

List<LearningUnit> getUnitsForExam(ExamFranchise franchise) {
  return mockUnits;
}
