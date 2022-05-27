import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class MyPinCode extends StatelessWidget {
  final dynamic _param;
  final String _formName;
  MyPinCode(this._param, this._formName);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            child: PinCodeTextField(
              appContext: context,
              length: _param[gLength],
//onChanged: (pin) => _registerVerifyController.onChange(pin),
              keyboardType: TextInputType.number,
//enabled: !_registerVerifyController.isLoading.value,
              pinTheme: PinTheme(
                fieldWidth: 40,
                fieldHeight: 48,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                inactiveColor: Theme.of(context).colorScheme.primary,
              ),
              animationType: AnimationType.scale,
              dialogConfig: DialogConfig(
                dialogTitle: 'Past Code',
                dialogContent: 'Do you want to paste ',
                affirmativeText: 'Paste',
                negativeText: 'Cancel',
              ),
              //onCompleted: (pin) => datamodel.setDropdownMenuItem(
              //  _param, pin, context, _formName),
              onChanged: (String value) {
                var email = datamodel.getFormValue(
                    gLogin, gEmail, gTxtEditingController);
                datamodel.setFormValue(
                    _formName, _param[gId], email + gDelimeterItem + value);
              },
            ),
          ));
    });
  }
}
