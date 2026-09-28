import '../models/lesson_models.dart';
import '../models/exam_config.dart';
import 'lgs_streaming_units.dart';

export 'lgs_streaming_units.dart';

/// LGS Quest Resmi Mufredati
final List<LearningUnit> mockUnits = lgsStreamingUnits;

List<LearningUnit> getUnitsForExam(ExamFranchise franchise) {
  return lgsStreamingUnits;
}
