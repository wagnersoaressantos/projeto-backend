// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:mysql1/mysql1.dart';

import '../../utils/custom_env.dart';
import 'db_configuration.dart';

class MySqlDBConfiguration extends DBConfiguration {
  final dotEnv = DotEnv(filePath: '.env');
  MySqlConnection? _connection;
  @override
  Future<MySqlConnection> get connection async {
    // ignore: prefer_conditional_assignment
    if (_connection == null) {
      _connection = await createConnection();
    }
    if (_connection == null)
      throw Exception('[ERROR/DB] -> Failed Create Connection');
    return _connection!;
  }

  @override
  Future<MySqlConnection> createConnection() async =>
      await MySqlConnection.connect(ConnectionSettings(
        host: dotEnv.get('db_host') ?? 'localhost',
        port: await CustomEnv.get<int>(key: 'db_port'),
        user: dotEnv.get('db_user') ?? 'dart_user',
        password: dotEnv.get('db_password') ?? 'dart_pass',
        db: await CustomEnv.get<String>(key: 'db_schema'),
        // host: 'localhost',
        // port: 3306,
        // user: 'dart_user',
        // password: 'dart_pass',
        // db: 'dart',
        // host: await CustomEnv.get<String>(key: 'db_host'),
        // user: await CustomEnv.get<String>(key: 'db_user'),
        // password: await CustomEnv.get<String>(key: 'db_password'),
      ));
}
