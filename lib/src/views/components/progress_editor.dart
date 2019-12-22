import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../blocs/progress_editor_bloc.dart';
import '../../helpers/dart_helper.dart';
import '../../helpers/constants.dart';

class ProgressEditor extends StatefulWidget {
  ProgressEditor({Key key, this.expand}) : super(key: key);

  final bool expand;

  @override
  ProgressEditorState createState() => ProgressEditorState();
}

class ProgressEditorState extends State<ProgressEditor>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _slideAnimation;
  AnimationController _controller;
  var _focusNodes = List<FocusNode>();
  var _controllers = List<TextEditingController>();

  DateTime date = ProgressEditorBloc.initialDate;
  List<List<String>> get data {
    return _controllers.map((c) => c.text).group(2, emptyValue: '-1');
  }

  void saveData() => Provider.of<ProgressEditorBloc>(context).saveData(data);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOut,
    ));
  }

  var _initData = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initData) {
      _setDate(ProgressEditorBloc.initialDate);
      _initData = true;
    }
  }

  @override
  void didUpdateWidget(ProgressEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.expand != oldWidget.expand) {
      if (widget.expand) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNodes.forEach((f) => f.dispose());
    _controllers.forEach((c) => c.dispose());
    super.dispose();
  }

  FocusNode _getFocusNode(int index) {
    if (index > _focusNodes.length - 1) {
      _focusNodes.add(FocusNode());
    }
    return _focusNodes[index];
  }

  TextEditingController _getTextController(int index) {
    if (index > _controllers.length - 1) {
      _controllers.add(TextEditingController());
    }
    return _controllers[index];
  }

  void _setDate(DateTime dateTime) {
    _focusNodes.forEach((f) => f.unfocus());

    final bloc = Provider.of<ProgressEditorBloc>(context);

    if (dateTime != null) {
      // clear all text in TextFields so next time new data is fetched
      // the TextFields will not show cache data
      _controllers.forEach((c) => c.clear());
      this.date = dateTime;
      bloc.setDate(dateTime);
    }
  }

  void _selectDate(DateTime initialDate) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: Constants.startDateLimit,
      lastDate: Constants.endDateLimit,
    );
    _setDate(date);
  }

  Widget _textField(String value, int index, Function onFocus) {
    final controller = _getTextController(index);
    final focusNode = _getFocusNode(index);
    final nextFocusNode = _getFocusNode(index + 1);

    controller.text = value;
    // https://github.com/flutter/flutter/issues/11416#issuecomment-541435871
    // update Selection after repopulating existing TextField with new value.
    // Without this line, after you typed non-empty string, collapse and show
    // editor again, the Selection index will be out of bound (cannot type anything)
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      textAlign: TextAlign.right,
      style: TextStyle(color: Colors.white),
      focusNode: focusNode,
      maxLength: 6,
      onFieldSubmitted: (_) {
        final lastFocusNode = index == _focusNodes.length - 1;

        if (!lastFocusNode) {
          onFocus(index + 1);
          nextFocusNode.requestFocus();
        }
      },
      decoration: InputDecoration(
        isDense: true,
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.amber, width: 3),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.pink.shade300,
            width: 3,
          ),
        ),
        counterStyle: TextStyle(
          height: 0,
        ),
      ),
    );
  }

  DataCell _dataCell(String value, int index, List<WeightAndRep> stats) {
    final bloc = Provider.of<ProgressEditorBloc>(context);
    final insertNewRowIfNecessary = (int index) {
      final rowIndex = (index / 2).floor();
      if (rowIndex == stats.length - 1) {
        bloc.saveData(data);
        bloc.insertNewRow();
      }
    };

    return DataCell(
      GestureDetector(
        onTap: () {
          insertNewRowIfNecessary(index);
          _focusNodes[index].requestFocus();
        },
        child: AbsorbPointer(
          child: _textField(value, index, insertNewRowIfNecessary),
        ),
      ),
      showEditIcon: true,
      onTap: () {
        insertNewRowIfNecessary(index);
        _focusNodes[index].requestFocus();
      },
    );
  }

  List<DataRow> _getRows(List<WeightAndRep> stats) {
    var index = -1;
    return stats.map((d) {
      return DataRow(cells: [
        _dataCell(d.weightDisplay, ++index, stats),
        _dataCell(d.repDisplay, ++index, stats),
      ]);
    }).toList();
  }

  Widget _dataTable(List<WeightAndRep> stats) {
    return DataTable(
      dataRowHeight: 30,
      headingRowHeight: 30,
      columns: [
        DataColumn(label: Text('Weight (kg)'), numeric: true),
        DataColumn(label: Text('Repititions'), numeric: true),
      ],
      rows: _getRows(stats),
    );
  }

  Widget _buildDataTable(ProgressEditorBloc bloc) {
    return StreamBuilder<List<WeightAndRep>>(
      stream: bloc.stats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error),
          );
        }
        if (snapshot.hasData) {
          final stats = snapshot.data;
          return _dataTable(stats);
        }
        return _dataTable([WeightAndRep()]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = Provider.of<ProgressEditorBloc>(context);
    final backgroundColor = theme.primaryColor;

    final stack = Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        // Background above the top for easeOutBack animation curve
        Positioned.fill(
          top: -50,
          bottom: null,
          child: Container(
            color: backgroundColor,
            height: 50,
          ),
        ),
        Container(
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StreamBuilder<DateTime>(
                  stream: bloc.date,
                  initialData: ProgressEditorBloc.initialDate,
                  builder: (context, snapshot) {
                    final date = snapshot.data;
                    return FlatButton(
                      child: Text(DateFormat('dd/MM/yyyy').format(date)),
                      textColor: Colors.white,
                      onPressed: () => _selectDate(date),
                    );
                  }),
              _buildDataTable(bloc),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );

    return SlideTransition(
      position: _slideAnimation,
      child: Theme(
        data: theme.copyWith(
          // change all text below this widget to white
          brightness: Brightness.dark,
        ),
        child: stack,
      ),
    );
  }
}
