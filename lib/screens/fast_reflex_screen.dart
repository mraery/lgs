import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson_models.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';

class ReflexQuestion {
  final String prompt;
  final String triggerWord;
  final String correctAnswer;
  final List<String> wrongOptions;
  final String memoryCode;
  final String subject;

  const ReflexQuestion({
    required this.prompt,
    required this.triggerWord,
    required this.correctAnswer,
    required this.wrongOptions,
    required this.memoryCode,
    required this.subject,
  });
}

final List<ReflexQuestion> lgsReflexBank = [
  const ReflexQuestion(
    prompt: "DNA molekülünde organik baz eşleşmeleri kuralı nedir?",
    triggerWord: "A - T / G - C",
    correctAnswer: "Adenin karşısına Timin, Guanin karşısına Sitozin gelir",
    wrongOptions: [
      "Adenin karşısına Guanin, Timin karşısına Sitozin",
      "Adenin karşısına Urasil, Guanin karşısına Timin",
      "Tüm bazlar birbiriyle rastgele eşleşir"
    ],
    memoryCode: "Şifre: At / Galatasaray! (A=T, G=C)!",
    subject: "LGS Fen Bilimleri",
  ),
  const ReflexQuestion(
    prompt: "Mevsimlerin oluşmasının iki temel sebebi nedir?",
    triggerWord: "Mevsimler Şifresi",
    correctAnswer: "23°27' Eksen Eğikliği ve Dünya'nın Güneş Etrafında Dolanması",
    wrongOptions: [
      "Dünya'nın Güneş'e olan uzaklığının değişmesi",
      "Dünya'nın kendi ekseni etrafında dönmesi",
      "Ay'ın evreleri ve gelgit olayları"
    ],
    memoryCode: "Güneş'e olan mesafe mevsim yapmaz! Eksen eğikliği ve dolanma yapar!",
    subject: "LGS Fen Bilimleri",
  ),
  const ReflexQuestion(
    prompt: "Katı basıncını artıran iki durum nedir?",
    triggerWord: "Katı Basıncı: P = G / S",
    correctAnswer: "Ağırlığı artırmak veya Yüzey alanını küçültmek",
    wrongOptions: [
      "Yüzey alanını büyütmek",
      "Ağırlığı azaltmak",
      "Sıvı yoğunluğunu artırmak"
    ],
    memoryCode: "Bıçak ağzının bilenmesi, çivinin sivri ucu basıncı artırır!",
    subject: "LGS Fen Bilimleri",
  ),
  const ReflexQuestion(
    prompt: "Asitler ve bazların turnusol kağıdına etkisi nedir?",
    triggerWord: "Turnusol Rengi",
    correctAnswer: "Asitler Kırmızıya, Bazlar Maviye çevirir",
    wrongOptions: [
      "Asitler maviye, bazlar kırmızıya",
      "Her ikisi de yeşile çevirir",
      "Asitler sarıya, bazlar beyaza çevirir"
    ],
    memoryCode: "Şifre: Anne kızartır (asit kırmızı), Baba morartır (baz mavi)!",
    subject: "LGS Fen Bilimleri",
  ),
  const ReflexQuestion(
    prompt: "Sıfat-fiil (ortaç) ekleri tekerlemesi nedir?",
    triggerWord: "Sıfat-Fiil Ekleri",
    correctAnswer: "-an, -ası, -mez, -ar, -dik, -ecek, -miş",
    wrongOptions: [
      "-ma, -ış, -mak",
      "-ken, -alı, -madan, -ince",
      "-dı, -di, -du, -dü"
    ],
    memoryCode: "Şifre: An-ası-mez-ar-dik-ecek-miş!",
    subject: "LGS Türkçe",
  ),
  const ReflexQuestion(
    prompt: "İsim-fiil (mastar) ekleri şifresi nedir?",
    triggerWord: "İsim-Fiil Ekleri",
    correctAnswer: "-ma, -ış, -mak",
    wrongOptions: [
      "-an, -ası, -mez",
      "-ken, -ip, -erek",
      "-sa, -se, -meli"
    ],
    memoryCode: "Şifre: MA-YIŞ-MAK!",
    subject: "LGS Türkçe",
  ),
  const ReflexQuestion(
    prompt: "Cümlenin ögelerini bulurken ilk hangi iki öge sırasıyla bulunur?",
    triggerWord: "Öge Bulma Sırası",
    correctAnswer: "Önce Yüklem, ardından Özne (Y-Ö)",
    wrongOptions: [
      "Önce Nesne, sonra Yüklem",
      "Önce Zarf Tümleci, sonra Dolaylı Tümleç",
      "Önce Özne, sonra Nesne"
    ],
    memoryCode: "Kural: Önce YÜKLEM bulunur, sonra yükleme 'Kim/Ne?' sorularak ÖZNE bulunur!",
    subject: "LGS Türkçe",
  ),
  const ReflexQuestion(
    prompt: "Kurtuluş Savaşı'nın amacı, gerekçesi ve yöntemi ilk nerede ilan edilmiştir?",
    triggerWord: "Amaç - Gerekçe - Yöntem",
    correctAnswer: "Amasya Genelgesi (22 Haziran 1919)",
    wrongOptions: [
      "Havza Genelgesi",
      "Erzurum Kongresi",
      "Misak-ı Milli"
    ],
    memoryCode: "'Milletin bağımsızlığını yine milletin azim ve kararı kurtaracaktır'!",
    subject: "LGS T.C. İnkılap Tarihi",
  ),
  const ReflexQuestion(
    prompt: "Manda ve himaye ilk kez nerede kesin olarak reddedilmiştir?",
    triggerWord: "Manda ve Himaye Reddi",
    correctAnswer: "İlk kez Erzurum'da, kesin olarak Sivas Kongresi'nde",
    wrongOptions: [
      "Amasya Görüşmeleri'nde",
      "Lozan Barış Konferansı'nda",
      "TBMM'nin açılışında"
    ],
    memoryCode: "İlk ret: Erzurum Kongresi / Kesin ret: Sivas Kongresi!",
    subject: "LGS T.C. İnkılap Tarihi",
  ),
  const ReflexQuestion(
    prompt: "İki basamaklı en küçük asal sayı kaçtır?",
    triggerWord: "İlk İki Basamaklı Asal",
    correctAnswer: "11 Sayısı",
    wrongOptions: [
      "10 Sayısı",
      "13 Sayısı",
      "9 Sayısı"
    ],
    memoryCode: "En küçük asal 2'dir; ilk iki basamaklı asal 11'dir!",
    subject: "LGS Matematik",
  ),
  const ReflexQuestion(
    prompt: "Aralarında asal iki sayının EBOB'u ve EKOK'u nedir?",
    triggerWord: "Aralarında Asal EBOB-EKOK",
    correctAnswer: "EBOB = 1 / EKOK = İki sayının çarpımı",
    wrongOptions: [
      "EBOB = Çarpımları / EKOK = 1",
      "EBOB = 0 / EKOK = Toplamları",
      "EBOB ve EKOK her zaman eşittir"
    ],
    memoryCode: "Aralarında asal sayıların EBOB'u 1, EKOK'u çarpımlarıdır!",
    subject: "LGS Matematik",
  ),
  const ReflexQuestion(
    prompt: "Bilimsel gösterimde a x 10ⁿ ifadesinde a katsayısı hangi aralıktadır?",
    triggerWord: "Bilimsel Gösterim Şartı",
    correctAnswer: "1 ≤ |a| < 10",
    wrongOptions: [
      "0 < a < 1",
      "1 < a ≤ 10",
      "0 ≤ a ≤ 9"
    ],
    memoryCode: "Katsayı 1 olabilir ama 10 olamaz: 1 ile 10 arasında olmalıdır!",
    subject: "LGS Matematik",
  ),
  const ReflexQuestion(
    prompt: "Pisagor teoreminde en bilinen dik kenar üçlüleri hangileridir?",
    triggerWord: "Özel Dik Üçgenler",
    correctAnswer: "3-4-5, 5-12-13, 8-15-17, 7-24-25",
    wrongOptions: [
      "2-3-4, 4-5-6, 6-7-8",
      "3-6-9, 4-8-12, 5-10-15",
      "1-2-3, 3-4-7, 5-6-11"
    ],
    memoryCode: "Pisagor şampiyonları: 3-4-5, 5-12-13, 8-15-17, 7-24-25!",
    subject: "LGS Matematik",
  ),
  const ReflexQuestion(
    prompt: "Zekat verilecek nisap miktarı altın olarak ne kadardır ve zekat oranı nedir?",
    triggerWord: "Zekat Nisap & Oran",
    correctAnswer: "80.18 gram altın / 1/40 (%2.5) oran",
    wrongOptions: [
      "50 gram altın / 1/10 (%10) oran",
      "100 gram altın / 1/20 (%5) oran",
      "40 gram altın / 1/5 (%20) oran"
    ],
    memoryCode: "Nisap miktarı malı olan 40'ta 1 (%2.5) zekat verir!",
    subject: "LGS Din Kültürü",
  ),
  const ReflexQuestion(
    prompt: "İngilizce 'Friendship' ünitesinde 'count on' deyimi ne anlama gelir?",
    triggerWord: "Count on somebody",
    correctAnswer: "Birine güvenmek (Rely on / Trust)",
    wrongOptions: [
      "Biriyle tartışmak (Argue)",
      "Birini reddetmek (Refuse)",
      "Birini davet etmek (Invite)"
    ],
    memoryCode: "Count on = Trust = Rely on = Güvenmek!",
    subject: "LGS İngilizce",
  ),
];

