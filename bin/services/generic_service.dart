abstract class GenericService<T> {
//devove um unico objeto a partir de um id
  T findOne(int id);
//devove uma lista
  List<T> findAll();
//salva o objeto generico T e retorna um booleano
  bool save(T value);
//deleta o objeto generico T e retorna um booleano
  bool delete(int id);
}
