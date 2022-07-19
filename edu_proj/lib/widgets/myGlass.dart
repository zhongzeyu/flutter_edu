import 'package:edu_proj/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/DataModel.dart';

class MyGlass extends StatelessWidget {
  final Map param;
  MyGlass(this.param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      var shadow = 0.5;
      return Stack(
        alignment: param["alignment"],
        children: [
          CustomPaint(
            painter: GlassPainter(param: param),
            size: MediaQuery.of(context).size,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(param[gBorderRadius])),
              ),
              width: param[gWidth] - shadow,
              height: param[gHeight] - shadow,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: param[gMargin],
            padding: param[gPadding],
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(param[gBorderRadius]),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    param[gColor].withOpacity(0.5),
                    param[gColor].withOpacity(0.3),
                  ],
                  stops: const [
                    0.3,
                    1.0,
                  ]),
            ),
            width: param[gWidth] - shadow,
            height: param[gHeight] - shadow,
            child: param[gChild],
          ),
        ],
      );
    });
  }
}

class GlassPainter extends CustomPainter {
  Map param = {};

  GlassPainter({
    this.param,
  });
  final Paint paintObject = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    RRect innerRect2 = RRect.fromRectAndRadius(
        Rect.fromLTRB(param[gBorder], param[gBorder],
            size.width - (param[gBorder]), size.height - (param[gBorder])),
        Radius.circular(param[gBorderRadius] - param[gBorder]));

    RRect outerRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(0, 0, size.width, size.height),
        Radius.circular(param[gBorderRadius]));
    paintObject.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          param[gBackgroundColor].withAlpha(1),
          param[gBackgroundColor].withAlpha(150),
          param[gBackgroundColor].withAlpha(150),
        ],
        stops: const [
          0.2,
          0.9,
          1.0,
        ]).createShader(Offset.zero & size);

    Path outerRectPath = Path()..addRRect(outerRect);
    Path innerRectPath2 = Path()..addRRect(innerRect2);
    canvas.drawPath(
        Path.combine(PathOperation.difference, outerRectPath, innerRectPath2),
        paintObject);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
