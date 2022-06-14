import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  
  ChatMessage(this.data, this.mine);


  final dynamic data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    print(data);
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          !mine ?
          CircleAvatar(
            backgroundImage: NetworkImage(data['senderPhotoUrl']),
          ) : Container(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  data['urlImg'] != null ?
                    Image.network(data['urlImg'], width: 250,) :
                    Text(
                      data['texto'],
                      textAlign: mine ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                  Text(
                    data['senderName'],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            )
          ),
          mine ?
          CircleAvatar(
            backgroundImage: NetworkImage(data['senderPhotoUrl']),
          ) : Container()
        ],
      ),
    );
  }
}