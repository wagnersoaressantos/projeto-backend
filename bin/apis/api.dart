// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:shelf/shelf.dart';

import '../infra/dependency_injector/dependency_injector.dart';
import '../infra/security/security_service.dart';

abstract class Api {
  Handler getHandler({
    List<Middleware>? middleware,
    bool isSecurity = false,
  });

  Handler createHandler({
    required Handler router,
    List<Middleware>? middleware,
    bool isSecurity = false,
  }) {
    middleware ??= [];

    if (isSecurity) {
      var _securityService = DependencyInjector().get<SecurityService>();
      middleware.addAll([
        _securityService.authorization,
        _securityService.verifyJWT,
      ]);
    }

    var pipe = Pipeline();
    for (var m in middleware) {
      pipe = pipe.addMiddleware(m);
    }
    return pipe.addHandler(router);
  }
}
