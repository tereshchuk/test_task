import 'package:flutter/widgets.dart';

class HomeViewModel extends ChangeNotifier {
  List<String> _items;
  List<String> get items => _items;

  static const int ItemRequestThreshold = 10;
  int _currentPage = 0;

  Future handleItemCreated(int index) {
    var itemPosition = index + 1;
    var requestMoreData =
        itemPosition % ItemRequestThreshold == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ ItemRequestThreshold;
    print(itemPosition);
    if (requestMoreData && pageToRequest > _currentPage) {
      _currentPage = pageToRequest;
    }
  }
}
