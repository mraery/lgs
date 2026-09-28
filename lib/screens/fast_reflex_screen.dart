import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../services/sound_service.dart';
import '../widgets/duo_button.dart';

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
    prompt: 'Mevsimlerin oluşmasının iki temel sebebi nedir?',
    triggerWord: 'Eksen Eğikliği & Dolanma',
    correctAnswer: '23° 27\' Eksen Eğikliği ve Dünya\'nın Güneş etrafında dolanması',
    wrongOptions: [
      'Dünya\'nın Güneş\'e olan mesafesinin değişmesi',
      'Dünya\'nın kendi etrafında dönmesi ve Ay çekimi',
      'Güneş lekelerinin patlaması ve okyanus akıntıları'
    ],
    memoryCode: 'Güneş\'e yakınlık mevsim yapmaz! Eksen eğikliği güneş ışınlarının geliş açısını belirler.',
    subject: 'LGS Fen Bilimleri',
  ),
  const ReflexQuestion(
    prompt: 'DNA molekülünde organik baz eşleşme kuralı?',
    triggerWord: 'A-T ve G-C',
    correctAnswer: 'Adenin karşısına Timin (2\'li bağ), Guanin karşısına Sitozin (3\'lü bağ)',
    wrongOptions: [
      'Adenin karşısına Guanin, Timin karşısına Sitozin',
      'Adenin karşısına Urasil, Timin karşısına Guanin',
      'Sitozin karşısına Timin, Guanin karşısına Adenin'
    ],
    memoryCode: 'Şifre: AtatürK - GalataSaray (A-T ikili, G-S üçlü hidrojen bağı)!',
    subject: 'LGS Fen Bilimleri',
  ),
  const ReflexQuestion(
    prompt: 'Aralarında Asal sayıların EBOB\'u kaçtır?',
    triggerWord: 'Aralarında Asal EBOB',
    correctAnswer: 'Daima 1',
    wrongOptions: ['Daima 0', 'Sayıların Çarpımı', 'Küçük olan sayı'],
    memoryCode: 'Ortak böleni sadece 1 olan sayılar aralarında asaldır. Örn: (8 ile 9)',
    subject: 'LGS Matematik',
  ),
  const ReflexQuestion(
    prompt: 'Mustafa Kemal\'in ilk askeri başarısı hangi savaştır?',
    triggerWord: 'Trablusgarp Savaşı (1911)',
    correctAnswer: 'Trablusgarp Savaşı (Derne ve Tobruk Zaferleri)',
    wrongOptions: [
      'Çanakkale Savaşı (Anafartalar)',
      'Balkan Savaşları',
      'Sakarya Meydan Muharebesi'
    ],
    memoryCode: 'Tüccar / Gazeteci Şerif Bey takma adıyla gitmiş, halkı örgütleyip İtalyanları durdurmuştur.',
    subject: 'LGS İnkılap Tarihi',
  ),
  const ReflexQuestion(
    prompt: 'Sıfat-Fiil (Ortaç) ekleri tekerlemesi?',
    triggerWord: 'Anası Mezar Dikecekmiş',
    correctAnswer: '-an, -ası, -mez, -ar, -dik, -ecek, -miş',
    wrongOptions: [
      '-ken, -alı, -esi, -meden, -ince, -ip, -arak',
      '-ma, -ış, -mak',
      '-ce, -ceğiz, -dir, -miş'
    ],
    memoryCode: 'Şifre: An-ası mez-ar dik-ecek-miş! (Cümlede sıfat görevi üstlenir)',
    subject: 'LGS Türkçe',
  ),
  const ReflexQuestion(
    prompt: 'Kuvvetten kazanç varsa yoldan ne olur?',
    triggerWord: 'Basit Makineler Prensibi',
    correctAnswer: 'Yoldan aynı oranda kayıp olur (İşten kazanç asla YOKTUR)',
    wrongOptions: [
      'Yoldan da kazanç olur',
      'İşten ve enerjiden %50 tasarruf sağlanır',
      'Kuvvet daima yolun karesine eşittir'
    ],
    memoryCode: 'Altın kural: Hiçbir basit makinede İŞTEN veya ENERJİDEN kazanç sağlanamaz!',
    subject: 'LGS Fen Bilimleri',
  ),
];


class FastReflexScreen extends ConsumerStatefulWidget {
  const FastReflexScreen({super.key});

  @override
  ConsumerState<FastReflexScreen> createState() => _FastReflexScreenState();
}

