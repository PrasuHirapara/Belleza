import 'package:belleza/Layouts/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final _formKey = GlobalKey<FormState>();
  final String adminId = "ieDmUFNqFMWmZmCLoNldGQqNDcI3";
  TextEditingController messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.title)
                  .collection(widget.title)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> docs = snapshot.data!.docs;
                if (snapshot.data!.docs.isEmpty) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        'No chat history',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    bool isMe = (HomePage.isAdmin ? docs[index]['senderId'] == adminId : docs[index]['senderId'] != adminId);
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15
                      ),
                      alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isMe ? Colors.blue[100] : Colors.blueGrey[200],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Text(
                          docs[index]['message'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Container(height: 20,),

          Container(
            padding: EdgeInsets.only(left: 10,bottom: 20,),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
            ),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: messageController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter a Message';
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if(_formKey.currentState!.validate() && messageController.text.toString().trim() != ""){
                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(widget.title)
                            .collection(widget.title)
                            .add({
                          'message': messageController.text,
                          'timestamp': Timestamp.now(),
                          'senderId': FirebaseAuth.instance.currentUser!.uid,
                        });
                        messageController.clear();
                      }
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
