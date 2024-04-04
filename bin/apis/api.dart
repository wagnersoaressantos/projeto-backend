// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:shelf/shelf.dart';

import '../infra/dependency_injector/dependency_injector.dart';
import '../infra/security/security_service.dart';

abstract class Api {
  Handler getHandler({List<Middleware>? middleware});

  Handler createHandler({
    required Handler router,
    List<Middleware>? middleware,
  }) {
    final _di = DependencyInjector();

    var _securityService = _di.get<SecurityService>();
    middleware ??= [];

    var pipe = Pipeline();
    for (var m in middleware) {
      pipe = pipe.addMiddleware(m);
    }

    return pipe.addHandler(router);
  }
}
