import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String text;
  final AnimationController animationController;
  String _name = 'Fernando';

  ChatMessage({ 
    @required this.text, 
    @required this.animationController 
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only( right: 16.0 ),
                child: CircleAvatar( child: Text( _name[0] ) ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text( _name, style:Theme.of(context).textTheme.headline4 ),
                    Container(
                      margin: EdgeInsets.only( top: 5.0 ),
                      child: Text( text ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}