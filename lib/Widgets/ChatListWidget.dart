import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ticksy_web/Controllers/ChatController.dart';
import 'package:ticksy_web/Widgets/ChatWidget.dart';

class ChatListWidget extends StatelessWidget {
  ChatListWidget({super.key});
  final ChatController chController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (chController.chatList.isEmpty) {
        return const Center(child: Text('No messages yet'));
      }

      return ListView.builder(
        itemCount: chController.chatList.length,
        itemBuilder: (context, index) {
          final chat = chController.chatList[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Get.height / 16.70),
              ChatWidget(chat: chat),
              //SizedBox(height: Get.height / 40),
            ],
          );
        },
      );
    });
  }
}
//gjjsedfjbsdbksdbdv
//sdkufbksbdkjvsdkv