class _FastReflexScreenState extends ConsumerState<FastReflexScreen>
    with SingleTickerProviderStateMixin {
  late List<ReflexQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int _combo = 0;
  int _maxCombo = 0;
  bool _isAnswered = false;
  String? _selectedOption;
  bool _isCorrect = false;

  Timer? _countdownTimer;
  double _timeLeft = 10.0;
  static const double _maxTime = 10.0;

  late List<String> _currentShuffledOptions;

  @override
  void initState() {
    super.initState();
    _questions = List.from(lgsReflexBank)..shuffle();
    _setupCurrentQuestion();
  }

  void _setupCurrentQuestion() {
    final q = _questions[_currentIndex];
    final allOpts = [q.correctAnswer, ...q.wrongOptions];
    allOpts.shuffle();
    _currentShuffledOptions = allOpts;
    _isAnswered = false;
    _selectedOption = null;
    _timeLeft = _maxTime;

    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _timeLeft -= 0.1;
        if (_timeLeft <= 0.0) {
          _timeLeft = 0.0;
          _onTimeUp();
        }
      });
    });
  }

  void _onTimeUp() {
    _countdownTimer?.cancel();
    if (_isAnswered) return;

    SoundService.playIncorrect();
    HapticFeedback.heavyImpact();

    setState(() {
      _isAnswered = true;
      _isCorrect = false;
      _combo = 0;
    });
  }

  void _handleOptionSelect(String option) {
    if (_isAnswered) return;
    _countdownTimer?.cancel();

    final q = _questions[_currentIndex];
    final bool correct = (option == q.correctAnswer);

    setState(() {
      _isAnswered = true;
      _selectedOption = option;
      _isCorrect = correct;

      if (correct) {
        _combo++;
        if (_combo > _maxCombo) _maxCombo = _combo;
        final speedBonus = (_timeLeft * 10).toInt();
        _score += 100 + speedBonus + (_combo * 15);
        SoundService.playCorrect();
        HapticFeedback.mediumImpact();
      } else {
        _combo = 0;
        SoundService.playIncorrect();
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _setupCurrentQuestion();
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    ref.read(userProfileProvider.notifier).gainHeart();
    ref.read(userProfileProvider.notifier).addGems(15);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Tebrikler! ⚡', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bolt_rounded, size: 64, color: Color(0xFFFF9600)),
            const SizedBox(height: 12),
            Text('Toplam Skor: $_score Puan', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('Maksimum Kombo: $_maxCombo x 🔥', style: const TextStyle(fontSize: 15, color: Color(0xFFEF4444), fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          DuoButton(
            text: 'KAPAT & ÖDÜLÜ AL',
            color: DuoButtonColor.green,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bolt_rounded, color: Color(0xFFFF9600), size: 24),
            const SizedBox(width: 4),
            Text('$_score', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(width: 16),
            if (_combo > 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(12)),
                child: Text('$_combo x COMBO 🔥', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
              ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${_currentIndex + 1}/${_questions.length}', style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w700)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: _timeLeft / _maxTime,
                  backgroundColor: const Color(0xFF334155),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _timeLeft > 3.0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF6366F1).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text(q.subject, style: const TextStyle(color: Color(0xFF818CF8), fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(height: 12),
                    Text(q.prompt, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, height: 1.3)),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: const Color(0xFFFF9600).withOpacity(0.12), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFF9600).withOpacity(0.4))),
                      child: Row(
                        children: [
                          const Icon(Icons.key_rounded, color: Color(0xFFFF9600), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(q.triggerWord, style: const TextStyle(color: Color(0xFFFFB020), fontSize: 14, fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ..._currentShuffledOptions.map((opt) {
                Color btnBg = const Color(0xFF1E293B);
                Color borderC = const Color(0xFF334155);
                Color textC = Colors.white;

                if (_isAnswered) {
                  if (opt == q.correctAnswer) {
                    btnBg = const Color(0xFF065F46);
                    borderC = const Color(0xFF10B981);
                  } else if (opt == _selectedOption) {
                    btnBg = const Color(0xFF7F1D1D);
                    borderC = const Color(0xFFEF4444);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _handleOptionSelect(opt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      decoration: BoxDecoration(
                        color: btnBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderC, width: 2),
                      ),
                      child: Text(opt, style: TextStyle(color: textC, fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                );
              }).toList(),
              const Spacer(),
              if (_isAnswered)
                DuoButton(
                  text: _currentIndex < _questions.length - 1 ? 'SONRAKİ REFLEKS ⚡' : 'SONUÇLARI GÖR 🏆',
                  color: _isCorrect ? DuoButtonColor.green : DuoButtonColor.gray,
                  onPressed: _nextQuestion,
                )
              else
                const SizedBox(height: 52),
            ],
          ),
        ),
      ),
    );
  }
}