class FastReflexScreen extends ConsumerStatefulWidget {
  const FastReflexScreen({super.key});

  @override
  ConsumerState<FastReflexScreen> createState() => _FastReflexScreenState();
}

class _FastReflexScreenState extends ConsumerState<FastReflexScreen> {
  int _score = 0;
  int _combo = 0;
  int _currentIndex = 0;
  int _timeLeft = 7;
  Timer? _timer;
  bool _isAnswered = false;
  int? _selectedOptionIndex;
  late List<ReflexQuestion> _questions;
  late List<String> _currentShuffledOptions;

  @override
  void initState() {
    super.initState();
    _questions = List.from(lgsReflexBank)..shuffle();
    _prepareQuestion();
  }

  void _prepareQuestion() {
    if (_currentIndex >= _questions.length) {
      _questions.shuffle();
      _currentIndex = 0;
    }
    final q = _questions[_currentIndex];
    final allOps = [q.correctAnswer, ...q.wrongOptions];
    allOps.shuffle();
    _currentShuffledOptions = allOps;
    _isAnswered = false;
    _selectedOptionIndex = null;
    _timeLeft = 7;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeLeft > 1) {
          _timeLeft--;
        } else {
          _onTimeOut();
        }
      });
    });
  }

  void _onTimeOut() {
    _timer?.cancel();
    _isAnswered = true;
    _combo = 0;
    SoundService.playIncorrect();
    HapticFeedback.heavyImpact();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _currentIndex++;
        _prepareQuestion();
      });
    });
  }

  void _handleAnswer(int optionIndex) {
    if (_isAnswered) return;
    _timer?.cancel();
    _isAnswered = true;
    _selectedOptionIndex = optionIndex;

    final q = _questions[_currentIndex];
    final isCorrect = _currentShuffledOptions[optionIndex] == q.correctAnswer;

    if (isCorrect) {
      _combo++;
      final addedScore = 100 + (_combo * 20) + (_timeLeft * 10);
      _score += addedScore;
      SoundService.playCorrect();
      HapticFeedback.lightImpact();

      // Give XP reward to profile
      try {
        ref.read(userProfileProvider.notifier).completeLesson(
              Lesson(
                id: 'reflex_fast_lgs_${DateTime.now().millisecondsSinceEpoch}',
                title: 'Hızlı Refleks',
                description: 'Görünce Yapıştır Modu',
                questions: const [],
                xpReward: 15,
                gemReward: 3,
              ),
            );
      } catch (_) {}
    } else {
      _combo = 0;
      SoundService.playIncorrect();
      HapticFeedback.mediumImpact();
    }

    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      setState(() {
        _currentIndex++;
        _prepareQuestion();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, color: Color(0xFFF59E0B), size: 24),
            SizedBox(width: 6),
            Text(
              'GÖRÜNCE YAPIŞTIR! ⚡',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF97316).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF97316), width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department_rounded, color: Color(0xFFF59E0B), size: 18),
                const SizedBox(width: 4),
                Text(
                  'x$_combo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Skor ve Zaman Çubuğu
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'Puan: $_score',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _timeLeft <= 2 ? const Color(0xFFEF4444) : const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '$_timeLeft s',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Soru Alanı
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tetikleyici Başlık / Şifre Kartı
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF97316).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            q.subject.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFFFFEDD5),
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            q.triggerWord,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Soru Metni
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Text(
                        q.prompt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Şıklar
                    ...List.generate(_currentShuffledOptions.length, (idx) {
                      final option = _currentShuffledOptions[idx];
                      Color optBg = const Color(0xFF1E293B);
                      Color optBorder = Colors.white.withOpacity(0.12);

                      if (_isAnswered) {
                        if (option == q.correctAnswer) {
                          optBg = const Color(0xFF059669);
                          optBorder = const Color(0xFF10B981);
                        } else if (_selectedOptionIndex == idx) {
                          optBg = const Color(0xFFDC2626);
                          optBorder = const Color(0xFFEF4444);
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _handleAnswer(idx),
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: optBg,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: optBorder, width: 1.5),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      String.fromCharCode(65 + idx),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    if (_isAnswered) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF97316).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF97316).withOpacity(0.4)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded, color: Color(0xFFFBBF24), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                q.memoryCode,
                                style: const TextStyle(
                                  color: Color(0xFFFFEDD5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
