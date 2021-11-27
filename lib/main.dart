import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<String>('friends');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<String> friendsBox;

  final _idController = TextEditingController();

  final _nameController = TextEditingController();

  @override
  void initState() {
    friendsBox = Hive.box<String>('friends');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive CRUD'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: friendsBox.listenable(),
                  builder: (context, Box<String> friends, _) {
                    return ListView.separated(
                      itemCount: friends.keys.length,
                      separatorBuilder: (_, i) => const Divider(),
                      itemBuilder: (ctx, i) {
                        final key = friends.keys.toList()[i];

                        final value = friends.get(key);

                        return ListTile(
                          title: Text(value.toString()),
                          subtitle: Text(key),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text('create'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: SizedBox(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        label: Text('Key'),
                                      ),
                                      controller: _idController,
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        label: const Text('Value'),
                                      ),
                                      controller: _nameController,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      child: const Text('submit'),
                                      onPressed: () {
                                        final key = _idController.text;
                                        final value = _nameController.text;

                                        friendsBox.put(key, value);

                                        _idController.clear();
                                        _nameController.clear();

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
                ElevatedButton(
                  child: const Text('update'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: SizedBox(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        label: Text('Key'),
                                      ),
                                      controller: _idController,
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        label: const Text('Value'),
                                      ),
                                      controller: _nameController,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      child: const Text('submit'),
                                      onPressed: () {
                                        final key = _idController.text;
                                        final value = _nameController.text;

                                        friendsBox.put(key, value);

                                        _idController.clear();
                                        _nameController.clear();

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
                ElevatedButton(
                  child: const Text('delete'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: SizedBox(
                              height: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: const InputDecoration(
                                        label: Text('Key'),
                                      ),
                                      controller: _idController,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      child: const Text('submit'),
                                      onPressed: () {
                                        final key = _idController.text;

                                        friendsBox.delete(key);

                                        _idController.clear();

                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
