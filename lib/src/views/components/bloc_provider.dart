import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/disposable.dart';

/// Most of the code is copied from Provider package.
///
/// I don't use Provider({create, dispose, child}) because value created by
/// [create] callback is a state and it wont update after initState(). Using
/// Provider.value() works but it doesn't have dispose. So I have to create
/// my custom BlocProvider class which automatically dispose bloc but recreate
/// bloc when new bloc is passed in
class BlocProvider<T extends Disposable> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
    this.dispose = true,
  }) : super(key: key);

  final T bloc;
  final Widget child;
  /// Should dispose bloc when this widget is disposed
  final bool dispose;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  /// Obtains the nearest [Provider<T>] up its widget tree and returns its
  /// value.
  ///
  /// If [listen] is `true` (default), later value changes will trigger a new
  /// [State.build] to widgets, and [State.didChangeDependencies] for
  /// [StatefulWidget].
  static T of<T>(BuildContext context, {bool listen = true}) {
    // this is required to get generic Type
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>()
        : context
            .getElementForInheritedWidgetOfExactType<InheritedProvider<T>>()
            ?.widget as InheritedProvider<T>;

    if (provider == null) {
      throw ProviderNotFoundError(T, context.widget.runtimeType);
    }

    return provider._value;
  }
}

class _BlocProviderState<T extends Disposable> extends State<BlocProvider> {
  @override
  void dispose() {
    super.dispose();

    if (widget.dispose)
      widget.bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      value: widget.bloc,
      child: widget.child,
    );
  }
}

/// A generic implementation of an [InheritedWidget].
///
/// Any descendant of this widget can obtain `value` using [Provider.of].
///
/// Do not use this class directly unless you are creating a custom "Provider".
/// Instead use [Provider] class, which wraps [InheritedProvider].
class InheritedProvider<T> extends InheritedWidget {
  /// Allow customizing [updateShouldNotify].
  const InheritedProvider({
    Key key,
    @required T value,
    UpdateShouldNotify<T> updateShouldNotify,
    Widget child,
  })  : _value = value,
        _updateShouldNotify = updateShouldNotify,
        super(key: key, child: child);

  /// The currently exposed value.
  ///
  /// Mutating `value` should be avoided. Instead rebuild the widget tree
  /// and replace [InheritedProvider] with one that holds the new value.
  final T _value;
  final UpdateShouldNotify<T> _updateShouldNotify;

  @override
  bool updateShouldNotify(InheritedProvider<T> oldWidget) {
    if (_updateShouldNotify != null) {
      return _updateShouldNotify(oldWidget._value, _value);
    }
    return oldWidget._value != _value;
  }
}
