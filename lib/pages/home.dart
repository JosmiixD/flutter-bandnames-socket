import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<Band> bands = [
    Band( id: '1', name: 'Metalica', votes: 5),
    Band( id: '2', name: 'Queen', votes: 2),
    Band( id: '3', name: 'Heroes del silencio', votes: 4),
    Band( id: '4', name: 'Bon Jovi', votes: 2),
    Band( id: '5', name: 'Caifanes', votes: 7),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle( color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( context, i ) => _bandTile( bands[i])

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        elevation: 1,
        onPressed: addNewBand, 
      ),
   );
  }

  Widget _bandTile( Band band ) {
    return Dismissible(
      key: Key( band.id! ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ) {
        print('directgion: $direction');
      },
      background: Container(
        padding: EdgeInsets.only( left: 22.0 ),
        color: Colors.red.shade100,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Icon( Icons.delete, color: Colors.red, ),
              SizedBox( width: 20 ),
              Text('Delete Band', style: TextStyle( color: Colors.red )) 
            ],
          )
        )
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text( band.name!.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text( band.name! ),
        trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20 )),

        onTap: (){
          print( band.name );
        },
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if( Platform.isAndroid ) {
      return showDialog(
        context: context,
        builder: ( context) {

          return AlertDialog(
            title: Text('New band name'),
            content: TextField(
              controller: textController
            ),
            actions: <Widget> [
              MaterialButton(
                child: Text('Add'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList( textController.text )
              )
            ]
          );

        }
      );
    }

    showCupertinoDialog(
      context: context,
      builder: ( _ ) {

        return CupertinoAlertDialog(
          title: Text('New Band Name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget> [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList( textController.text )
            ),
            CupertinoDialogAction(
              isDestructiveAction: false,
              child: Text('Dismiss'),
              onPressed: () => Navigator.pop(context)
            )
          ]
        );

      }
    );

    
  }

  
  void addBandToList( String name ) {


    print(name);


    if( name.length > 1 ) {
      //Podemos agregar
      this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0 ) );
      setState(() {
        
      });
    }

    Navigator.pop(context);

  }


  
}