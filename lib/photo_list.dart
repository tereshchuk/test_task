import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/variables.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'Test.dart';
import 'creation_aware_list_item.dart';
import 'detail_page.dart';
import 'fetch_photos.dart';
import 'home_view_model.dart';

class PhotosList extends StatefulWidget {
  final List<Test> photos;
  PhotosList({this.photos});

  @override
  State<StatefulWidget> createState() {
    return _PhotosList();
  }
}

class _PhotosList extends State<PhotosList> {
  static const int ItemRequestThreshold = 10;

  loadMorePhotos() async {
    var carsToAdd = await fetchPhotos(http.Client(), currentPage);
    setState(() {
      widget.photos.addAll(carsToAdd);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
            builder: (context, model, child) => CustomScrollView(slivers: [
                  SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return CreationAwareListItem(
                          itemCreated: () {
                            var itemPosition = index + 1;

                            var requestMoreData =
                                itemPosition % ItemRequestThreshold == 0 &&
                                    itemPosition != 0;
                            var pageToRequest =
                                itemPosition ~/ ItemRequestThreshold + 1;

                            if (requestMoreData &&
                                pageToRequest > currentPage &&
                                currentPage != 6) {
                              //вот здесь стоит цифра 6, во время 6 запроса пагинации показывыается End Story
                              currentPage = pageToRequest;
                              loadMorePhotos();
                            }
                          },
                          child: CachedNetworkImage(
                            placeholder: (context, url) =>
                                Container(child: CircularProgressIndicator()),
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.width * 0.7,
                            width: double.infinity,
                            imageBuilder: (context, imageProvider) =>
                                GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  widget.photos[index].urls
                                                      .small)),
                                        ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl: widget.photos[index].urls.small,
                            fadeInDuration: Duration(microseconds: 1),
                            fadeOutDuration: Duration(microseconds: 1),
                          ),
                        );
                      },
                      childCount: widget.photos.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: currentPage == 6
                          ? Center(child: Text('End Story'))
                          : Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator())))
                ])));
  }
}
