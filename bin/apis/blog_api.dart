import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/generic_service.dart';

class BlogApi {
  // trabalha com interface e injeta uma class concreta que vai implementar a interface
  final GenericService _service;

  BlogApi(this._service);

  Handler get handler {
    Router router = Router();

    router.get('/blog/noticias', (Request req) {
      // _service.findAll();
      return Response.ok('Choveu hoje');
    });

    router.post('/blog/noticias', (Request req) {
      // _service.save("");
      return Response.ok('Choveu hoje');
    });

    router.put('/blog/noticias', (Request req) {
      String? id = req.url.queryParameters['id'];

      // _service.save("");
      return Response.ok('Choveu hoje');
    });

    router.delete('/blog/noticias', (Request req) {
      String? id = req.url.queryParameters['id'];

      // _service.delete();
      return Response.ok('Choveu hoje');
    });

    return router.call;
  }
}
