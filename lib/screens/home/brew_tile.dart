import 'package:coffeegang/models/brew.dart';
import 'package:flutter/material.dart';

class BrewTile extends StatelessWidget {
  final Brew brew;

  const BrewTile({Key key, this.brew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/mug.png'),
            backgroundColor: Colors.brown[brew.strength],
          ),
          title: Text(brew.name),
          subtitle: Text('Takes ${brew.sugars} sugar(s)'),
        ),
      ),
    );
  }
}
