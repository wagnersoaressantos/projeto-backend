import 'dart:io';
import 'parser_extension.dart';

class CustomEnv {
  static Map<String, String> _map = {};
  static String _file = '.env';

  CustomEnv._();

  factory CustomEnv.fromFile(String file) {
    _file = file;
    return CustomEnv._();
  }

  static Future<T> get<T>({required String key}) async {
    if (_map.isEmpty) await _load();
    var result = _map[key]!.toType(T);
    return result;
  }

  static Future<void> _load() async {
    List<String> linhas = (await _readFile()).split('\n');
    // ..removeWhere((element) => element.isEmpty);
    _map = {for (var l in linhas) l.split('=')[0]: l.split('=')[1]};
  }
  //_map = {for (var l in linhas) l.split('=')[0]: l.split('=')[1]}; é iqual {'chave':'valor'}

  static Future<String> _readFile() async {
    return await File(_file).readAsString();
  }
}
