import '../models/lesson_models.dart';
import '../models/exam_config.dart';
import 'lgs_units.dart';

export 'lgs_units.dart';

/// LGS Quest Resmi MEB 8. Sınıf Müfredatı
final List<LearningUnit> mockUnits = lgsUnits;

/// Aktif Quest sınavına göre müfredat ünitelerini döndürür
List<LearningUnit> getUnitsForExam(ExamFranchise franchise) {
  return lgsUnits;
}
