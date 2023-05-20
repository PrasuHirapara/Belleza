import 'dart:io';
import 'package:belleza/Layouts/SideBar_Layouts/About.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core_dart/firebase_core_dart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

          FirebaseAuth.instance.currentUser!.uid == adminId ? Hero(
            tag: 'consultantTOchatroom',
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width/1.02,
              height: 40,
              child: Center(
                  child: Text(userName.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white70),)
              ),
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
                            vertical: 3,
                            horizontal: 8
                        ),
                        alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,

                        child: docs[index]['type'] == 'text' ?
                        isAdmin ? isMe ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isMe ? Colors.blue[300] : Colors.blueGrey[200],
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15
                                ),
                                child: Text(docs[index]['message'],style: TextStyle(color: Colors.black),)
                            ),
                            SizedBox(width: 3,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                              },
                              child: Container(
                                width: 23,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Hero(
                                    tag: 'chatroomTOabout',
                                    child: Image(
                                      image: AssetImage('assets/icons/doctor.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ) : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 23,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: AssetImage('assets/icons/user_logo.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 3,),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isMe ? Colors.blue[300] : Colors.blueGrey[200],
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15
                                ),
                                child: Text(docs[index]['message'],style: TextStyle(color: Colors.black),)
                            ),
                          ],
                        ) :
                            isMe ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isMe ? Colors.blue[300] : Colors.blueGrey[200],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15
                                    ),
                                    child: Text(docs[index]['message'],style: TextStyle(color: Colors.black),)
                                ),
                                SizedBox(width: 3,),
                                Container(
                                  width: 23,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image(
                                      image: AssetImage('assets/icons/user_logo.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ) : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                                  },
                                  child: Container(
                                    width: 23,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Hero(
                                        tag: 'chatroomTOabout',
                                        child: Image(
                                          image: AssetImage('assets/icons/doctor.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3,),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isMe ? Colors.blue[300] : Colors.blueGrey[200],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15
                                    ),
                                    child: Text(docs[index]['message'],style: TextStyle(color: Colors.black),)
                                ),
                              ],
                            ) :
                        Container(
                            width: MediaQuery.of(context).size.width/1.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10
                            ),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (_) => imageDialog('My Image', docs[index]['image_url'], context)
                                );
                              },
                              child: Hero(
                                tag: 'chatroomImage',
                                child: Image(
                                  image: NetworkImage(docs[index]['image_url']),
                                ),
                              ),
                            )
                        )
                    );
                  },
                );
              },
            ),
          ),

          Container(height: 20,),

          Container(
            padding: EdgeInsets.only(left: 10,bottom: 20,right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      child: Expanded(
                        child: Form(
                          key: _formKey,
                          child: Container(
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
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon : Icon(Icons.photo_outlined,size: 27,),
                        onPressed: ()  async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                          String uniqueFileName = Timestamp.now().toString();

                          showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Send Image',style: TextStyle(fontSize: 30),),
                                content: Text('Are you sure want to send Image ?',style: TextStyle(fontSize: 15),),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('NO'),
                                  ),
                                  TextButton(
                                    onPressed: () async {

                                      Reference referenceRoot = FirebaseStorage.instance.ref();
                                      Reference referenceDirImage = referenceRoot.child('chat/images');

                                      Reference referenceImageToUpload = referenceDirImage.child("$uniqueFileName");

                                      try{
                                        await referenceImageToUpload.putFile(File(file!.path));

                                        String url = await referenceImageToUpload.getDownloadURL();

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded"),duration: Duration(seconds: 1),));

                                        FirebaseFirestore.instance
                                            .collection('chats')
                                            .doc(widget.title)
                                            .collection(widget.title)
                                            .add({
                                          'image_url' : url,
                                          'type' : 'image',
                                          'timestamp': Timestamp.now(),
                                          'senderId': FirebaseAuth.instance.currentUser!.uid,
                                        });

                                        Navigator.of(context, rootNavigator: true).pop();

                                      }catch(error){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 2),));
                                        Navigator.of(context, rootNavigator: true).pop();
                                      }
                                    },
                                    child: Text('YES'),
                                  ),
                                ],
                              )
                          );
                        }
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
                              'type' : 'text',
                              'timestamp': Timestamp.now(),
                              'senderId': FirebaseAuth.instance.currentUser!.uid,
                            });
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({
                              'message_date' : Timestamp.now(),
                            });
                            messageController.clear();
                          }
                        }
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imageDialog(text, path, context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          Container(
            child: Card(
              child: Hero(
                tag: 'chatroomImage',
                child: Image.network(
                  '$path',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}