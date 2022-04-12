import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDropdown extends StatelessWidget {
  final dynamic _param;
  final String _formName;
  MyDropdown(this._param, this._formName);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            child: DropdownButton<String>(
              value: _param[gValue],
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                datamodel.setDropdownMenuItem(
                    _param, newValue, context, _formName);
              },
              items: datamodel.getDropdownMenuItem(
                  _param[gDroplist], null, context),
            ),
          ));
    });
  }
}
