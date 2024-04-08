import 'package:flutter/material.dart';

class StarList extends StatefulWidget {
  final int initialIndex;

  const StarList({super.key, this.initialIndex = 1});

  @override
  _StarListState createState() => _StarListState();
}

class _StarListState extends State<StarList> {
  late int _selectedCount;
  late Map<int, Widget> _starItems;

  @override
  void initState() {
    super.initState();
    _selectedCount = widget.initialIndex;
    _starItems = {
      for (int i = 1; i <= 5; i++)
        i: Row(
          children: List.generate(i, (index) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          }),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DropdownButton<int>(
          value: _selectedCount,
          onChanged: (newValue) {
            setState(() {
              _selectedCount = newValue!;
            });
          },
          items: _starItems.entries
              .map((entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: entry.value,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
