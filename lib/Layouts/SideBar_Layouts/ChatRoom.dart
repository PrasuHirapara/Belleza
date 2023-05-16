import 'package:belleza/Layouts/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Constants/Admin.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final _formKey = GlobalKey<FormState>();
  var userName = "";
  TextEditingController messageController = TextEditingController();

  Future<void> getUserName(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (documentSnapshot.exists) {
        setState(() {
          userName = documentSnapshot.data()!['first_name'] + " " + documentSnapshot.data()!['last_name'];
        });
        print(userName);
      }
    } catch (e) {
      print('Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    getUserName(widget.title);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 38,),

          HomePage.uid == adminId ? Container(
            decoration: BoxDecoration(
                color: Colors.blueGrey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width/1.02,
            height: 40,
            child: Center(
                child: Text(userName.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white70),)
            ),
          ) : Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width/1.02,
            height: 40,
            child: Center(child: Text("Dr. Krishna Bhalala",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white70),)),
          ),

          SizedBox(height: 5,),

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
                    bool isMe = (isAdmin ? docs[index]['senderId'] == adminId : docs[index]['senderId'] != adminId);
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
                          color: isMe ? Colors.blue[300] : Colors.blueGrey[200],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15
                        ),
                        child: Text(docs[index]['message'],style: TextStyle(color: Colors.black),),
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