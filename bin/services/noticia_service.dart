import '../models/noticia_model.dart';
import 'generic_service.dart';

import '../utils/list_extansion.dart';

class NoticiaService implements GenericService<NoticiaModel> {
  final List<NoticiaModel> _fakeBD = [];

  @override
  bool delete(int id) {
    _fakeBD.removeWhere((e) => e.id == id);
    return true;
  }

  @override
  List<NoticiaModel> findAll() {
    return _fakeBD;
  }

  @override
  NoticiaModel findOne(int id) {
    return _fakeBD.firstWhere((e) => e.id == id);
  }

  @override
  bool save(NoticiaModel value) {
    NoticiaModel? model = _fakeBD.firstWhereOnNull(
      (e) => e.id == value.id,
    );
    if (model == null) {
      _fakeBD.add(value);
    } else {
      var index = _fakeBD.indexOf(model);
      _fakeBD[index] = value;
    }

    return true;
  }
}
