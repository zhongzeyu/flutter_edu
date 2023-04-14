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
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: /*PinCodeTextField(
            appContext: context,
            autoFocus: true,
            //autoDismissKeyboard: true,
            length: _param[gLength],
            controller: _param['teController'],
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
            enableActiveFill: true,
            //autoDisposeControllers: false,
            onCompleted: (code) {
              _param['teController'].text = code;
              datamodel.setValueModified(_formName, _param[gId], null, code);
              //    textEditingController.text = pin;
            },
            onChanged: (dynamic value) {
              //textEditingController.text = value;
            },
          )*/
            PinCodeTextField(
                appContext: context,
                //autoDisposeControllers: false,
                autoFocus: true,
                length: _param[gLength],
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                    borderRadius: BorderRadius.circular(10),
                    shape: PinCodeFieldShape.box,
                    activeColor: Colors.white,
                    selectedColor: Colors.white,
                    inactiveColor: Colors.white,
                    fieldHeight: 40,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white),
                cursorColor: Colors.black,
                autoDisposeControllers: false,
                autoDismissKeyboard: true,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: _param[gTextController],
                keyboardType: TextInputType.number,
                onCompleted: (code) {
                  _param[gTextController].text = code;
                  datamodel.setValue(_formName, _param[gId], null, code, gForm);
                },
                onChanged: (code) {
                  //_param['teController'].text = code;
                }),

        /*PinCodeTextField(
            appContext: context,
            autoFocus: true,
            //autoDismissKeyboard: true,
            length: _param[gLength],
            controller: teController,
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
            enableActiveFill: true,
            //autoDisposeControllers: false,
            onCompleted: (pin) {
              datamodel.setValueModified(_formName, _param[gId], null, pin);
              //    textEditingController.text = pin;
            },
            onChanged: (dynamic value) {
              //textEditingController.text = value;
            },
          )*/
      );
    });
  }
}
