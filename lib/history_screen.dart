import 'package:flutter/material.dart';
import 'khata_brain.dart';
import 'historyCard.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TextEditingController searchController = TextEditingController();
  Widget appBarTitle = new Text(
    "Updatation History",
    style: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
    ),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: appBarTitle,
          backgroundColor: Colors.white,
          actions: <Widget>[
            new IconButton(
              icon: actionIcon,
              onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(
                      Icons.close,
                      color: Colors.black,
                    );
                    this.appBarTitle = new TextField(
                      controller: searchController,
                      onChanged: (String searchText) {
                        print(searchText);
                        //Get the names starting/containing search Text
                        var results =
                            Provider.of<KhataBrain>(context, listen: false)
                                .getOrigitalHistoryData()
                                .where((element) => element.name
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()))
                                .toList();
                        //Filter Results list
                        Provider.of<KhataBrain>(context, listen: false)
                            .filterHistoryResults(results);
                      },
                      style: new TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                      decoration: new InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusColor: Colors.black,
                          prefixIcon:
                              new Icon(Icons.search, color: Colors.black),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.black)),
                    );
                  } else {
                    this.actionIcon = new Icon(
                      Icons.search,
                      color: Colors.black,
                    );
                    this.appBarTitle = new Text(
                      "History",
                      style:
                          TextStyle(fontFamily: 'Poppins', color: Colors.black),
                    );
                  }
                });
              },
            ),
          ]),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return HistoryCard(
            name: Provider.of<KhataBrain>(context).historyData[index].name,
            prevMoney:
                Provider.of<KhataBrain>(context).historyData[index].prevMoney,
            operation:
                Provider.of<KhataBrain>(context).historyData[index].operation,
            addOrSubMoney: Provider.of<KhataBrain>(context)
                .historyData[index]
                .addOrSubMoney,
            resultMoney:
                Provider.of<KhataBrain>(context).historyData[index].resultMoney,
            date: Provider.of<KhataBrain>(context).historyData[index].date,
          );
        },
        itemCount: Provider.of<KhataBrain>(context).historyData.length,
      ),
    );
  }
}
