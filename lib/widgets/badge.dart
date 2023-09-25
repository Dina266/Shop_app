import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BadgeW extends StatelessWidget {
  BadgeW(
    {  
    required this.child,
    required this.value,
    this.color});

  final Widget child;
  final String value;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color != null ? color : Theme.of(context).colorScheme.secondary
            ),
            constraints: BoxConstraints(
              minHeight: 16,
              minWidth: 16
            ),
            child: Text(
              value , 
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),)
          )
      ],
    );
  }
}