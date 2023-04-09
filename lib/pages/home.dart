import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? _userToDo;
  List todoList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todoList.addAll(['Wash the car', 'do homework', 'go for a walk with Kate']);
  }

  void _menuOpen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: const Text('Navi'),
          ),
          body: Center(
            child:
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                }, child: const Text('To the Main screen', style: TextStyle(
              fontSize: 25,
            ),)
            ),
          )
        );
    })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('To-Do list'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.menu),
              onPressed: _menuOpen,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) return const Text('No records');
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                    child: ListTile(
                      title: Text(snapshot.data!.docs[index].get('item')),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_sweep,
                          color: Colors.deepPurpleAccent,
                        ), onPressed: () {
                        FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                      },
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
// if (direction == DismissDirection.endToStart)
                  },
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
          onPressed: () {
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Add element',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
              ),),
              content: TextField(
                onChanged: (String value) {
                  _userToDo = value;
                },
              ),
              actions: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.deepPurpleAccent),
                  ),
                  onPressed: () {
                  FirebaseFirestore.instance.collection('items').add({'item': _userToDo});

                  Navigator.of(context).pop();
                }, child: const Text('Add'),),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.deepPurpleAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text('Cancel'),),
              ],
            );
          });
          },
        child: const Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }
}
