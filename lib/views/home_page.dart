import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedoku/views/doku_main_page.dart';
import 'dart:async';
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
      backgroundColor: const Color.fromARGB(255, 26, 25, 25),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
          child: FutureBuilder<List>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final rows = <Container>[];
      
                snapshot.data!.forEach((element) {
                  rows.add(
                    Container(
                      height: 100.0,
                      width: 400,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 88, 88, 88),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              element['emergancyPlace'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  );
                });
      
                return Column(
                  children: rows,
                );
              }
        
              return const Text("No Data");
            },
          ),
        ),
      ),
    );
  }
}