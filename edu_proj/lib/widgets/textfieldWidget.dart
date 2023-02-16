// @dart=2.9
import 'dart:async';

import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:provider/provider.dart';

import 'myLabel.dart';

class DateFormatter extends TextInputFormatter {
  DateFormatter();
  String dateFormatter(value) {
    String nums = value.replaceAll(RegExp(r'[\D]'), '');
    String sSeg = '-';
    List listFormat = [];
    listFormat.add({
      'locFrom': 0,
      'locTo': 4,
      'type': 'i',
      'min': 1900,
      'max': 3000,
      'value:': ''
    });
    listFormat.add({
      'locFrom': 4,
      'locTo': 6,
      'type': 'm',
      'min': 1,
      'max': 12,
      'value:': ''
    });
    listFormat.add({
      'locFrom': 6,
      'locTo': 8,
      'type': 'd',
      'min': 1,
      'max': 31,
      'value:': ''
    });
    String result = '';
    /*for (int i = 0; i < listFormat.length; i++) {
      Map element = listFormat.elementAt(i);
      String type = element['type'];
      int locTo = element['locTo'];
      int locFrom = element['locFrom'];
      if (nums.length > locFrom) {
        String aSeg = '';
        for (int j = 0; j < ; j++) {
          Map aJ = listFormat.elementAt(j);
          result = result + aSeg + aJ['value'];
          aSeg = sSeg;
        }
        return result;
      }
      if (nums.length < locTo) {

      }
    }

    String sFormat = 'dddd-dd-dd';*/
    if (nums.length < 5) {
      return nums;
    }
    if (nums.length == 5) {
      String lastChar = nums.characters.last;
      result = nums.substring(0, 4) + sSeg;
      if (int.parse(lastChar) > 1) {
        result = result + '0';
      }
      result = result + lastChar;
      return result;
    }
    if (nums.length == 6) {
      result = nums.substring(0, 4) + sSeg;
      int iValue = int.parse(nums.substring(4, 6));
      if (iValue > 12 || iValue < 1) {
        return nums.substring(0, 4);
      }
      result = result + nums.substring(4, 6);
      return result;
    }
    if (nums.length == 7) {
      String lastChar = nums.characters.last;
      result = nums.substring(0, 4) + sSeg + nums.substring(4, 6) + sSeg;
      if (int.parse(lastChar) > 3) {
        result = result + '0';
      }
      result = result + lastChar;
      return result;
    }
    if (nums.length > 7) {
      result = nums.substring(0, 4) + sSeg + nums.substring(4, 6);
      int iValue = int.parse(nums.substring(6, 8));
      if (iValue > 31 || iValue < 1) {
        return result;
      }
      if (iValue > 28) {
        int month = int.parse(nums.substring(4, 6));
        if (month == 2) {
          int year = int.parse(nums.substring(0, 4));
          if (year % 4 > 0) {
            return result;
          }
        }
        if (iValue == 31 &&
            (month == 4 || month == 6 || month == 9 || month == 11)) {
          return result;
        }
      }
      result = result + sSeg + nums.substring(6, 8);
      return result;
    }
    return nums;
    /*String year = nums;

    if (nums.length > 3) {
      year = nums.substring(0, 4);
    }
    if (nums.length > 4) {
      return year + seg;
    }

    String sDefault = '';
    String month = sDefault;
    if (nums.length > 4) {
      month = nums.substring(4, 5);
      int intValue = int.parse(month);
      if (intValue > 1) {
        month = '0' + month;
        return year + '-' + month;
      }
    }
    if (nums.length > 5) {
      month = nums.substring(4, 6);
      int intValue = int.parse(month);
      if (intValue > 12) {
        return year + '-';
      }
    }
    String day = sDefault;
    if (nums.length > 6) {
      day = nums.substring(6, 7);
      int intValue = int.parse(day);
      if (intValue > 3) {
        day = '0' + day;
        return year + '-' + month + '-' + day;
      }
    }

    if (nums.length > 7) {
      day = nums.substring(6, 8);
      int intValue = int.parse(day);
      if (intValue > 31) {
        return year + '-' + month + '-';
      }
    }

    return year + '-' + month + '-' + day;*/
    //}

    //if (nums.length > 4) {
    /* day = nums.substring(6, 8);
    //}
    //if (day.length > 2) {
    //day = day.substring(0, 2);
    //}
    if (month.length > 0) {
      int intMonth = int.parse(month);
      if (intMonth > 12 || intMonth < 1) {
        month = sDefault;
        day = sDefault;
      } else {
        if (intMonth > 1 && intMonth < 10) {
          month = '0' + month;
          day = sDefault;
        } else if (day.length > 0) {
          int intDay = int.parse(day);
          if (intDay > 31 || intDay < 1) {
            day = sDefault;
          } else if (intDay == 31 &&
              (intMonth == 2 ||
                  intMonth == 4 ||
                  intMonth == 6 ||
                  intMonth == 9 ||
                  intMonth == 11)) {
            day = sDefault;
          } else if (intDay == 30 && intMonth == 2) {
            day = sDefault;
          } else if (intDay == 29) {
            int intYear = int.parse(year);
            if (intYear % 4 > 0) {
              day = sDefault;
            }
          }
        }
      }
    }

    String result = year;
    if (year.length == 4) {
      result = result + "-";
      result = result + month;
      if (month.length == 2) {
        result = result + "-";
        result = result + day;
      }
    }

    return result;*/
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    return newValue.copyWith(
        text: dateFormatter(text),
        selection:
            new TextSelection.collapsed(offset: dateFormatter(text).length));
  }
}

