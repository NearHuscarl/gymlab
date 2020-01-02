import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'gym_icons.dart';
import '../../blocs/equipment_filter_bloc.dart';
import '../../models/exercise_summary.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/enum.dart';

class EquipmentFilter extends StatefulWidget {
  EquipmentFilter({this.expand, this.onFilterChanged});

  final bool expand;
  final ValueChanged<EquipmentFilterData> onFilterChanged;

  @override
  _EquipmentFilterState createState() => _EquipmentFilterState();
}

class _EquipmentFilterState extends State<EquipmentFilter>
    with SingleTickerProviderStateMixin {
  EquipmentFilterBloc bloc;
  Animation<Offset> _slideAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    bloc = EquipmentFilterBloc(onFilterChange: widget.onFilterChanged);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void didUpdateWidget(EquipmentFilter oldWidget) {
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
    bloc.dispose();
    super.dispose();
  }

  IconData _getIcon(Equipment equipment) {
    switch (equipment) {
      case Equipment.barbell:
        return GymIcons.barbell;
      case Equipment.ezBar:
        return GymIcons.ezbar;
      case Equipment.kettleBell:
        return GymIcons.kettlebell;
      case Equipment.bar:
        return GymIcons.bar;
      case Equipment.bodyOnly:
        return GymIcons.bodyonly;
      case Equipment.cable:
        return GymIcons.cable;
      case Equipment.dumbbell:
        return GymIcons.dumbbell;
      case Equipment.machine:
        return GymIcons.machine;
      case Equipment.weightPlate:
        return GymIcons.weightplate;
      case Equipment.exerciseBall:
        return GymIcons.exerciseball;
      case Equipment.other:
        return GymIcons.equipment;
      default:
        return GymIcons.equipment;
    }
  }

  Widget _buildFilterChip(Equipment equipment) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: bloc.include,
      builder: (context, snapshot) {
        final include = snapshot.data;
        return StreamBuilder<List<Equipment>>(
          initialData: [],
          stream: bloc.selectedEquipments,
          builder: (context, snapshot) {
            final selected = snapshot.data.any((eq) => eq == equipment);
            return _FilterChip(
              text: EnumHelper.parseWord(equipment),
              icon: _getIcon(equipment),
              selected: selected,
              selectedColor: include ? Colors.green : Colors.amber.shade800,
              onPressed: (value) => bloc.toggleOption(equipment, value),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.primaryColor.darken();
    final actions = Wrap(
      spacing: 6.0,
      children: <Widget>[
        _ActionChip(
          text: 'Clear all',
          icon: FontAwesomeIcons.timesCircle,
          iconSize: 19,
          onPressed: () => bloc.clearAll(),
        ),
        StreamBuilder<bool>(
          initialData: false,
          stream: bloc.include,
          builder: (context, snapshot) {
            final include = snapshot.data;
            return _ActionChip(
              text: include ? 'Include' : 'Exclude',
              icon: include
                  ? FontAwesomeIcons.plusSquare
                  : FontAwesomeIcons.minusSquare,
              iconSize: 19,
              onPressed: () => bloc.toggleInclude(),
            );
          },
        ),
      ],
    );
    final filters = Wrap(
      spacing: 6.0,
      alignment: WrapAlignment.center,
      children: Equipment.values
          .where((e) => e != Equipment.none)
          .map<Widget>(_buildFilterChip)
          .toList(),
    );

    return SlideTransition(
      position: _slideAnimation,
      child: Stack(
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
                actions,
                filters,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  _ActionChip({this.text, this.icon, this.iconSize, this.onPressed});

  final String text;
  final IconData icon;
  final double iconSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = AppColors.white85;

    return ActionChip(
      label: Text(
        text,
      ),
      labelStyle: TextStyle(color: textColor),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: EdgeInsets.only(left: 6, top: 4, bottom: 4),
      avatar: Icon(
        icon,
        size: iconSize,
        color: textColor,
      ),
      backgroundColor: theme.accentColor,
      onPressed: onPressed,
    );
  }
}

class _FilterChip extends StatelessWidget {
  _FilterChip(
      {this.text,
      this.icon,
      this.iconSize,
      this.selectedColor,
      @required this.onPressed,
      this.selected});

  final String text;
  final IconData icon;
  final double iconSize;
  final bool selected;
  final Color selectedColor;
  final ValueChanged<bool> onPressed;

  Color _textColor(ThemeData theme) =>
      selected ? Colors.white : theme.accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(
        text,
      ),
      labelStyle: TextStyle(
        color: _textColor(theme),
      ),
      selected: selected,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: EdgeInsets.only(left: 6, top: 4, bottom: 4),
      avatar: Icon(
        icon,
        size: iconSize,
        color: _textColor(theme),
      ),
      backgroundColor: theme.accentColor.withOpacity(.1),
      selectedColor: selectedColor,
      onSelected: (value) => onPressed(value),
    );
  }
}
