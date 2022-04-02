import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final name;
  final prevMoney;
  final operation;
  final addOrSubMoney;
  final resultMoney;
  final date;

  HistoryCard(
      {this.name,
      this.prevMoney,
      this.operation,
      this.addOrSubMoney,
      this.resultMoney,
      this.date});

  String getDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('d MMM');
    final String formatted = formatter.format(now);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: ListTile(
        leading: AutoSizeText(
          name.toString().substring(0, 1),
          overflow: TextOverflow.ellipsis,
          minFontSize: 20.0,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 35.0,
          ),
        ),
        title: AutoSizeText(
          '${name.toString().trim()}',
          overflow: TextOverflow.ellipsis,
          minFontSize: 20.0,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20.0,
          ),
        ),
        subtitle: AutoSizeText(
          '$prevMoney $operation $addOrSubMoney = $resultMoney',
          minFontSize: 5.0,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15.0,
          ),
        ),
        trailing: AutoSizeText(
          date.toString().trim() == getDate().trim()
              ? 'Today'
              : date.toString(),
          minFontSize: 10.0,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
