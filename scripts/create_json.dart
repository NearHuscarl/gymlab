// run this script:
// flutter test scripts/create_json.dart
// https://stackoverflow.com/questions/53605763/run-a-dart-file-for-experimenting-vs-code
//
// TODO: convert this script to python. running this script via `flutter test` command is too slow
//
// What it does: Convert the raw data json from the Gym Workout app to the
// compatible json structure of this app

import 'dart:convert';
import 'dart:io';

String lowerCaseFirstChar(String str) =>
    str[0].toLowerCase() + str.substring(1);

String toCamelCase(String str) =>
    lowerCaseFirstChar(str.replaceAllMapped(RegExp('(_| )([a-zA-Z])'), (match) {
      return match
          .group(2)
          .toUpperCase(); // remove the delimiter and uppercase the next char
    }));

bool hasWord(String str, String word) =>
    str.contains(RegExp('\\b$word\\b', caseSensitive: false));

bool hasWords(String str, List<String> words) {
  var wordGroup = '(';

  for (var i = 0; i < words.length; i++) {
    wordGroup += (i < words.length - 1) ? '${words[i]}|' : '${words[i]})';
  }
  return str.contains(RegExp('\\b$wordGroup\\b', caseSensitive: false));
}

List<String> getEquipments(
    String name, String description, List<String> weightTypes, String type) {
  // hardcode equipment-exercise mapping for undectected cases
  final equipments = <String>[];
  final equipmentMap = {
    'none': [],
    'bodyOnly': ['Plank', 'Side Plank'],
    'bands': [],
    'foamRoll': [],
    'barbell': [],
    'ezBar': [],
    'kettleBell': [],
    'dumbbell': [],
    'machine': ['Running'],
    'cable': [],
    'medicineBall': [],
    'exerciseBall': [],
    'bar': [],
    'other': [/*Hyperextension bench*/ 'Hyperextension'],
  };

  if (hasWord(name, 'cable')) {
    equipments.add('cable');
  }
  if (hasWord(name, 'barbell') ||
      (hasWord(name, 'bench') && hasWord(description, 'bar'))) {
    equipments.add('barbell');
  }
  if (hasWord(description, 'pull up bar')) {
    equipments.add('bar');
  }
  if (hasWord(name, 'dumbbell') || hasWord(description, 'dumbbell')) {
    equipments.add('dumbbell');
  }
  if (hasWord(name, 'ez-bar')) {
    equipments.add('ezBar');
  }
  if (hasWord(name, 'machine') || name == 'running') {
    equipments.add('machine');
  }
  if (hasWord(name, 'bodyweight') || type == 'bodyWeight') {
    equipments.add('bodyOnly');
  }
  if (hasWord(name, 'weight') || hasWord(description, 'plate weight')) {
    equipments.add('weightPlate');
  }
  if (hasWord(name, 'stability ball')) {
    equipments.add('exerciseBall');
  }

  final equips = weightTypes.where((type) => type != 'noWeight');
  equipments.addAll(equips);

  equipmentMap.forEach((equipment, exercises) {
    if (exercises.contains(name)) {
      equipments.add(equipment);
    }
  });

  return equipments;
}

Future<void> createJsonData() async {
  final file = File('assets/data/exercises.input.json');

  if (await file.exists()) {
    final jsonStr = await file.readAsString();
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    final resultJson = [];
    var equipmentNotFound = 0;

    jsonMap.forEach((key, info) {
      final name = key;
      final descriptionMap = info['exerciseDescription'];
      final description = descriptionMap['1_Preparation'] == null
          ? descriptionMap['2_Execution']
          : '${descriptionMap['1_Preparation']}\n${descriptionMap['2_Execution']}';
      final muscles = [];
      final type = info['exerciseType'];
      final variationMap = info['exerciseOptionsDic'] ?? {};
      final variation = variationMap.map(
        (key, val) => MapEntry(
          toCamelCase(key),
          val.map((v) => toCamelCase(v)).toList(),
        ),
      );
      final equipments = getEquipments(
        name,
        description,
        (variation['weightType'] as List<dynamic>)?.cast<String>() ??
            <String>[],
        type,
      );

      info['musclesCategoriesArray'].asMap().forEach(
            (index, val) => muscles.add({
              'muscle': toCamelCase(val),
              'target': index == 0 ? 'primary' : 'secondary',
            }),
          );

      print('add exercise ' + name);
      if (equipments.length == 0) equipmentNotFound++;
      resultJson.add({
        'id': info['exerciseID'],
        'name': name,
        'description': description,
        'equipments': equipments,
        'imageCount': info['picturesCount'],
        'thumbnailImageIndex': info['selectedThumbNailImageIndex'],
        'muscles': muscles,
        'type': type,
        'variation': variation,
        'keywords': info['searchKeywordsArray'],
      });
    });

    print(
        'Exercises with equipements not found: $equipmentNotFound/${resultJson.length}');

    await File('assets/data/exercises.json')
        .writeAsString(JsonEncoder.withIndent('  ').convert(resultJson));
  }
}

void main() async {
  await createJsonData();
}
