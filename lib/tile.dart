import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Tile extends StatelessWidget {
  final String name;
  final String description;
  final String amount;
  final String date;
  final Function updateCallback;
  final Function longTapCallback;

  Tile({
    this.name,
    this.description,
    this.amount,
    this.date,
    this.updateCallback,
    this.longTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: longTapCallback,
      onTap: updateCallback,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xFFFCF1A1),
        ),
        width: 90.w,
        height: 20.h,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                child: Container(
                  width: 16.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFB1DFC5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      name.substring(0, 1),
                      style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Poppins',
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                padding: EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 14.0,
                      style: TextStyle(
                        color: Color(0xFF2C2C2C),
                        fontSize: 18.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AutoSizeText(
                      description,
                      minFontSize: 12.0,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF4C4E4D),
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    AutoSizeText(
                      '₹$amount',
                      minFontSize: 16.0,
                      style: TextStyle(
                        color:
                            amount.startsWith('+') ? Colors.teal : Colors.red,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w900,
                        fontSize: 25.0,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 5.0),
                child: AutoSizeText(
                  date,
                  minFontSize: 8.0,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Poppins',
                    color: Color(0xFF4C4E4D),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
