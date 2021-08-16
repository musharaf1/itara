/// Custom Expansion Panel
/// @Interface
/// [author] Praise Emerenini <Praigegeek@gmail.com>
// @dart=2.9

import 'package:flutter/material.dart';

const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension;
const double _kPanelHeaderExpandedHeight = 64.0;

class _SaltedKey<S, V> extends LocalKey {
  const _SaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final _SaltedKey<S, V> typedOther = other;
    return salt == typedOther.salt && value == typedOther.value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? '<\'$salt\'>' : '<$salt>';
    final String valueString = V == String ? '<\'$value\'>' : '<$value>';
    return '[$saltString $valueString]';
  }
}

typedef ExpansionPanelCallback = void Function(int panelIndex, bool isExpanded);

typedef ExpansionPanelHeaderBuilder = Widget Function(
    BuildContext context, bool isExpanded);

class ExpansionPanel {
  /// Creates an expansion panel to be used as a child for [ExpansionPanelList].
  /// See [ExpansionPanelList] for an example on how to use this widget.
  ///
  /// The [headerBuilder], [body], and [isExpanded] arguments must not be null.
  ExpansionPanel({
    @required this.headerBuilder,
    @required this.body,
    this.isExpanded = false,
    this.canTapOnHeader = false,
  })  : assert(headerBuilder != null),
        assert(body != null),
        assert(isExpanded != null),
        assert(canTapOnHeader != null);

  /// The widget builder that builds the expansion panels' header.
  final ExpansionPanelHeaderBuilder headerBuilder;

  /// The body of the expansion panel that's displayed below the header.
  ///
  /// This widget is visible only when the panel is expanded.
  final Widget body;

  /// Whether the panel is expanded.
  ///
  /// Defaults to false.
  final bool isExpanded;

  /// Whether tapping on the panel's header will expand/collapse it.
  ///
  /// Defaults to false.
  final bool canTapOnHeader;
}

class ExpansionPanelRadio extends ExpansionPanel {
  /// An expansion panel that allows for radio functionality.
  ///
  /// A unique [value] must be passed into the constructor. The
  /// [headerBuilder], [body], [value] must not be null.
  ExpansionPanelRadio({
    @required this.value,
    @required ExpansionPanelHeaderBuilder headerBuilder,
    @required Widget body,
    bool canTapOnHeader = false,
  })  : assert(value != null),
        super(
          body: body,
          headerBuilder: headerBuilder,
          canTapOnHeader: canTapOnHeader,
        );

  /// The value that uniquely identifies a radio panel so that the currently
  /// selected radio panel can be identified.
  final Object value;
}

class ExpansionPanelList extends StatefulWidget {
  /// Creates an expansion panel list widget. The [expansionCallback] is
  /// triggered when an expansion panel expand/collapse button is pushed.
  ///
  /// The [children] and [animationDuration] arguments must not be null.
  const ExpansionPanelList({
    Key key,
    this.children = const <ExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
  })  : assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = false,
        initialOpenPanelValue = null,
        super(key: key);

  const ExpansionPanelList.radio({
    Key key,
    this.children = const <ExpansionPanelRadio>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.initialOpenPanelValue,
  })  : assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = true,
        super(key: key);

  /// The children of the expansion panel list. They are laid out in a similar
  /// fashion to [ListBody].
  final List<ExpansionPanel> children;

  final ExpansionPanelCallback expansionCallback;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  // Whether multiple panels can be open simultaneously
  final bool _allowOnlyOnePanelOpen;

  /// The value of the panel that initially begins open. (This value is
  /// only used when initializing with the [ExpansionPanelList.radio]
  /// constructor.)
  final Object initialOpenPanelValue;

  @override
  State<StatefulWidget> createState() => _ExpansionPanelListState();
}

class _ExpansionPanelListState extends State<ExpansionPanelList> {
  ExpansionPanelRadio _currentOpenPanel;

