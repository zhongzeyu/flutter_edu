import 'dart:async';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uc_pdfview/uc_pdfview.dart';

class PDFScreen extends StatefulWidget {
  final Map _param;

  PDFScreen(this._param);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(datamodel.getSCurrent(widget._param[gSubject])),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                /*Share.share(
                    'Register  App with my referral code text to get \$20.');*/
                Share.shareFiles(
                  [widget._param[gPath]],
                  subject: widget._param[gSubject],
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            UCPDFView(
              filePath: widget._param[gPath],
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation:
                  false, // if set to true the link is handled in flutter
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                //print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String uri) {
                //print('goto uri: $uri');
              },
              onPageChanged: (int page, int total) {
                // print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            ),
            errorMessage.isEmpty
                ? !isReady
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container()
                : Center(
                    child: Text(errorMessage),
                  )
          ],
        ),
        floatingActionButton: FutureBuilder<PDFViewController>(
          future: _controller.future,
          builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
            if (snapshot.hasData) {
              return FloatingActionButton.extended(
                label: Text(datamodel.getSCurrent("Go to") + " ${pages ~/ 2}"),
                onPressed: () async {
                  await snapshot.data.setPage(pages ~/ 2);
                },
              );
            }

            return Container();
          },
        ),
      );
    });
  }
}
