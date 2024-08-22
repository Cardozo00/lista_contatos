import 'package:lista_contato/model/contatos_model.dart';
import 'package:lista_contato/repository/custon_back4app.dart';

class Back4app {
  final _dio = CustonBack4app();

  Back4app();

  Future<ContatosModel> obterDados() async {
    var url = '/Contatos';
    var resultado = await _dio.custonDio.get(url);
    return ContatosModel.fromJson(resultado.data);
  }

  Future<void> adicionarDados(Contatos contatosModel) async {
    try {
      await _dio.custonDio
          .post("/Contatos", data: contatosModel.toJsonEndPoint());
    } catch (e) {
      throw e;
    }
  }

  Future<void> removerDados(String id) async {
    try {
      await _dio.custonDio.delete("/Contatos/$id");
    } catch (e) {
      throw e;
    }
  }
}
