import 'package:flutter/cupertino.dart';

class StoreProvider with ChangeNotifier {
  String? selectedStore;
  String? selectedStoreId;
  String? selectedProductCategory;

  getSelectedStore(storeName, storeId) {
    this.selectedStore = storeName;
    this.selectedStoreId = storeId;
    notifyListeners();
  }

  selectedCategory(category) {
    this.selectedProductCategory = category;
    notifyListeners();
  }
}
