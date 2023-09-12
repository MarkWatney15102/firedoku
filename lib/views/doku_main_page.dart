import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DokuMainPage extends StatefulWidget {
  const DokuMainPage({super.key});

  @override
  State<DokuMainPage> createState() => _DokuMainPageState();
}

enum EmergancyType {feuer, th, bma, other}

class _DokuMainPageState extends State<DokuMainPage> {
  EmergancyType? _emergancyType = EmergancyType.feuer;

  TextEditingController emergancyPlaceController = TextEditingController();
  TextEditingController emergancyDispachTimeController = TextEditingController();
  TextEditingController emergancyDispatchDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neue Einsatzdoku"),
        backgroundColor: Colors.red,
      ),
      backgroundColor: const Color.fromARGB(255, 26, 25, 25),
      body: Form(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
              child: Column(
                children: [
                  TextFormField(
                    controller: emergancyPlaceController,
                    decoration: const InputDecoration(
                      labelText: 'Einsatzort',
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),
                      icon: Icon(Icons.fireplace, color: Colors.white,)
                    ),
                    style: const TextStyle(
                      color: Colors.white
                    ),
                  ),
                  TextFormField(
                    controller: emergancyDispatchDateController,
                    decoration: const InputDecoration(
                      labelText: 'Alamierungsdatum',
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),
                      icon: Icon(Icons.calendar_today, color: Colors.white,)
                    ),
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickdate = await showDatePicker(
                        context: context, 
                        initialDate: DateTime.now(), 
                        firstDate: DateTime(2000), 
                        lastDate: DateTime(2101)
                      );

                      if (pickdate != null) {
                        setState(() {
                          emergancyDispatchDateController.text = DateFormat('yyyy-MM-dd').format(pickdate);
                        });
                      }
                    },
                  ),
                  TextFormField(
                    controller: emergancyDispachTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Uhrzeit',
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),
                      icon: Icon(Icons.timelapse,  color: Colors.white,)
                    ),
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? timePicker = await showTimePicker(
                        context: context, 
                        initialTime: TimeOfDay.now()
                      );

                      if (timePicker != null) {
                        setState(() {
                          String hours = timePicker.hour.toString();
                          String minutes = timePicker.minute.toString();

                          if (minutes.length == 1) {
                            minutes = "0$minutes";
                          }

                          emergancyDispachTimeController.text = '$hours:$minutes';
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            
            Column(
              children: <Widget>[
                ListTile(
                  title: const Text("Feuer"),
                  leading: Radio<EmergancyType>(
                    value: EmergancyType.feuer,
                    groupValue: _emergancyType,
                    onChanged: (value) {
                      setState(() {
                        _emergancyType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Technische Hilfeleistung"),
                  leading: Radio<EmergancyType>(
                    value: EmergancyType.th,
                    groupValue: _emergancyType,
                    onChanged: (value) {
                      setState(() {
                        _emergancyType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("BMA"),
                  leading: Radio<EmergancyType>(
                    value: EmergancyType.bma,
                    groupValue: _emergancyType,
                    onChanged: (value) {
                      setState(() {
                        _emergancyType = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Sonstiges"),
                  leading: Radio<EmergancyType>(
                    value: EmergancyType.other,
                    groupValue: _emergancyType,
                    onChanged: (value) {
                      setState(() {
                        _emergancyType = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          CollectionReference firestore = FirebaseFirestore.instance.collection('emergancy_dokus');
          firestore.add({
            'emergancyPlace': emergancyPlaceController.text,
            'date': emergancyDispatchDateController.text,
            'time': emergancyDispachTimeController.text
          }).then((value) {
              print(value.id);
          });
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}