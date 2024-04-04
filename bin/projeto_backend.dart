// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:shelf/shelf.dart';

import 'apis/blog_api.dart';
import 'apis/login_api.dart';
import 'infra/custom_server.dart';
import 'infra/dependency_injector/dependency_injector.dart';
import 'infra/middleware_interception.dart';
import 'infra/security/security_service.dart';
import 'infra/security/security_service_imp.dart';
import 'services/noticia_service.dart';
// import 'utils/custom_env.dart';

void main() async {
  // CustomEnv.fromFile('.env.dev');
  final dotEnv = DotEnv(filePath: '.env');

  final _di = DependencyInjector();
  _di.register<SecurityService>(() => SecurityServiceImp(), isSingleton: true);

  var _securityService = _di.get<SecurityService>();

  var cascadeHandler =
      //injeta a class concreta
      Cascade()
          .add(
            LoginApi(_securityService).getHandler(),
          )
          .add(BlogApi(NoticiaService()).getHandler(middleware: [
            _securityService.authorization,
            _securityService.verifyJWT,
          ]))
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
