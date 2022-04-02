import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'tile.dart';
import 'bottom_sheet.dart';
import 'khata_data.dart';
import 'khata_brain.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'khata_history_data.dart';
import 'history_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'summary_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    startDatabase();
  }

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('d MMM');
    final String formatted = formatter.format(now);
    return formatted;
  }

  void startDatabase() async {
    //display progress
    setState(() {
      isLoading = true;
    });
    await KhataData().createDatabase();
    await KhataUpdateData().createDatabase();
    var data = await KhataData().getData();
    Provider.of<KhataBrain>(context, listen: false).setData(data);
    setState(() {
      isLoading = false;
    });
    //hide progress
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF2C2C2C),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) =>
                BottomModal(name: '', description: '', money: ''),
          );
        },
      ),
      body: ModalProgressHUD(
        opacity: 1,
        inAsyncCall: isLoading,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.money,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    var data = await KhataData().getTotals();
                    int totalOut = data[0];
                    int totalIn = data[1];
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SummaryScreen(
                          totalOut: totalOut,
                          totalIn: totalIn,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.history,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    //show progress
                    var data = await KhataUpdateData().getData();

                    Provider.of<KhataBrain>(context, listen: false)
                        .setHistoryData(data);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()));

                    //hide progress
                  },
                ),
              ],
              backgroundColor: Colors.white,
              title: Text(
                'Pocket Ledger',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
              floating: true,
              pinned: true,
              snap: false,
              expandedHeight: 22.0.h,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [
                    SizedBox(
                      height: 95.0,
                    ),
                    Provider.of<KhataBrain>(context).originalData.length > 0
                        ? Flexible(
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                              child: TextField(
                                autofocus: false,
                                onChanged: (String searchText) {
                                  //get the Name matching to search text
                                  var results = Provider.of<KhataBrain>(context,
                                          listen: false)
                                      .getOriginalData()
                                      .where((element) => element.name
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchText.toLowerCase()))
                                      .toList();

                                  //Filter results
                                  Provider.of<KhataBrain>(context,
                                          listen: false)
                                      .filterResults(results);
                                },
                                style: TextStyle(fontFamily: 'Poppins'),
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black26,
                                  ),
                                  suffixIcon:
                                      Icon(Icons.search, color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black12, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18.0)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 10.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18.0)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 0),
                  ],
                ),
              ),
            ),
            Provider.of<KhataBrain>(context).originalData.length > 0
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Tile(
                          name: Provider.of<KhataBrain>(context)
                              .copyData[index]
                              .name,
                          description: Provider.of<KhataBrain>(context)
                              .copyData[index]
                              .description,
                          amount: Provider.of<KhataBrain>(context)
                                      .copyData[index]
                                      .money >
                                  0
                              ? '+${Provider.of<KhataBrain>(context).copyData[index].money}'
                              : '${Provider.of<KhataBrain>(context).copyData[index].money}',
                          date: Provider.of<KhataBrain>(context)
                                      .copyData[index]
                                      .date
                                      .trim() ==
                                  getDate().trim()
                              ? 'Today'
                              : Provider.of<KhataBrain>(context)
                                  .copyData[index]
                                  .date,
                          updateCallback: () {
                            //Get name and description
                            String name =
                                Provider.of<KhataBrain>(context, listen: false)
                                    .getNameFromIndex(index);

                            String description =
                                Provider.of<KhataBrain>(context, listen: false)
                                    .getDescriptionFromIndex(index);

                            //Pass name and description to modal sheet
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => BottomModal(
                                name: name,
                                description: description,
                                money: '',
                                mode: 'update',
                              ),
                            );
                          },
                          longTapCallback: () async {
                            //delete tile code here
                            setState(() {
                              isLoading = true;
                            });

                            String nameToDelete =
                                Provider.of<KhataBrain>(context, listen: false)
                                    .getNameFromIndex(index);

                            nameToDelete = nameToDelete.trim();
                            print('Name to delete: $nameToDelete');

                            //Update UI
                            Provider.of<KhataBrain>(context, listen: false)
                                .deleteEntryFromUI(index);

                            //Delete the name from main screen
                            await KhataData().delete(nameToDelete);
                            //Delete the name from history screen if exists
                            int timesExists = await KhataUpdateData()
                                .checkIfNameExists(nameToDelete);
                            if (timesExists > 0) {
                              await KhataUpdateData().delete(nameToDelete);
                            }

                            // //Update UI
                            // Provider.of<KhataBrain>(context, listen: false)
                            //     .deleteEntryFromUI(index);

                            setState(() {
                              isLoading = false;
                            });
                          },
                        );
                      },
                      childCount:
                          Provider.of<KhataBrain>(context).copyData.length,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            child: Image.asset('images/empty.png'),
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                          SizedBox(
                            height: 0.0,
                          ),
                          AutoSizeText(
                            'Diary empty. Please add data.',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    }, childCount: 1),
                  ),
          ],
        ),
      ),
    );
  }
}
