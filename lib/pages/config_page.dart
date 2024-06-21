import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          CupertinoDialogAction(
                            child: const Text("Adicinar"),
                            onPressed: () async {
                            },
                          )
                        ],
                        title: const Text("Adicionar Cartão"),
                        content: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  labelText: "Nome",
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Dia de vencimento",
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: const Text('Adicionar Cartão.'))
        ],
      ),
    );
  }
}
