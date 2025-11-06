import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticksy_web/Controllers/ChatController.dart';
import 'package:ticksy_web/Widgets/ChatListWidget.dart';

class ChatViewWidget extends StatelessWidget {
  final double width;
  final double height;
  final String ticketId;

  const ChatViewWidget({
    super.key,
    required this.width,
    required this.height,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      init: ChatController(ticketId: ticketId), // ✅ new controller per ticket
      builder: (chController) {
        if (chController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // ---------------- Header ----------------
            Container(
              padding: EdgeInsets.symmetric(horizontal: width / 49.6),
              height: height / 8,
              color: Colors.blueGrey[50],
              child: Row(
                children: [
                  // Left: Ticket info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chController.ticketName,
                        style: GoogleFonts.alexandria(
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _infoBox(chController.ticketStatus),
                          SizedBox(width: width / 288),
                          _infoBox(chController.ticketPriority),
                          SizedBox(width: width / 288),
                          _infoBox(chController.ticketDepartment),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  _closeButton(),
                ],
              ),
            ),

            // ---------------- Chat List ----------------
            Expanded(child: ChatListWidget()),

            const SizedBox(height: 10),

            // ---------------- Message Input ----------------
            _messageInputField(),
          ],
        );
      },
    );
  }

  // ---------------- Info Box Widget ----------------
  Widget _infoBox(String text) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(text, style: GoogleFonts.alexandria(fontSize: 12)),
      ),
    );
  }

  // ---------------- Close Button ----------------
  Widget _closeButton() {
    return InkWell(
      onTap: () {
        // TODO: Add close ticket logic
      },
      child: Container(
        height: height / 26.18,
        width: width / 10.52,
        decoration: BoxDecoration(
          color: const Color(0xffEA4335),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Close Ticket",
            style: GoogleFonts.alexandria(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Message Input Field ----------------
  Widget _messageInputField() {
    final ChatController chController = Get.find<ChatController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width / 49.6),
      height: height / 12,
      color: Colors.blueGrey[50],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chController.msgController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              chController.sendMessage();
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }
}