class InternationalPhoneFormatter extends TextInputFormatter {
  InternationalPhoneFormatter();
  String internationalPhoneFormat(value) {
    String nums = value.replaceAll(RegExp(r'[\D]'), '');
    String internationalPhoneFormatted = nums.length >= 1
        ? (nums.length > 0 ? ' (' : '') +
            nums.substring(0, nums.length >= 3 ? 3 : null) +
            (nums.length > 3 ? ') ' : '') +
            (nums.length > 3
                ? nums.substring(3, nums.length >= 6 ? 6 : null) +
                    (nums.length > 6
                        ? '-' + nums.substring(6, nums.length >= 10 ? 10 : null)
                        : '')
                : '')
        : nums;
    return internationalPhoneFormatted;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    return newValue.copyWith(
        text: internationalPhoneFormat(text),
        selection: new TextSelection.collapsed(
            offset: internationalPhoneFormat(text).length));
  }
}

class TextFieldWidget extends StatelessWidget {
  final MapEntry<dynamic, dynamic> item;
  final int backcolor;
  final dynamic formname;
  final dynamic tablename;
  final dynamic id;
  final _debouncer = Debouncer(milliseconds: 500);
  TextFieldWidget(
      {this.item, this.backcolor, this.formname, this.tablename, this.id});
  _getWidth() {
    return null;
    //item.value[gWidth] ?? null;
  }

  textChange(dynamic text, MapEntry item, DataModel datamodel,
      BuildContext context, bool isForm) {
    //item.value[gValue] = text;
    if (!isForm) {
      datamodel.setTableValueItem(tablename, item.value[gId], id, text);
      datamodel.myNotifyListeners();
      return;
    }

    if (item.value[gDroplist] == '') {
      item.value[gValue] = text;
    }
    if (item.value[gType] == gAddress) {
      item.value[gAction] = gLocalAction;
      item.value[gFormName] = formname;
    }
    if ((item.value[gAction] ?? '') == '') {
      return;
    }
    item.value[gSearch] = text;
    datamodel.sendRequestOne(
        item.value[gAction], item, item.value[gContext] ?? context);
  }

