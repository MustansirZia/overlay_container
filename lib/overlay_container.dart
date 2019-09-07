import 'package:flutter/material.dart';

/// The child passed to this widget is rendered outside the widget hierarchy as an overlay to the exisiting widget tree.
/// As a result this widget is highly suitable for building custom dropdown options, autocomplete suggestions, dialogs, etc.
/// Think of it as widget placed absolutely and having a positive z-index over the rest of the widget tree.
/// It is actually a friendly wrapper over the Flutter's `Overlay` and `OverlayEntry` APIs.
/// ## Example.
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:overlay_container/overlay_container.dart';

/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       title: 'Overlay Container Demo',
///       theme: ThemeData(
///         primarySwatch: Colors.blue,
///       ),
///       home: MyHomePage(),
///     );
///   }
/// }

/// class MyHomePage extends StatefulWidget {
///   _MyHomePageState createState() => _MyHomePageState();
/// }

/// class _MyHomePageState extends State<MyHomePage> {
///   // Need to maintain a "show" state either locally or inside
///   // a bloc.
///   bool _dropdownShown = false;

///   void _toggleDropdown() {
///     setState(() {
///       _dropdownShown = !_dropdownShown;
///     });
///   }

///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text('Overlay Container Demo Page'),
///       ),
///       body: Padding(
///         padding: const EdgeInsets.all(20),
///         child: Column(
///           crossAxisAlignment: CrossAxisAlignment.start,
///           children: <Widget>[
///             RaisedButton(
///               onPressed: _toggleDropdown,
///               child: Column(
///                 children: <Widget>[
///                   Text("Dropdown button"),
///                 ],
///               ),
///             ),
///             // By default the overlay (since this is a Column) will
///             // be added right below the raised button
///             // but outside the widget tree.
///             // We can change that by supplying a "position".
///             OverlayContainer(
///               show: _dropdownShown,
///               // Let's position this overlay to the right of the button.
///               position: OverlayContainerPosition(
///                 // Left position.
///                 150,
///                 // Bottom position.
///                 45,
///               ),
///               // The content inside the overlay.
///               child: Container(
///                 height: 70,
///                 padding: const EdgeInsets.all(20),
///                 margin: const EdgeInsets.only(top: 5),
///                 decoration: BoxDecoration(
///                   color: Colors.white,
///                   boxShadow: <BoxShadow>[
///                     BoxShadow(
///                       color: Colors.grey[300],
///                       blurRadius: 3,
///                       spreadRadius: 6,
///                     )
///                   ],
///                 ),
///                 child: Text("I render outside the \nwidget hierarchy."),
///               ),
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
class OverlayContainer extends StatefulWidget {
  /// The child to render inside the container.
  final Widget child;

  /// By default, the child will be rendered right below (if the parent is `Column`)
  /// the widget which is defined alongside the OverlayContainer.
  /// It would appear as though the Overlay is inside its parent
  /// but in reality it would be outside and above
  /// the original widget hierarchy.
  /// It's position can be altered and the overlay can
  /// be moved to any part of the screen by supplying a `position`
  /// argument.
  final OverlayContainerPosition position;

  /// Controlling whether the overlay is current showing or not.
  final bool show;

  /// Whether the overlay is wide as its enclosing parent.
  final bool asWideAsParent;

  OverlayContainer({
    Key key,
    @required this.show,
    @required this.child,
    this.asWideAsParent = false,
    this.position = const OverlayContainerPosition(0.0, 0.0),
  }) : super(key: key);

  @override
  _OverlayContainerState createState() => _OverlayContainerState();
}

class _OverlayContainerState extends State<OverlayContainer>
    with WidgetsBindingObserver {
  OverlayEntry _overlayEntry;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    if (widget.show) {
      _show();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    // We would want to re render the overlay if any metrics
    // ever change.
    if (widget.show) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We would want to re render the overlay if any of the dependencies
    // ever change.
    if (widget.show) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void didUpdateWidget(OverlayContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void dispose() {
    if (widget.show) {
      _hide();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _show() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 280));
      if (_opened) {
        _overlayEntry.remove();
      }
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      _opened = true;
    });
  }

  void _hide() {
    if (_opened) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry.remove();
        _opened = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in media query such as when a device orientation changes
    // or when the keyboard is toggled.
    MediaQuery.of(context);
    return Container();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx + widget.position.left,
          top: offset.dy - widget.position.bottom,
          width: widget.asWideAsParent ? size.width : null,
          child: Material(
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Class to help position the overlay on the screen.
/// By default it will be rendered right below (if the parent is `Column`)
/// the widget which is alongside the OverlayContainer.
/// The Overlay can however be moved around by giving a left value
/// and a bottom value just like in the case of a `Positioned` widget.
/// The default values for `left` and `bottom` are 0 and 0 respectively.
class OverlayContainerPosition {
  final double left;
  final double bottom;

  const OverlayContainerPosition(this.left, this.bottom);
}
