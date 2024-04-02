import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/noticia_model.dart';
import '../services/generic_service.dart';

class BlogApi {
  // trabalha com interface e injeta uma class concreta que vai implementar a interface
  final GenericService<NoticiaModel> _service;

  BlogApi(this._service);

  Handler get handler {
    Router router = Router();

    router.get('/blog/noticias', (Request req) {
      List<NoticiaModel> noticias = _service.findAll();
      List<Map> noticiaMap = noticias.map((e) => e.toJson()).toList();
      return Response.ok(
        jsonEncode(noticiaMap),
      );
    });

    router.post('/blog/noticias', (Request req) async {
      var body = await req.readAsString();
      _service.save(NoticiaModel.fromJSON(jsonDecode(body)));
      return Response(201);
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
