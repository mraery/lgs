import 'package:flutter_test/flutter_test.dart';
import 'package:lgs_quest/models/lesson_models.dart';
import 'package:lgs_quest/models/exam_config.dart';
import 'package:lgs_quest/data/mock_lessons.dart';

void main() {
  group('LGS Quest MEB Sınav Sistemi ve Müfredat Testleri', () {
    test('MEB Liselere Geçiş Sistemi (LGS) resmi net hesaplama kuralı (3Y = -1D)', () {
      final config = ExamConfig.fromFranchise(ExamFranchise.lgs);
      expect(config.officialBody, equals('MEB'));
      expect(config.penaltyRatio, equals(3));
      expect(config.penaltyRuleText.contains('3 Yanlış 1 Doğru'), isTrue);

      // Net formülü doğrulaması
      expect(config.calculateNet(15, 3), equals(14.0));
      expect(config.calculateNet(10, 6), equals(8.0));
      expect(config.calculateNet(2, 6), equals(0.0)); // 0'ın altına inmez
      expect(config.calculateNet(20, 0), equals(20.0));
    });

    test('LGS Quest 62 ünite, 434 ders ve 30.000+ sorudan oluşur', () {
      expect(mockUnits.length, equals(62));
      final totalLessons = mockUnits.expand((u) => u.lessons).length;
      final totalQuestions = mockUnits.expand((u) => u.lessons).expand((l) => l.questions).length;

      expect(totalLessons, equals(434));
      expect(totalQuestions, greaterThanOrEqualTo(30000));
    });

    test('Her ünitede en az 7 ders bulunur, ilk soru kavram kartıdır ve son ders kupa sınavıdır', () {
      for (final unit in mockUnits) {
        expect(unit.lessons.length, greaterThanOrEqualTo(7));
        expect(unit.lessons.last.isUnitExam, isTrue, reason: '${unit.title} son dersi kupa sınavı olmalı');

        for (final lesson in unit.lessons) {
          expect(lesson.questions.length, greaterThanOrEqualTo(75),
              reason: '${lesson.title} (${lesson.id}) dersinde ${lesson.questions.length} soru var');
          if (!lesson.isUnitExam) {
            expect(lesson.questions.first.type, equals(QuestionType.conceptCard),
                reason: '${lesson.title} ilk adımı kavram kartı olmalı');
          }
        }
      }
    });

    test('LGS branş dağılımı MEB 8. sınıf kazanımlarını tam kapsar', () {
      final subjects = mockUnits.map((u) => u.subject).toSet();
      expect(subjects.contains('LGS Matematik'), isTrue);
      expect(subjects.contains('LGS Fen Bilimleri'), isTrue);
      expect(subjects.contains('LGS Türkçe'), isTrue);
      expect(subjects.contains('LGS İnkılap Tarihi'), isTrue);
      expect(subjects.contains('LGS Din Kültürü'), isTrue);
      expect(subjects.contains('LGS İngilizce'), isTrue);
    });
  });
}
