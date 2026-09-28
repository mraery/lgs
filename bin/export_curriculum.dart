import 'dart:convert';
import 'dart:io';
import '../lib/data/lgs_units.dart';

void main() {
  final dir = Directory('curriculum');
  if (!dir.existsSync()) dir.createSync(recursive: true);

  for (final unit in lgsUnits) {
    final file = File('curriculum/${unit.id}.json');
    file.writeAsStringSync(jsonEncode(unit.toJson()));
  }
  print('Exported ${lgsUnits.length} LGS units to curriculum/*.json');
}
