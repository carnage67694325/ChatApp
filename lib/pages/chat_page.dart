import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/models/message_model.dart';
import 'package:scholar_chat/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = 'ChatPage';
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessages);
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MessageModel> messagesList = [];
            for (int message = 0;
                message < snapshot.data!.docs.length;
                message++) {
              messagesList
                  .add(MessageModel.fromJson(snapshot.data!.docs[message]));
            }
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: kPriamryColor,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        kLogo,
                        height: 50,
                      ),
                      const Text(
                        'chat',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: scrollController,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) {
                            return messagesList[index].id == email
                                ? ChatBubble(
                                    message: messagesList[index],
                                  )
                                : ChatBubbleFromFriend(
                                    message: messagesList[index]);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (data) {
                          messages.add({
                            kMessage: data,
                            kCreatedAt: DateTime.now(),
                            'id': email
                          });
                          controller.clear();
                          scrollController.animateTo(0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        decoration: InputDecoration(
                            hintText: 'Send Message',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                messages.add({
                                  kMessage: controller.text,
                                  kCreatedAt: DateTime.now(),
                                  'id': email
                                });
                                controller.clear();
                                scrollController.animateTo(0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);

                                controller.clear();
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: kPriamryColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: kPriamryColor))),
                      ),
                    ),
                  ],
                ));
          } else {
            return Center(
              child: LoadingAnimationWidget.twistingDots(
                  leftDotColor: kPriamryColor,
                  rightDotColor: Colors.white,
                  size: 30),
            );
          }
        });
  }
}
