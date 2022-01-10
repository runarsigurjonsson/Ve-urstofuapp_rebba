import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'my_image.dart';

enum ForcastImageCacheState {
  EMPTY,
  INITIALIZING,
  LOADED,
}

const imageCount = 24;

class ForcastImageCache {
  final String _preUrlHiti = "/photos/thattaspa_igb_island_2t";
  final String _preUrlUrkoma = "/photos/thattaspa_igb_island_urk-msl-10uv";
  final String _preUrlVindur = "/photos/thattaspa_igb_island_10uv";

  final String _host = "https://www.vedur.is";

  ForcastImageCacheState imageGetterState = ForcastImageCacheState.EMPTY;
  List<Widget> thattaspaHiti =
      List<Widget>.generate(imageCount, (index) => Text("Loading Image"));
  List<Widget> thattaspaVindur =
      List<Widget>.generate(imageCount, (index) => Text("Loading Image"));
  List<Widget> thattaspaUrkoma =
      List<Widget>.generate(imageCount, (index) => Text("Loading Image"));

  void startLoadingIfEmpty() {
    if (imageGetterState == ForcastImageCacheState.EMPTY) {
      imageGetterState = ForcastImageCacheState.INITIALIZING;
      _getImages().then((value) {
        imageGetterState = ForcastImageCacheState.LOADED;
      });
    }
  }

  Future<void> _getImages() async {
    DateFormat df = DateFormat("yyMMdd");
    DateTime dt = DateTime.now();
    for (int d = 0; d < 7; d++) {
      String dtStr = df.format(dt);
      for (int i = 0; i < imageCount; i = i + 3) {
        thattaspaHiti[i] = await _getImage(i, dtStr, _preUrlHiti);
        thattaspaUrkoma[i] = await _getImage(i, dtStr, _preUrlUrkoma);
        thattaspaVindur[i] = await _getImage(i, dtStr, _preUrlVindur);
      }
      dt = dt.add(const Duration(days: 1));
    }
  }

  Future<Widget> _getImage(int i, String dt, String preurl) async {
    String strI = i.toString();
    strI = strI.padLeft(3, '0');

    String url = preurl + '/' + dt + '_0600_' + strI + '.gif';
    log(url);
    try {
      Uint8List data = (await NetworkAssetBundle(Uri.parse(_host)).load(url))
          .buffer
          .asUint8List();
      //NetworkImage netImg = NetworkImage(_fullurl);
      //MyImage img = MyImage(imageProvider: netImg);
      MemoryImage? memImg = MemoryImage(data);
      log("image loaded");
      return MyImage(imageProvider: memImg);
    } catch (E) {
      log("image not found");
      return Text("Image not found on server");
    }
  }
}
