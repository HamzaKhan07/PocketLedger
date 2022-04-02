import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SummaryCard extends StatelessWidget {
  final desc;
  final cash;
  final status;

  SummaryCard({this.desc, this.cash, this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      height: 20.h,
      decoration: BoxDecoration(
        color: status == 'out' ? Color(0xFFFCF1A1) : Color(0xFFB1DFC5),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                child: Text(
                  '$desc',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Container(
                child: Center(
                  child: AutoSizeText(
                    '₹$cash',
                    minFontSize: 20.0,
                    maxFontSize: 60.0,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: status == 'out' ? Colors.red : Colors.teal,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