  setItemI(item, value, DataModel datamodel) {
    bool isForm = !datamodel.isNull(formname);
    dynamic name = formname;
    if (!isForm) {
      name = tablename;
    }
    if (isForm) {
      datamodel.setFormValue(name, item.value[gId], value);
      //datamodel.setFormValueShow(formname, item.value[gId]);
      datamodel.setFormNextFocus(name, item.value[gId]);
    } else {
      datamodel.setTableValue(name, item.value[gId], id, value);
      //datamodel.setFormValueShow(formname, item.value[gId]);
      datamodel.setTableNextFocus(name, item.value[gId], id);
    }

    datamodel.dpList[gAddress + '_' + name + '_' + item.value[gId]] = null;

    datamodel.myNotifyListeners();
  }

  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      bool isPassword = (item.value[gType] == gPassword);
      bool isForm = !datamodel.isNull(formname);
      if (isPassword) {
        item.value[gPasswordShow] = item.value[gPasswordShow] ?? true;

        item.value[gSuffixIcon] = IconButton(
            icon: Icon(
              item.value[gPasswordShow]
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Theme.of(context).disabledColor,
            ),
            onPressed: () {
              item.value[gPasswordShow] = !item.value[gPasswordShow];
              datamodel.myNotifyListeners();
            });
      }
      if ((item.value[gType] == gDate || item.value[gDroplist] != '') &&
          (item.value[gType] ?? "") != gLabel) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(
              (item.value[gShowDetail] ?? false)
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              //color: Theme.of(context).disabledColor,
            ),
            onPressed: () {
              item.value[gShowDetail] = !(item.value[gShowDetail] ?? false);
              datamodel.setFormFocus(formname, item.value[gId]);

              if (item.value[gShowDetail]) {
                Widget w = datamodel.getItemSubWidget(
                    item, formname, context, tablename, id);
                //getItemSubWidget(item);
                //Widget w = datamodel.itemSubList[item.value[gType]];
                datamodel.showPopup(context, w);
              }

              //datamodel.myNotifyListeners();
            });
      }
      if (item.value[gType] == gEmail) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(Icons.email_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              //datamodel.setFormFocus(formname, item.value[gId]);
              datamodel.sendEmail(item.value[gValue]);
            });
      }
      if (item.value[gType] == gPhone) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(Icons.phone_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              //datamodel.setFormFocus(formname, item.value[gId]);
              datamodel.phonecall(item.value[gValue]);
            });
      }
      if (item.value[gType] == gUrl) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(Icons.web_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              //datamodel.setFormFocus(formname, item.value[gId]);
              datamodel.loadUrl(item.value[gValue]);
            });
      }
      if (item.value[gIsFile] == true) {
        item.value[gSuffixIcon] = IconButton(
            icon: Icon(Icons.file_upload_outlined
                //color: Theme.of(context).disabledColor,
                ),
            onPressed: () {
              datamodel.loadFile(formname, item);
            });
      }

      item.value[gTxtEditingController].selection = TextSelection.fromPosition(
          TextPosition(offset: item.value[gTxtEditingController].text.length));
      Color cBackColor = datamodel.fromBdckcolor(backcolor);
      TextEditingController txtController = item.value[gTxtEditingController];
      if (datamodel.isNull(txtController.text)) {
        txtController.text = "";
      } else {
        dynamic aValue =
            datamodel.getValueByType(item.value[gValue], item.value);
        /*if (item.value[gDroplist] != '') {
          aValue = datamodel.getSCurrent(aValue);
        }*/
        txtController.text = aValue;
      }
      getItemSubWidget(item) {
        if (item.value[gType] == gAddress &&
            datamodel.dpList[
                    gAddress + '_' + formname + '_' + item.value[gId]] !=
                null &&
            datamodel.dpList[gAddress + '_' + formname + '_' + item.value[gId]]
                    .length >
                0) {
          return SizedBox(
            height: gSizedboxHeight,
            child: ListView.builder(
                itemCount: datamodel
                    .dpList[gAddress + '_' + formname + '_' + item.value[gId]]
                    .length,
                itemBuilder: (context, index) {
                  final anItem = datamodel.dpList[
                      gAddress + '_' + formname + '_' + item.value[gId]][index];
                  return InkWell(
                    child: MyLabel({
                      gLabel: anItem,
                    }, backcolor),
                    onTap: () {
                      setItemI(item, anItem, datamodel);
                    },
                  );
                }),
          );
        } else if (item.value[gType] == gDate &&
            (item.value[gShowDetail] ?? false)) {
          item.value[gFocus] = true;
          return datamodel.getDatePicker(item.value[gValue], backcolor, context,
              formname, item.value[gId]);
        } else if (item.value[gDroplist] != '' &&
            (item.value[gShowDetail] ?? false)) {
          item.value[gFocus] = true;
          return datamodel.getDPPicker(
              item, backcolor, context, formname, item.value[gId]);
        }
        return SizedBox(
          height: 0.0,
        );
      }

      getItemFormatters(item) {
        if ((item.value[gType] ?? "") == gPhone) {
          return [InternationalPhoneFormatter()];
        } else if ((item.value[gType] ?? "") == gDate) {
          return [DateFormatter()];
        }
        return null;
      }

      Widget subWidget = getItemSubWidget(item);
      if (subWidget != null) {
        datamodel.itemSubList[item.value[gType]] = subWidget;
      }

      return Container(
        width: _getWidth(),
        child: Column(
          children: [
            Focus(
              onKey: (node, event) {
                String keyLabel = event.logicalKey.keyLabel;
                if (keyLabel == 'Tab') {
                  //print('================' + event.logicalKey.keyLabel);
                  if (isForm) {
                    datamodel.setFormNextFocus(formname, item.value[gId]);
                  } else {
                    datamodel.setTableNextFocus(tablename, item.value[gId], id);
                  }

                  datamodel.myNotifyListeners();
                } else {}
                return KeyEventResult.ignored;
              },
              child: TextFormField(
                controller: txtController,
                autofocus: item.value[gFocus] ?? false,
                //focusNode: item.value[gFocusNode],
                keyboardType: datamodel.getInputType(item.value[gInputType]),
                maxLength: isForm ? item.value[gLength] : null,
                style: TextStyle(
                  color: cBackColor,
                  fontSize: item.value[gFontSize],
                  fontStyle: item.value[gFontStyle],
                  fontWeight: item.value[gFontWeight],
                  letterSpacing: item.value[gLetterSpacing],
                ),
                decoration: isForm
                    ? InputDecoration(
                        labelText: datamodel.getSCurrent(item.value[gLabel]),
                        labelStyle: TextStyle(
                          color: cBackColor,
                          fontSize: item.value[gFontSize],
                          fontStyle: item.value[gFontStyle],
                          fontWeight: item.value[gFontWeight],
                          letterSpacing: item.value[gLetterSpacing],
                        ),
                        hintText: item.value[gPlaceHolder],
                        hintStyle: TextStyle(
                          color: cBackColor,
                          fontSize: item.value[gFontSize],
                          fontStyle: item.value[gFontStyle],
                          fontWeight: item.value[gFontWeight],
                          letterSpacing: item.value[gLetterSpacing],
                        ),
                        suffixIcon: item.value[gSuffixIcon],
                        //prefixIcon: item.value['prefixIcon'],
                        enabled: ((item.value[gType] ?? "") != gLabel))
                    : InputDecoration(
                        border: new OutlineInputBorder(
                          //添加边框
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        isDense: true, // Added this
                        //contentPadding: EdgeInsets.all(2.0),
                        suffixIcon: item.value[gSuffixIcon],
                        enabled: ((item.value[gType] ?? "") != gLabel)),
                obscureText: isPassword && item.value[gPasswordShow],
                inputFormatters: getItemFormatters(item),
                validator: (dynamic value) {
                  if (item.value[gRequired] && value.isEmpty) {
                    return datamodel.getSCurrent(
                        gIsrequired + "{" + item.value[gLabel] + "}");
                  }
                  if (item.value[gType] == gEmail &&
                      !value.isEmpty &&
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return datamodel
                        .getSCurrent(gInvalidname + "{" + gEmail + "}");
                  }
                  if (item.value[gMinLength] != null &&
                      item.value[gMinLength] != '0' &&
                      value.length < item.value[gMinLength]) {
                    return datamodel.getSCurrent(gMininput +
                        "{" +
                        item.value[gMinLength] +
                        "}{" +
                        item.value[gUnit] +
                        "}");
                  }
                  if (item.value[gLength] != null &&
                      item.value[gLength] != '0' &&
                      value.length > item.value[gLength]) {
                    return datamodel.getSCurrent(gMaxinput +
                        "{" +
                        item.value[gLength] +
                        "}{" +
                        item.value[gUnit] +
                        "}");
                  }
                  return null;
                },
                onSaved: (dynamic value) {
                  textChange(value, item, datamodel, context, isForm);
                  //item.value[gValue] = value;
                },
                onChanged: (text) {
                  _debouncer.run(
                      () => textChange(text, item, datamodel, context, isForm));
                },
                onTap: () {
                  if (!isForm) {
                    return;
                  }
                  //set focus
                  datamodel.setFormFocus(formname, item.value[gId]);
                },
                onEditingComplete: () {
                  if (isForm) {
                    datamodel.setFormNextFocus(formname, item.value[gId]);
                  } else {
                    datamodel.setTableNextFocus(tablename, item.value[gId], id);
                  }
                  datamodel.myNotifyListeners();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
