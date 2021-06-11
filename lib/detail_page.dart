import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class DetailPage extends StatefulWidget {
  var file;

  DetailPage(this.file);
  @override
  State<StatefulWidget> createState() {
    return _DetailScreen();
  }
}

class _DetailScreen extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AppBar Demo'),
        ),
        backgroundColor: Color.fromRGBO(2, 7, 39, 1),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Share.share(widget.file);
            },
            child: Container(
                height: 60,
                color: Colors.red,
                child: Center(child: Text('SHARE')))),
        body: SafeArea(
          top: false,
          bottom: true,
          child: CachedNetworkImage(
            placeholder: (context, url) =>
                Container(child: CircularProgressIndicator()),
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageUrl: widget.file,
            fadeInDuration: Duration(microseconds: 1),
            fadeOutDuration: Duration(microseconds: 1),
          ),
        ));
  }
}
