import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  static Future<void> initialize() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveTVModels(List<TVModel> tvModels) async {
    await initialize();
    List<Map<String, dynamic>> jasonTVModels =
        tvModels.map((tvModel) => tvModel.toJson()).toList();
    await _sharedPrefs!.setString('tvModels', json.encode(jasonTVModels));
  }

  static Future<List<TVModel>> getTVModels() async {
    await initialize();
    final jsonString = _sharedPrefs!.getString('tvModels');
    if (jsonString == null) {
      return [];
    }
    List<dynamic> jasonTVModels = json.decode(jsonString);
    return jasonTVModels.map((json) => TVModel.fromJson(json)).toList();
  }

  static Future<void> addTVModel(TVModel tvModel) async {
    List<TVModel> tvModels = await getTVModels();
    tvModels.add(tvModel);
    await saveTVModels(tvModels);
  }

  static Future<void> removeTVModel(TVModel tvModel) async {
    List<TVModel> tvModels = await getTVModels();
    tvModels.remove(tvModel);
    await saveTVModels(tvModels);
  }
}

class TVModelHandle {
  static TVModel selectedTVModel = TVModel();
}

class TVModel {
  String name;
  Button zero = Button(0);
  Button one = Button(1);
  Button two = Button(2);
  Button three = Button(3);
  Button four = Button(4);
  Button five = Button(5);
  Button six = Button(6);
  Button seven = Button(7);
  Button eight = Button(8);
  Button nine = Button(9);
  Button power = Button(10);
  Button mute = Button(11);
  Button channelUp = Button(12);
  Button channelDown = Button(13);
  Button volumeUp = Button(14);
  Button volumeDown = Button(15);
  Button menu = Button(16);
  Button okay = Button(17);
  Button moveUp = Button(18);
  Button moveDown = Button(19);
  Button moveLeft = Button(20);
  Button moveRight = Button(21);

  TVModel({this.name = ''});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TVModel &&
          runtimeType == other.runtimeType &&
          other.name == name;

  @override
  int get hashCode => name.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'zero': zero.toJson(),
      'one': one.toJson(),
      'two': two.toJson(),
      'three': three.toJson(),
      'four': four.toJson(),
      'five': five.toJson(),
      'six': six.toJson(),
      'seven': seven.toJson(),
      'eight': eight.toJson(),
      'nine': nine.toJson(),
      'power': power.toJson(),
      'mute': mute.toJson(),
      'channelUp': channelUp.toJson(),
      'channelDown': channelDown.toJson(),
      'volumeUp': volumeUp.toJson(),
      'volumeDown': volumeDown.toJson(),
      'menu': menu.toJson(),
      'okay': okay.toJson(),
      'moveUp': moveUp.toJson(),
      'moveDown': moveDown.toJson(),
      'moveLeft': moveLeft.toJson(),
      'moveRight': moveRight.toJson(),
    };
  }

  TVModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        zero = Button.fromJson(json['zero']),
        one = Button.fromJson(json['one']),
        two = Button.fromJson(json['two']),
        three = Button.fromJson(json['three']),
        four = Button.fromJson(json['four']),
        five = Button.fromJson(json['five']),
        six = Button.fromJson(json['six']),
        seven = Button.fromJson(json['seven']),
        eight = Button.fromJson(json['eight']),
        nine = Button.fromJson(json['nine']),
        power = Button.fromJson(json['power']),
        mute = Button.fromJson(json['mute']),
        channelUp = Button.fromJson(json['channelUp']),
        channelDown = Button.fromJson(json['channelDown']),
        volumeUp = Button.fromJson(json['volumeUp']),
        volumeDown = Button.fromJson(json['volumeDown']),
        menu = Button.fromJson(json['menu']),
        okay = Button.fromJson(json['okay']),
        moveUp = Button.fromJson(json['moveUp']),
        moveDown = Button.fromJson(json['moveDown']),
        moveLeft = Button.fromJson(json['moveLeft']),
        moveRight = Button.fromJson(json['moveRight']);
}

class Button {
  final int _id;
  int _irCode = 0;
  Button(this._id);

  int getId() {
    return _id;
  }

  void setIrCode(int irCode) {
    _irCode = irCode;
  }

  int getIrCode() {
    return _irCode;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'irCode': _irCode,
    };
  }

  Button.fromJson(Map<String, dynamic> json)
      : _id = json['id'] as int,
        _irCode = json['irCode'] as int;
}

class HexValidator {
  static String? validate(String? value) {
    if (value != null && value.isNotEmpty) {
      final RegExp hexRegex = RegExp(r'^[0-9A-Fa-f]+$');
      if (!hexRegex.hasMatch(value)) {
        return 'This value ins\'t correct HEX value!';
      }
    }
    return null;
  }
}
