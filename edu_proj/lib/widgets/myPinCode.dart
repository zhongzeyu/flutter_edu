import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class MyPinCode extends StatelessWidget {
  final dynamic _param;
  final dynamic _formName;
  MyPinCode(this._param, this._formName);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Padding(
          padding: const EdgeInsets.all(18.0),
          child: PinCodeTextField(
            appContext: context,
            autoFocus: true,
            autoDismissKeyboard: true,
            length: _param[gLength],
            controller: textEditingController,
//onChanged: (pin) => _registerVerifyController.onChange(pin),
            keyboardType: TextInputType.number,
//enabled: !_registerVerifyController.isLoading.value,
            pinTheme: PinTheme(
              fieldWidth: 40,
              fieldHeight: 40,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              inactiveColor: Theme.of(context).colorScheme.primary,
            ),
            animationType: AnimationType.scale,
            /*dialogConfig: DialogConfig(
              dialogTitle: 'Past Code',
              dialogContent: 'Do you want to paste ',
              affirmativeText: 'Paste',
              negativeText: 'Cancel',
            ),*/
            //onCompleted: (pin) => datamodel.setDropdownMenuItem(
            //  _param, pin, context, _formName),
            //onCompleted: (pin) => datamodel.formSubmit(context, _formName),
            onCompleted: (pin) {
              datamodel.setFormValue(_formName, _param[gId], pin);
            },
            onChanged: (dynamic value) {},
            /*onChanged: (dynamic value) {
              var email =
                  datamodel.getFormValue(gLogin, gEmail, gTxtEditingController);
              datamodel.setFormValue(
                  _formName, _param[gId], email + gDelimeterItem + value);
            },*/
          ));
    });
  }
}
