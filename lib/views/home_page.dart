import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedoku/views/doku_main_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List> data;

  Future<List> fetchDokus() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('emergancy_dokus');

    QuerySnapshot qs = await ref.get();

    return qs.docs.map((e) => e.data()).toList();
  }

  @override
  void initState() {
    super.initState();
    data = fetchDokus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Einsatzdoku"),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => const DokuMainPage()
            )
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        child: FutureBuilder<List>(
          future: data,
          builder: (context, snapshot) {
            return Table(
              children: const <TableRow>[
                TableRow(
                  children: <Widget>[
                    TableCell(
                      child: Text("data")
                    )
                  ]
                )
              ],
            );
          },
        ),
      )
    );
  }
}