  @override
  void initState() {
    super.initState();
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(),
          'All ExpansionPanelRadio identifier values must be unique.');
      if (widget.initialOpenPanelValue != null) {
        _currentOpenPanel =
            searchPanelByValue(widget.children, widget.initialOpenPanelValue);
      }
    }
  }

  @override
  void didUpdateWidget(ExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(),
          'All ExpansionPanelRadio identifier values must be unique.');
      // If the previous widget was non-radio ExpansionPanelList, initialize the
      // open panel to widget.initialOpenPanelValue
      if (!oldWidget._allowOnlyOnePanelOpen) {
        _currentOpenPanel =
            searchPanelByValue(widget.children, widget.initialOpenPanelValue);
      }
    } else {
      _currentOpenPanel = null;
    }
  }

  bool _allIdentifiersUnique() {
    final Map<Object, bool> identifierMap = <Object, bool>{};
    for (ExpansionPanelRadio child in widget.children) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final ExpansionPanelRadio radioWidget = widget.children[index];
      return _currentOpenPanel?.value == radioWidget.value;
    }
    return widget.children[index].isExpanded;
  }

  void _handlePressed(bool isExpanded, int index) {
    if (widget.expansionCallback != null)
      // ignore: curly_braces_in_flow_control_structures
      widget.expansionCallback(index, isExpanded);

    if (widget._allowOnlyOnePanelOpen) {
      final ExpansionPanelRadio pressedChild = widget.children[index];

      // If another ExpansionPanelRadio was already open, apply its
      // expansionCallback (if any) to false, because it's closing.
      for (int childIndex = 0;
          childIndex < widget.children.length;
          childIndex += 1) {
        final ExpansionPanelRadio child = widget.children[childIndex];
        if (widget.expansionCallback != null &&
            childIndex != index &&
            child.value == _currentOpenPanel?.value)
          // ignore: curly_braces_in_flow_control_structures
          widget.expansionCallback(childIndex, false);
      }

      setState(() {
        _currentOpenPanel = isExpanded ? null : pressedChild;
      });
    }
  }

  ExpansionPanelRadio searchPanelByValue(
      List<ExpansionPanelRadio> panels, Object value) {
    for (ExpansionPanelRadio panel in panels) {
      if (panel.value == value) return panel;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    // ignore: unused_local_variable
    const EdgeInsets kExpandedEdgeInsets = EdgeInsets.symmetric(
        vertical: _kPanelHeaderExpandedHeight - _kPanelHeaderCollapsedHeight);

    for (int index = 0; index < widget.children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
        // ignore: curly_braces_in_flow_control_structures
        items.add(Divider(
            color: Colors.transparent,
            height: 0,
            thickness: 0,
            key: _SaltedKey<BuildContext, int>(context, index * 2 - 1)));

      final ExpansionPanel child = widget.children[index];
      final Widget headerWidget = child.headerBuilder(
        context,
        _isChildExpanded(index),
      );

      Widget expandIconContainer = Container(
        child: InkWell(
          onTap: () {
            if (!child.canTapOnHeader) {
              _handlePressed(_isChildExpanded(index), index);
            }
          },
          child: _isChildExpanded(index)
              ? Icon(Icons.remove, color: Colors.black12)
              : Icon(Icons.add, color: Colors.black12),
        ),
      );
      if (!child.canTapOnHeader) {
        final MaterialLocalizations localizations =
            MaterialLocalizations.of(context);
        expandIconContainer = Semantics(
          label: _isChildExpanded(index)
              ? localizations.expandedIconTapHint
              : localizations.collapsedIconTapHint,
          container: true,
          child: expandIconContainer,
        );
      }
      Widget header = Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 10.0), // Mod: header padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: AnimatedContainer(
                duration: widget.animationDuration,
                curve: Curves.fastOutSlowIn,
                // margin: _isChildExpanded(index)
                //     ? kExpandedEdgeInsets
                //     : EdgeInsets.zero,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 0, // Mod, removes padding
                    // minHeight: _kPanelHeaderCollapsedHeight,
                  ),
                  child: headerWidget,
                ),
              ),
            ),
            expandIconContainer,
          ],
        ),
      );
      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: InkWell(
            onTap: () => _handlePressed(_isChildExpanded(index), index),
            child: header,
          ),
        );
      }
      items.add(
        Container(
          key: _SaltedKey<BuildContext, int>(context, index * 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              header,
              AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: child.body,
                firstCurve:
                    const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve:
                    const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isChildExpanded(index)
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
              Divider(
                height: 16.0,
              ) // Mod
            ],
          ),
        ),
      );

      if (_isChildExpanded(index) && index != widget.children.length - 1)
        // ignore: curly_braces_in_flow_control_structures
        items.add(Divider(
            color: Colors.transparent,
            height: 0,
            thickness: 0,
            key: _SaltedKey<BuildContext, int>(context, index * 2 + 1)));
    }

    return Column(
      // hasDividers: false,
      // elevation: 2,
      children: items,
    );
  }
}
