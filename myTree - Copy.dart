import 'package:edu_proj/config/constants.dart';
import 'package:edu_proj/models/DataModel.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:provider/provider.dart';

class MyTree extends StatefulWidget {
  final dynamic _param;
  MyTree(this._param);

  //MyTree({Key key, this.title}) : super(key: key);
  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyTree> {
  String _selectedNode;
  TreeViewController _treeViewController;
  bool docsOpen = true;
  bool deepExpanded = true;
  final Map<ExpanderPosition, Widget> expansionPositionOptions = const {
    ExpanderPosition.start: Text('Start'),
    ExpanderPosition.end: Text('End'),
  };
  final Map<ExpanderType, Widget> expansionTypeOptions = {
    ExpanderType.none: Container(),
    ExpanderType.caret: Icon(
      Icons.arrow_drop_down,
      size: 28,
    ),
    ExpanderType.arrow: Icon(Icons.arrow_downward),
    ExpanderType.chevron: Icon(Icons.expand_more),
    ExpanderType.plusMinus: Icon(Icons.add),
  };
  final Map<ExpanderModifier, Widget> expansionModifierOptions = const {
    ExpanderModifier.none: ModContainer(ExpanderModifier.none),
    ExpanderModifier.circleFilled: ModContainer(ExpanderModifier.circleFilled),
    ExpanderModifier.circleOutlined:
        ModContainer(ExpanderModifier.circleOutlined),
    ExpanderModifier.squareFilled: ModContainer(ExpanderModifier.squareFilled),
    ExpanderModifier.squareOutlined:
        ModContainer(ExpanderModifier.squareOutlined),
  };
  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;
  bool _allowParentSelect = true;
  bool _supportParentDoubleTap = false;

  @override
  void initState() {
    _treeViewController = TreeViewController(
      children: widget._param[gData][gNode],
      selectedKey: _selectedNode,
    );

    super.initState();
  }

  /*ListTile _makeExpanderPosition() {
    return ListTile(
      title: Text('Expander Position'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionPositionOptions,
        groupValue: _expanderPosition,
        onValueChanged: (ExpanderPosition newValue) {
          setState(() {
            _expanderPosition = newValue;
          });
        },
      ),
    );
  }

  // ignore: unused_element
  SwitchListTile _makeAllowParentSelect() {
    return SwitchListTile.adaptive(
      title: Text('Allow Parent Select'),
      dense: true,
      value: _allowParentSelect,
      onChanged: (v) {
        setState(() {
          _allowParentSelect = v;
        });
      },
    );
  }

  // ignore: unused_element
  SwitchListTile _makeSupportParentDoubleTap() {
    return SwitchListTile.adaptive(
      title: Text('Support Parent Double Tap'),
      dense: true,
      value: _supportParentDoubleTap,
      onChanged: (v) {
        setState(() {
          _supportParentDoubleTap = v;
        });
      },
    );
  }

  ListTile _makeExpanderType() {
    return ListTile(
      title: Text('Expander Style'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionTypeOptions,
        groupValue: _expanderType,
        onValueChanged: (ExpanderType newValue) {
          setState(() {
            _expanderType = newValue;
          });
        },
      ),
    );
  }

  ListTile _makeExpanderModifier() {
    return ListTile(
      title: Text('Expander Modifier'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionModifierOptions,
        groupValue: _expanderModifier,
        onValueChanged: (ExpanderModifier newValue) {
          setState(() {
            _expanderModifier = newValue;
          });
        },
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(builder: (context, datamodel, child) {
      TreeViewTheme _treeViewTheme = TreeViewTheme(
        expanderTheme: ExpanderThemeData(
            type: _expanderType,
            modifier: _expanderModifier,
            position: _expanderPosition,
            // color: Colors.grey.shade800,
            size: 20,
            color: Colors.blue),
        labelStyle: TextStyle(
          fontSize: 16,
          letterSpacing: 0.3,
        ),
        parentLabelStyle: TextStyle(
          fontSize: 16,
          letterSpacing: 0.1,
          fontWeight: FontWeight.w800,
          color: Colors.blue.shade700,
        ),
        iconTheme: IconThemeData(
          size: 18,
          color: Colors.grey.shade800,
        ),
        colorScheme: Theme.of(context).colorScheme,
      );
      return Scaffold(
        /*appBar: AppBar(
        title: Text(widget._param[gTitle]),
        elevation: 0,
      ),*/
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            padding: EdgeInsets.all(20),
            height: double.infinity,
            child: Column(
              children: <Widget>[
                /*Container(
                height: 160,
                child: Column(
                  children: <Widget>[
                    //_makeExpanderPosition(),
                    //_makeExpanderType(),
                    //_makeExpanderModifier(),
                    //_makeAllowParentSelect(),
                    //_makeSupportParentDoubleTap(),
                  ],
                ),
              ),*/
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: TreeView(
                      controller: _treeViewController,
                      allowParentSelect: _allowParentSelect,
                      supportParentDoubleTap: _supportParentDoubleTap,
                      onExpansionChanged: (key, expanded) {
                        _expandNode(key, expanded);
                        widget._param[gValue] = key;
                        widget._param[gLabel] = gTreeExpand;
                        widget._param[gMove] =
                            expanded ? gExpanded : gCollapsed;
                        if (widget._param[gAction] != null &&
                            widget._param[gAction].toString().length > 0) {
                          widget._param[gValue] = key;
                          datamodel.sendRequestOne(
                              widget._param[gAction],
                              widget._param,
                              widget._param[gContext] ?? context);
                        }
                      },
                      onNodeTap: (key) {
                        debugPrint('Selected: $key');
                        setState(() {
                          _selectedNode = key;
                          _treeViewController =
                              _treeViewController.copyWith(selectedKey: key);
                        });
                        widget._param[gValue] = key;
                        widget._param[gLabel] = gTreeSelected;
                        widget._param[gMove] = '';
                        widget._param[gTreeLabel] =
                            _treeViewController.getNode(_selectedNode).label ??
                                "";
                        if (widget._param[gAction] != null &&
                            widget._param[gAction].toString().length > 0) {
                          widget._param[gValue] = key;
                          datamodel.sendRequestOne(
                              widget._param[gAction],
                              widget._param,
                              widget._param[gContext] ?? context);
                        }
                      },
                      theme: _treeViewTheme,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint('Close Keyboard');
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Text(
                        _treeViewController.getNode(_selectedNode) == null
                            ? ''
                            : _treeViewController.getNode(_selectedNode).label),
                  ),
                )
              ],
            ),
          ),
        ),
        /*bottomNavigationBar: SafeArea(
        top: false,
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CupertinoButton(
              child: Text('Node'),
              onPressed: () {
                setState(() {
                  _treeViewController = _treeViewController.copyWith(
                    children: _nodes,
                  );
                });
              },
            ),
            CupertinoButton(
              child: Text('Deep'),
              onPressed: () {
                String deepKey = 'jh1b';
                setState(() {
                  if (deepExpanded == false) {
                    List<Node> newdata =
                        _treeViewController.expandToNode(deepKey);
                    _treeViewController =
                        _treeViewController.copyWith(children: newdata);
                    deepExpanded = true;
                  } else {
                    _treeViewController =
                        _treeViewController.withCollapseToNode(deepKey);
                    deepExpanded = false;
                  }
                });
              },
            ),
            CupertinoButton(
              child: Text('Edit'),
              onPressed: () {
                TextEditingController editingController = TextEditingController(
                    text: _treeViewController.selectedNode.label);
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text('Edit Label'),
                        content: Container(
                          height: 80,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: CupertinoTextField(
                            controller: editingController,
                            autofocus: true,
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            isDestructiveAction: true,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          CupertinoDialogAction(
                            child: Text('Update'),
                            isDefaultAction: true,
                            onPressed: () {
                              if (editingController.text.isNotEmpty) {
                                setState(() {
                                  Node _node = _treeViewController.selectedNode;
                                  _treeViewController =
                                      _treeViewController.withUpdateNode(
                                          _treeViewController.selectedKey,
                                          _node.copyWith(
                                              label: editingController.text));
                                });
                                debugPrint(editingController.text);
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),*/
      );
    });
  }

  _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);

    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated;
      if (key == 'docs') {
        updated = _treeViewController.updateNode(
            key,
            node.copyWith(
              expanded: expanded,
              icon: expanded ? Icons.folder_open : Icons.folder,
            ));
      } else {
        updated = _treeViewController.updateNode(
            key, node.copyWith(expanded: expanded));
      }
      setState(() {
        if (key == 'docs') docsOpen = expanded;
        _treeViewController = _treeViewController.copyWith(children: updated);
      });
    }
  }
}

class ModContainer extends StatelessWidget {
  final ExpanderModifier modifier;

  const ModContainer(this.modifier, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.transparent;
    Color _backAltColor = Colors.grey.shade700;
    switch (modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.circleOutlined:
        _borderWidth = 1;
        _shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.squareOutlined:
        _borderWidth = 1;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        shape: _shapeBorder,
        border: _borderWidth == 0
            ? null
            : Border.all(
                width: _borderWidth,
                color: _backAltColor,
              ),
        color: _backColor,
      ),
      width: 15,
      height: 15,
    );
  }
}
