import 'package:flutter/material.dart';
import 'package:overlay_container/overlay_container.dart';

enum DropdownPosition {
  BELOW,
  RIGHT,
}

class MyDropdownButton extends StatefulWidget {
  final String label;
  final DropdownPosition position;

  MyDropdownButton({
    Key key,
    @required this.label,
    this.position = DropdownPosition.BELOW,
  }) : super(key: key);

  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  // Need to maintain a "show" state either locally or inside
  // a bloc.
  bool _dropdownShown = false;

  void _toggleDropdown() {
    setState(() {
      _dropdownShown = !_dropdownShown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RaisedButton(
          onPressed: _toggleDropdown,
          child: Column(
            children: <Widget>[
              Text(widget.label),
            ],
          ),
        ),
        // By default the overlay will
        // be added right below the raised button
        // but outside the widget tree.
        // We can change that by supplying a "position".
        OverlayContainer(
          show: _dropdownShown,
          position: widget.position == DropdownPosition.RIGHT
              ? OverlayContainerPosition(
                  150,
                  45,
                )
              : OverlayContainerPosition(
                  0,
                  0,
                ),
          child: Container(
            height: 70,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 5),
            decoration:
                BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 3,
                spreadRadius: 6,
              )
            ]),
            child: Text("I render outside the \nwidget hierarchy."),
          ),
        ),
      ],
    );
  }
}
