import 'package:flutter/cupertino.dart';

import 'khata_data.dart';
import 'khata_history_data.dart';

class KhataBrain extends ChangeNotifier {
  List<KhataData> originalData = [];
  List<KhataData> copyData = [];
  List<KhataUpdateData> historyData = [];
  List<KhataUpdateData> historyDataOriginal = [];

  void setData(var data) {
    originalData = data;
    copyData = data;
    originalData = originalData.reversed.toList();
    copyData = copyData.reversed.toList();
    notifyListeners();
  }

  void deleteEntryFromUI(int index) {
    print(index);
    originalData.removeAt(index);
    copyData.removeAt(index);
    notifyListeners();
  }

  void setHistoryData(var data) {
    historyDataOriginal = data;
    historyData = data;
    historyDataOriginal = historyDataOriginal.reversed.toList();
    historyData = historyData.reversed.toList();
    notifyListeners();
  }

  String getNameFromIndex(int index) {
    String name = copyData[index].name;
    return name;
  }

  String getDescriptionFromIndex(int index) {
    String description = copyData[index].description;
    return description;
  }

  int getMoneyFromIndex(int index) {
    int money = copyData[index].money;
    return money;
  }

  List<KhataData> getOriginalData() {
    return originalData;
  }

  void filterResults(var data) {
    copyData = data;
    notifyListeners();
  }

  List<KhataUpdateData> getOrigitalHistoryData() {
    return historyDataOriginal;
  }

  void filterHistoryResults(var data) {
    historyData = data;
    notifyListeners();
  }
}
