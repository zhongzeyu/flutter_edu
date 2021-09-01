//import 'package:edu_proj/config/MyConfig.dart';
import 'package:edu_proj/config/MyConfig.dart';
import 'package:edu_proj/config/constants.dart';
//import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:edu_proj/widgets/textfieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyForm extends StatelessWidget {
  final String _param;

  MyForm(this._param);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, datamodel, child) {
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        final String _formName = _param;
        //['name'];
        Map<String, dynamic> formDefine = datamodel.formLists[_formName];
        Map<dynamic, dynamic> items = formDefine[gItems];

        //Size size = MediaQuery.of(context).size;
        //double _top = 10.0;
        List<Widget> _showItems() {
          List<Widget> result = [];

          items.entries.forEach((item) {
            if (item.value[gIsHidden] != gTrue &&
                item.value[gType] != gHidden) {
              //_top += 10;
              if (item.value[gType] == MyConfig.TEXT.name) {
                result.add(
                  Text(
                    datamodel.getSCurrent(item.value[gLabel]),

                    /*
                onTab: () => {_onTab(item.value['id'], size)},
                onChanged: (String value) =>
                    {_onChange(item.value['id'], value)},
                textFieldController: item.value['txtEditingController'],
                */
                  ),
                );
              } else {
                result.add(
                  TextFieldWidget(
                    item: item,
                    /*
                onTab: () => {_onTab(item.value['id'], size)},
                onChanged: (String value) =>
                    {_onChange(item.value['id'], value)},
                textFieldController: item.value['txtEditingController'],
                */
                  ),
                );
              }
            }
          });
          //_top += 30;

          result.add(
            SizedBox(
              height: 24,
            ),
          );
          datamodel.beforeSubmit(context, _formName, result);
          result.add(
            ElevatedButton(
              child: Text(datamodel.getSCurrent(formDefine[gSubmit])),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                datamodel.formSubmit(context, _formName);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow,
              ),
            ),
          );

          datamodel.afterSubmit(context, _formName, result);
          return result;
        }

        return InteractiveViewer(
          scaleEnabled: true,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _showItems(),
              ),
            ),
          ),
        );
        /*Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: formDefine[
                  'height'], //size.height * formDefine['heightPercent'],
              child: Container(
                //padding: EdgeInsets.all(gDefaultPaddin),
                padding: EdgeInsets.only(
                    left: gDefaultPaddin,
                    right: gDefaultPaddin,
                    bottom: gDefaultPaddin),
                child: 
                Stack(
                  children: [
                    //Column
                    //(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    //children: [
                    Container(
                      width: size.width - 5,
                      height: formDefine['height'] -
                          formDefine['top'] -
                          gDefaultPaddin,

                      margin: EdgeInsets.only(top: formDefine['top']),
                      padding: EdgeInsets.only(
                          top: gDefaultPaddin,
                          left: gDefaultPaddin,
                          right: gDefaultPaddin),
                      decoration: BoxDecoration(
                        //color: formDefine['backgroundColor'],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 0.0, // soften the shadow
                            spreadRadius: 0.0, //extend the shadow
                            offset: Offset(
                              2.0, // Move to right 10  horizontally
                              2.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],

                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xf2f2f2f2),
                            formDefine['backgroundColor']
                          ],Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _showItems(),
                        ),
                        ),
                      ),
                      child: 
                      ),
                      //),
                      //),
                      //],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: gDefaultPaddin),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: formDefine['top'] - gDefaultPaddin,
                                  ),
                                  datamodel.getFormDefineImage(formDefine),
                                  /*Expanded(
                                    child: formDefine['image'],
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );*/
      },
    );
  }
}
