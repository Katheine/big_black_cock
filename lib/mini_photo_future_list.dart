import 'dart:async';
import 'dart:collection';

import 'package:firebase_storage/firebase_storage.dart';

class MiniPhotoFutureList extends ListMixin {
  final _map = Map<int, Future<dynamic>>();
  final int num;
  final String type;

  MiniPhotoFutureList(this.num, this.type);

  @override
  int length = 10;

  @override
  operator [](int index) {
    if (_map.containsKey(index))
      return _map[index];
    final future = FirebaseStorage.instance.ref().child("/${type}_info/$num/subs/$index.jpg").getDownloadURL();
    _map[index] = future;
    return future;
  }

  @override
  void operator []=(int index, value) {}
}