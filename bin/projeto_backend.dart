// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:shelf/shelf.dart';
import 'package:mysql1/mysql1.dart';
import 'apis/blog_api.dart';
import 'apis/login_api.dart';
import 'infra/custom_server.dart';
import 'infra/dependency_injector/injects.dart';
import 'infra/middleware_interception.dart';
import 'utils/custom_env.dart';

void main() async {
  CustomEnv.fromFile('.env');
  final dotEnv = DotEnv(filePath: '.env');

  var conexao = await MySqlConnection.connect(ConnectionSettings(
    // host: 'localhost',
    // port: 3306,
    // user: 'dart_user',
    // password: 'dart_pass',
    // db: 'dart',
    // host: await CustomEnv.get<String>(key: 'db_host'),
    host: dotEnv.get('db_host') ?? 'localhost',
    port: await CustomEnv.get<int>(key: 'db_port'),
    // user: await CustomEnv.get<String>(key: 'db_user'),
    user: dotEnv.get('db_user') ?? 'dart_user',
    // password: await CustomEnv.get<String>(key: 'db_password'),
    password: dotEnv.get('db_password') ?? 'dart_pass',
    db: await CustomEnv.get<String>(key: 'db_schema'),
  ));

  var result = await conexao.query('select * from usuarios;');
  print(result);

  final _di = Injects.initialize();
  //injeta a class concreta

  var cascadeHandler = Cascade()
      .add(_di.get<LoginApi>().getHandler())
      .add(_di.get<BlogApi>().getHandler(isSecurity: true))
      .handler;

  var handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(MiddlewareInterception().middleware)
      .addHandler(cascadeHandler);

  await CustomServer().initialize(
      handler: handler,
      address: dotEnv.get('server_address') ?? 'localhost',
      port: int.parse(dotEnv.get('server_port') ?? '8080')
      // address: await CustomEnv.get<String>(key: 'server_address'),
      // address: 'localhost',
      // port: await CustomEnv.get<int>(key: 'server_port'),
      );
}
