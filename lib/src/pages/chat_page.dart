import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:chat/src/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final List<ChatMessage> _messages = [];
  final FocusNode _focusNode = FocusNode();
  final _textController = TextEditingController();
  bool _isComposing = false;

  Widget _buildTextComposer() {
    return  SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _isComposing ? _handleSubmitted: null ,
                onChanged: ( String text ) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                decoration: InputDecoration.collapsed( 
                  hintText: 'Send a message'
                ),
                focusNode: _focusNode,
              ),
            ),

            // Button
            Container(
              margin: EdgeInsets.symmetric( horizontal: 4.0 ),
              child: (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoButton(
                child: Text('Send'),
                onPressed: _isComposing 
                  ? () =>_handleSubmitted( _textController.text )
                  : null
              )

              :
              IconTheme(
                data: IconThemeData( color: Theme.of(context).accentColor ),
                child: Container(
                  margin: EdgeInsets.symmetric( horizontal: 4.0 ),
                  child: IconButton(
                    icon: const Icon( Icons.send ),
                    onPressed: _isComposing
                    ? () => _handleSubmitted( _textController.text )
                    : null,
                  )
                ),
              ),
            )
            

          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    if( text.length == 0 ) { return; }

    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 300 )),
    );

    setState(() {
      _messages.insert(0, message );
      _isComposing = false;
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FriendlyChat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: ( _, int index ) => _messages[index]
              )
            ),

            Divider( height: 1.0 ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor
              ),
              child: _buildTextComposer(),
            )

          ],
        ),
        decoration: Platform.isIOS
          ? BoxDecoration(
            border: Border(
              top: BorderSide( color: Colors.grey[200] )
            )
          )
          : null,
      ),
   );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages ) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}