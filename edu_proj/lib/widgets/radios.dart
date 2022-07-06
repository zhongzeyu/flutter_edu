import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Radios extends StatelessWidget {
  final List _param;
  Radios(this._param);

  @override
  Widget build(BuildContext context) {
    final controller = PageController(viewportFraction: 0.8, keepPage: true);

    return Consumer<DataModel>(builder: (context, datamodel, child) {
      final pages = datamodel.getRadios(_param, context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 140,
            //width: double.infinity,
            child: PageView.builder(
              controller: controller,
              // itemCount: pages.length,
              itemBuilder: (_, index) {
                return pages[index % pages.length];
              },
            ),
          ),
          SizedBox(height: 16),
          SmoothPageIndicator(
            controller: controller,
            count: pages.length,
            effect: WormEffect(
              dotHeight: 25,
              dotWidth: 25,
              type: WormType.thin,
              // strokeWidth: 5,
            ),
            onDotClicked: (index) {
              controller.jumpToPage(index);
            },
          ),
        ],
      );
    });
  }
}
