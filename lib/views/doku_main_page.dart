import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DokuMainPage extends StatefulWidget {
  const DokuMainPage({super.key});

  @override
  State<DokuMainPage> createState() => _DokuMainPageState();
}

class _DokuMainPageState extends State<DokuMainPage> {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: emergancyPlaceController,
                decoration: const InputDecoration(
                  labelText: 'Einsatzort',
                  icon: Icon(Icons.fireplace)
                ),
              ),
              TextFormField(
                controller: emergancyDispatchDateController,
                decoration: const InputDecoration(
                  labelText: 'Alamierungsdatum',
                  icon: Icon(Icons.calendar_today)
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
                  icon: Icon(Icons.timelapse)
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
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward),
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
      ),
    );
  }
}