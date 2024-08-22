class ContatosModel {
  List<Contatos> contatos = [];

  ContatosModel(this.contatos);

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contatos = <Contatos>[];
      json['results'].forEach((v) {
        contatos.add(Contatos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['results'] = contatos.map((v) => v.toJson()).toList();

    return data;
  }
}

class Contatos {
  String objectId = "";
  String imagem = "";
  String nome = "";
  String sobreNome = "";
  String numero = "";
  String createdAt = "";
  String updatedAt = "";

  Contatos(this.objectId, this.imagem, this.nome, this.sobreNome, this.numero,
      this.createdAt, this.updatedAt);

  Contatos.criar(this.imagem, this.nome, this.sobreNome, this.numero);

  Contatos.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    imagem = json['Imagem'];
    nome = json['Nome'];
    sobreNome = json['sobrenome'];
    numero = json['Numero'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['Imagem'] = imagem;
    data['Nome'] = nome;
    data['sobrenome'] = sobreNome;
    data['Numero'] = numero;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonEndPoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Imagem'] = imagem;
    data['Nome'] = nome;
    data['sobrenome'] = sobreNome;
    data['Numero'] = numero;
    return data;
  }
}
