import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_contato/model/contatos_model.dart';
import 'package:lista_contato/repository/back4app.dart';
import 'package:lista_contato/repository/imagem_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path1;

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  ImagemRepository imagemRepository = ImagemRepository();
  var back4appRepository = Back4app();
  var back4AppModel = ContatosModel([]);
  var nomeController = TextEditingController(text: "");
  var sobrenomeController = TextEditingController(text: "");
  var numeroController = TextEditingController(text: "");
  var emailController = TextEditingController(text: "");
  XFile? photo;
  final ImagePicker _picker = ImagePicker();
  bool carregando = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    setState(() {
      carregando = true;
    });
    back4AppModel = await back4appRepository.obterDados();

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text("Lista de Contato"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              nomeController.clear();
              sobrenomeController.clear();
              numeroController.clear();
              emailController.clear();
              photo = null;

              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Cancelar",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 22, 101, 165),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Novo Contato",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              carregando = true;
                                            });

                                            back4appRepository.adicionarDados(
                                                Contatos.criar(
                                                    photo?.path ?? "",
                                                    nomeController.text,
                                                    sobrenomeController.text,
                                                    numeroController.text));
                                          }

                                          await carregarDados();
                                          Navigator.pop(context);
                                        },
                                        child: const Text("OK")),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsetsDirectional
                                              .symmetric(vertical: 15),
                                          child: CircleAvatar(
                                              radius: 80,
                                              child: photo?.path != null
                                                  ? ClipOval(
                                                      child: Image.file(
                                                          height: 160,
                                                          width: 160,
                                                          fit: BoxFit.cover,
                                                          File(photo!.path)))
                                                  : const FaIcon(
                                                      FontAwesomeIcons.user,
                                                      size: 90,
                                                    ))),
                                      Container(
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(
                                            vertical: 5, horizontal: 20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color.fromARGB(
                                                255, 217, 217, 217)),
                                        child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (_) {
                                                    return Wrap(
                                                      children: [
                                                        ListTile(
                                                          leading: const FaIcon(
                                                              FontAwesomeIcons
                                                                  .camera),
                                                          title: const Text(
                                                              "Camera"),
                                                          onTap: () async {
                                                            photo = await _picker
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);

                                                            if (photo != null) {
                                                              String path =
                                                                  (await path_provider
                                                                          .getApplicationDocumentsDirectory())
                                                                      .path;
                                                              String name =
                                                                  path1.basename(
                                                                      photo!
                                                                          .name);
                                                              await photo!.saveTo(
                                                                  "$path/$name");
                                                              await GallerySaver
                                                                  .saveImage(
                                                                      photo!
                                                                          .path);

                                                              imagemRepository
                                                                  .cropImage(
                                                                      photo!);
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {});
                                                            }
                                                          },
                                                        ),
                                                        const Divider(),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 20),
                                                          child: ListTile(
                                                            leading: FaIcon(
                                                                FontAwesomeIcons
                                                                    .image),
                                                            title:
                                                                Text("Galeria"),
                                                            onTap: () async {
                                                              photo = await _picker
                                                                  .pickImage(
                                                                      source: ImageSource
                                                                          .gallery);
                                                              setState(() {
                                                                carregando =
                                                                    true;
                                                              });
                                                              imagemRepository
                                                                  .cropImage(
                                                                      photo!);
                                                              // await carregarDados();
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: const Text(
                                              "Adicionar Foto",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: TextFormField(
                                            controller: nomeController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Campo Obrigatorio';
                                              }
                                              return null;
                                            },
                                            // onChanged: (value) {
                                            //   nomeController.text = value;
                                            // },
                                            decoration: const InputDecoration(
                                                hintText: "Nome",
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedBorder:
                                                    InputBorder.none),
                                          ),
                                        ),
                                        const Divider(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: TextField(
                                            controller: sobrenomeController,
                                            decoration: const InputDecoration(
                                                hintText: "Sobrenome",
                                                enabledBorder: InputBorder.none,
                                                focusedBorder:
                                                    InputBorder.none),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 80,
                                            child: const Text(
                                              "telefone:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: numeroController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Campo Obrigatorio";
                                              }
                                              return null;
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              TelefoneInputFormatter()
                                            ],
                                            decoration: const InputDecoration(
                                              hintText: "(00) 12345-6789",
                                              errorBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              errorStyle: TextStyle(
                                                  fontSize: 10, height: 0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                width: 80,
                                                child: const Text(
                                                  "e-mail:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: emailController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            "email@email.com",
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  });
            },
            child: const FaIcon(FontAwesomeIcons.plus),
          ),
          body: carregando
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListView.builder(
                      itemCount: back4AppModel.contatos.length,
                      itemBuilder: (BuildContext bc, int index) {
                        var contatos = back4AppModel.contatos[index];

                        return Dismissible(
                            onDismissed:
                                (DismissDirection dismissDirection) async {
                              await back4appRepository
                                  .removerDados(contatos.objectId);

                              carregarDados();
                            },
                            key: Key(contatos.objectId),
                            child: InkWell(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          radius: 30,
                                          child: contatos.imagem.isNotEmpty
                                              ? ClipOval(
                                                  child: Image.file(
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.cover,
                                                      File(contatos.imagem)))
                                              : const FaIcon(
                                                  FontAwesomeIcons.user,
                                                  size: 40,
                                                )),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${contatos.nome} ${contatos.sobreNome}'),
                                          Text(contatos.numero),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider()
                                ],
                              ),
                            ));
                      }),
                )),
    );
  }
}
