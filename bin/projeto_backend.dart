// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:shelf/shelf.dart';
import 'apis/blog_api.dart';
import 'apis/login_api.dart';
import 'infra/custom_server.dart';
import 'infra/database/mysql_db_configuration.dart';
import 'infra/dependency_injector/injects.dart';
import 'infra/middleware_interception.dart';
import 'utils/custom_env.dart';

void main() async {
  CustomEnv.fromFile('.env');
  final dotEnv = DotEnv(filePath: '.env');

  var conexao = await MySqlDBConfiguration().connection;

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
