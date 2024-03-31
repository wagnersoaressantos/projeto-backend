import 'package:dart_dotenv/dart_dotenv.dart';
import 'package:shelf/shelf.dart';

import 'apis/blog_api.dart';
import 'apis/login_api.dart';
import 'infra/custom_server.dart';
import 'utils/custom_env.dart';

void main() async {
  // CustomEnv.fromFile('.env.dev');
  final dotEnv = DotEnv(filePath: '.env');

  var cascadeHandler =
      Cascade().add(LoginApi().handler).add(BlogApi().handler).handler;
  var handler =
      Pipeline().addMiddleware(logRequests()).addHandler(cascadeHandler);

  await CustomServer().initialize(
      handler: handler,
      address: dotEnv.get('server_address') ?? 'localhost',
      port: int.parse(dotEnv.get('server_port') ?? '8080')
      // address: await CustomEnv.get<String>(key: 'server_address'),
      // address: 'localhost',
      // port: await CustomEnv.get<int>(key: 'server_port'),
      );
}
