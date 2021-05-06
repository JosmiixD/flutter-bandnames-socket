import 'package:flutter/material.dart';
import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<Band> bands = [
    Band( id: '1', name: 'Waiting', votes: 0),
  ];


  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands );

    super.initState();
  }

  _handleActiveBands( dynamic payload ) {

    this.bands = ( payload as List )
      
        .map( (band) => Band.fromMap(band))
        .toList();

      setState(() {});

  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BandNames', style: TextStyle( color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only( right: 10 ),
            child: ( socketService.serverStatus == ServerStatus.Online )
                    ? Icon( Icons.check_circle, color: Colors.blue)
                    : Icon( Icons.offline_bolt, color: Colors.red)
              
              
          )
        ],
      ),
      body: Column(
        children: <Widget>[

          _showGraph(),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: ( context, i ) => _bandTile( bands[i])

            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.add ),
        elevation: 1,
        onPressed: addNewBand, 
      ),
   );
  }

  Widget _bandTile( Band band ) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key( band.id ),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction ) => socketService.socket.emit('delete-band', { 'id' : band.id }),
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
          child: Text( band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text( band.name ),
        trailing: Text('${ band.votes }', style: TextStyle( fontSize: 20 )),

        onTap: () => socketService.socket.emit('vote-band', { 'id': band.id } ),
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    if( Platform.isAndroid ) {
      return showDialog(
        context: context,
        builder: ( _ ) =>  AlertDialog(
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
        ),
      );
    }

    showCupertinoDialog(
      context: context,
      builder: ( _ ) => CupertinoAlertDialog(
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
        ),
    );

    
  }

  
  void addBandToList( String name ) {

    if( name.length > 1 ) {
      final socketService = Provider.of<SocketService>( context, listen: false );
      socketService.socket.emit('add-band', { 'name': name });
    }

    Navigator.pop(context);

  }

  //Grafica
  Widget _showGraph() {

    Map<String, double> dataMap = new Map();

    for ( Band band in bands ) {
      
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());

    }

    final List<Color> colorList = [
      Colors.blue.shade50,
      Colors.blue.shade200,
      Colors.pink.shade50,
      Colors.pink.shade200,
      Colors.yellow.shade50,
      Colors.yellow.shade200
    ];

    // setState(() { });
    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.only( top: 1 ),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        centerText: "HYBRID",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
      ),
    );
    // return CircularProgressIndicator();

  }

}