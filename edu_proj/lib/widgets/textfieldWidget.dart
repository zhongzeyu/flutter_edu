import 'package:edu_proj/config/MyConfig.dart';
//import 'package:edu_proj/generated/l10n.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWidget extends StatelessWidget {
  final MapEntry<dynamic, dynamic> item;
  //final IconData suffixIconData;
  //final Function onChanged;

  TextFieldWidget({
    this.item,
  });

  _getWidth() {
    return item.value['width'];
  }

  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Container(
        width: _getWidth(),
        child: TextFormField(
          controller: item.value['txtEditingController'],

          autofocus: true,
          keyboardType: item.value['inputType'],
          maxLength: item.value['length'],
          style: TextStyle(
            //color: item.value['textFontColor'],
            fontSize: item.value['fontSize'],
            fontStyle: item.value['fontStyle'],
            fontWeight: item.value['fontWeight'],
            letterSpacing: item.value['letterSpacing'],
          ),
          decoration: InputDecoration(
            labelText: datamodel.getSCurrent(item.value['label']),
            labelStyle: TextStyle(
              //color: item.value['textFontColor'],
              fontSize: item.value['fontSize'],
              fontStyle: item.value['fontStyle'],
              fontWeight: item.value['fontWeight'],
              letterSpacing: item.value['letterSpacing'],
            ),
            hintText: item.value['placeholder'],
            hintStyle: TextStyle(
              //color: item.value['textFontColor'],
              fontSize: item.value['fontSize'],
              fontStyle: item.value['fontStyle'],
              fontWeight: item.value['fontWeight'],
              letterSpacing: item.value['letterSpacing'],
            ),
            suffixIcon: item.value['suffixIcon'],
            //prefixIcon: item.value['prefixIcon'],
          ),
          obscureText: (item.value['type'] == MyConfig.PASSWORD.name),
          validator: (String value) {
            if (item.value['required'] && value.isEmpty) {
              return datamodel.getSCurrent(['isrequired', item.value['label']]);
              //return S.of(context).isrequired(item.value['label']);
            }
            if (item.value['type'] == 'email' &&
                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
              return datamodel.getSCurrent(['invalidname', 'email']);
              //return S.of(context).invalidname(S.of(context).email);
            }
            if (item.value['minLength'] != '0' &&
                value.length < item.value['minLength']) {
              /*return S
                  .of(context)
                  .mininput(item.value['minLength'], item.value['unit']);*/
              return datamodel.getSCurrent(
                  ['mininput', item.value['minLength'], item.value['unit']]);
            }
            if (item.value['length'] != '0' &&
                value.length > item.value['length']) {
              return datamodel.getSCurrent(
                  ['maxinput', item.value['length'], item.value['unit']]);
              /*return S
                  .of(context)
                  .maxinput(item.value['length'], item.value['unit']);*/
            }
            return null;
          },
          //initialValue: item.value['defaultValue'],
          onSaved: (String value) {
            item.value['value'] = value;
          },
        ),
      );
    });
  }
}
