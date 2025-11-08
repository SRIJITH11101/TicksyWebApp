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
                          _infoStatusBox(chController.ticketStatus),
                          SizedBox(width: width / 288),
                          _infoPriorityBox(chController.ticketPriority),
                          SizedBox(width: width / 288),
                          _infoDeptBox(chController.ticketDepartment),
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
  Widget _infoDeptBox(String text) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.alexandria(fontSize: 12, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _infoStatusBox(String text) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: text == "NEW"
              ? Colors.green
              : text == "ONGOING"
              ? Colors.yellow
              : Colors.red,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.alexandria(
            fontSize: 12,
            color: text == "NEW"
                ? Colors.green
                : text == "ONGOING"
                ? Colors.yellow
                : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _infoPriorityBox(String text) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: text == "LOW"
              ? Colors.green
              : text == "MEDIUM"
              ? Colors.yellow
              : Colors.red,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.alexandria(
            fontSize: 12,
            color: text == "LOW"
                ? Colors.green
                : text == "MEDIUM"
                ? Colors.yellow
                : Colors.red,
          ),
        ),
      ),
    );
  }

  // ---------------- Close Button ----------------
  Widget _closeButton() {
    final ChatController chController = Get.find<ChatController>();
    return InkWell(
      onTap: () {
        // TODO: Add close ticket logic
        chController.closeTicket();
      },
      child: Container(
        height: height / 26.18,
        width: width / 10.52,
        decoration: BoxDecoration(
          color: const Color(0xffEA4335),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: chController.isClosing
              ? CircularProgressIndicator()
              : Text(
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
              minLines: 1,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              enabled: chController.ticketStatus.toLowerCase() == "closed"
                  ? false
                  : true,
              controller: chController.msgController,
              decoration: InputDecoration(
                hintText: chController.ticketStatus.toLowerCase() == "closed"
                    ? "Can't message as Ticket is Closed"
                    : "Type your message...",
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
