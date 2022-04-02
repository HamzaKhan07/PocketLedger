import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'khata_brain.dart';
import 'khata_data.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

const unselectedBack = Color(0xFF4C4E4D);
const unselectedLabel = Color(0xFFFFFFFF);
const selectedBack = Color(0xFFB1DFC5);
const selectedLabel = Color(0xFF000000);

enum selectedState {
  cashInSelected,
  cashOutSelected,
}

class BottomModal extends StatefulWidget {
  final name;
  final description;
  final money;
  final mode;

  BottomModal({this.name, this.description, this.money, this.mode});

  @override
  _BottomModalState createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  bool isLoading = false;
  selectedState selectedButton = selectedState.cashInSelected;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  bool nameEmpty = false;
  bool moneyEmpty = false;

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('d MMM');
    final String formatted = formatter.format(now);
    return formatted;
  }

  Future<void> updateList() async {
    //display progress
    setState(() {
      isLoading = true;
    });
    var tableData = await KhataData().getData();
    Provider.of<KhataBrain>(context, listen: false).setData(tableData);
    setState(() {
      isLoading = false;
    });
    //hide progress
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name.toString().trim();
    descriptionController.text = widget.description.toString().trim();
    moneyController.text = widget.money.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFF2C2C2C),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 70.0, bottom: 20.0),
                  child: AutoSizeText(
                    'Add Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  ),
                ),
                TextField(
                  controller: nameController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    errorText:
                        nameEmpty == true ? 'Name cannot be empty' : null,
                    enabled: widget.mode == 'update' ? false : true,
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFB1DFC5), width: 2.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFB1DFC5), width: 2.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: moneyController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    errorText:
                        moneyEmpty == true ? 'Money cannot be empty' : null,
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFB1DFC5), width: 2.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFB1DFC5), width: 2.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFB1DFC5), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFB1DFC5), width: 2.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: 20.w,
                  height: 10.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedButton = selectedState.cashInSelected;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color:
                                  selectedButton == selectedState.cashInSelected
                                      ? selectedBack
                                      : unselectedBack,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Text(
                                'Cash In',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Poppins',
                                    color: selectedButton ==
                                            selectedState.cashInSelected
                                        ? selectedLabel
                                        : unselectedLabel),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedButton = selectedState.cashOutSelected;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            decoration: BoxDecoration(
                              color: selectedButton ==
                                      selectedState.cashOutSelected
                                  ? selectedBack
                                  : unselectedBack,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Text(
                                'Cash Out',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Poppins',
                                  color: selectedButton ==
                                          selectedState.cashOutSelected
                                      ? selectedLabel
                                      : unselectedLabel,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 45.w,
                      height: 18.w,
                      child: FlatButton(
                        color: Colors.white,
                        onPressed: () async {
                          if (widget.mode != 'update') {
                            if (nameController.text.trim() == '' ||
                                nameController.text == null) {
                              setState(() {
                                nameEmpty = true;
                              });
                            } else {
                              setState(() {
                                nameEmpty = false;
                              });
                            }
                            if (moneyController.text.trim() == '' ||
                                moneyController.text == null) {
                              setState(() {
                                moneyEmpty = true;
                              });
                            } else {
                              setState(() {
                                moneyEmpty = false;
                              });
                            }
                            if (nameController.text.trim() == '' ||
                                nameController.text == null ||
                                moneyController.text.trim() == '' ||
                                moneyController.text == null) {
                              //error already shown do nothing dont proceed further

                            } else {
                              nameEmpty = false;
                              moneyEmpty = false;
                              print('Not update mode');
                              String date = getDate();
                              int money =
                                  selectedButton == selectedState.cashInSelected
                                      ? int.parse(moneyController.text)
                                      : (int.parse(moneyController.text) * -1);
                              //data collection
                              List data = [
                                nameController.text.trim(),
                                descriptionController.text.trim(),
                                money,
                                date.trim()
                              ];

                              //insert data
                              int timesExists = await KhataData()
                                  .checkIfNameExists(nameController.text);

                              if (timesExists > 0) {
                                //display dialog here
                                _onAlertButtonPressed(context);
                                print('Name already exists');
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                await KhataData().insertData(data);

                                print('data inserted');
                                //update list
                                await updateList();
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              }
                            }
                          } else {
                            print('Update mode');
                            if (moneyController.text.trim() == '' ||
                                moneyController.text == null) {
                              //error here
                              setState(() {
                                moneyEmpty = true;
                              });
                            } else {
                              moneyEmpty = false;
                              String name =
                                  nameController.text.toString().trim();
                              String mode =
                                  selectedButton == selectedState.cashInSelected
                                      ? 'cashIn'
                                      : 'cashOut';
                              String moneyToUpdate =
                                  moneyController.text.toString().trim();

                              String description =
                                  descriptionController.text.toString().trim();

                              setState(() {
                                isLoading = true;
                              });
                              await KhataData().update(
                                  name, mode, moneyToUpdate, description);

                              //updateList
                              await updateList();
                              setState(() {
                                isLoading = false;
                              });
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.0,
                              color: Colors.black),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Alert with single button.
_onAlertButtonPressed(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Entry already exists",
    desc: "Try Search and Update instead.",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        width: 120,
      )
    ],
  ).show();
}
