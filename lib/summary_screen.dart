import 'package:flutter/material.dart';
import 'summary_card.dart';

class SummaryScreen extends StatelessWidget {
  final totalOut;
  final totalIn;

  SummaryScreen({this.totalOut, this.totalIn});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Summary',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SummaryCard(
            desc: 'Cash to be Received',
            cash: totalOut,
            status: 'out',
          ),
          SummaryCard(
            desc: 'Cash in Advance',
            cash: totalIn,
            status: 'in',
          ),
        ],
      ),
    );
  }
}
