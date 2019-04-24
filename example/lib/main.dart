import 'package:flutter/material.dart';
import 'my_dropdown_button.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Container Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Overlay Container Demo Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            if (index % 2 == 1) {
              return MyDropdownButton(
                label: "Bottom Dropdown",
                position: DropdownPosition.BELOW,
              );
            }
            return MyDropdownButton(
              label: "Right Dropdown",
              position: DropdownPosition.RIGHT,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 20);
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
