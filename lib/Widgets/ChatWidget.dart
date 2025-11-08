import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticksy_web/Models/Message.dart';
import 'package:ticksy_web/Widgets/ViewAttachmentWidget.dart';

class ChatWidget extends StatefulWidget {
  final Message chat;
  const ChatWidget({super.key, required this.chat});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  // Format time as HH:mm
  String _formatTime(DateTime dateTime) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.of(context).textScaler;
    final bool isUser = widget.chat.sentBy == "USER";
    final bool isAgent = widget.chat.sentBy == "AGENT";

    final String messageText =
        widget.chat.translatedText?.isNotEmpty == true && isUser
        ? widget.chat.translatedText!
        : widget.chat.text;

    // Format creation time safely
    final String creationTime = widget.chat.createdAt != null
        ? _formatTime(widget.chat.createdAt!)
        : "";

    return Column(
      crossAxisAlignment: isAgent
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: isAgent
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            // 🧍 USER on LEFT → show avatar first
            if (isUser)
              Image.asset(
                'assets/images/chatProfile.png',
                height: 40,
                width: 40,
              ),

            // 🗨️ Message Bubble
            Container(
              width: Get.width / 3,
              margin: EdgeInsets.symmetric(
                horizontal: Get.width / 80,
                vertical: Get.height / 120,
              ),
              decoration: BoxDecoration(
                color: isAgent
                    ? const Color(0xff56BB71) // Green for agent
                    : const Color(0xff4F555A), // Gray for user
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: Get.width / 36,
                  right: Get.width / 36,
                  top: Get.height / 57.14,
                  bottom: Get.height / 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageText,
                      style: GoogleFonts.alata(
                        fontSize: textScale.scale(20),
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    widget.chat.attachmentUrls.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ViewAttachmentsWidget(
                                    attachments: widget.chat.attachmentUrls,
                                  ),
                                );
                              },
                              child: Text(
                                "View Attachment",
                                style: GoogleFonts.alata(
                                  fontSize: textScale.scale(16),
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 5),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        creationTime,
                        style: GoogleFonts.alata(
                          fontSize: textScale.scale(16),
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 👨‍💼 AGENT on RIGHT → show avatar after message
            if (isAgent)
              Image.asset(
                'assets/images/chatProfile.png',
                height: 40,
                width: 40,
              ),
          ],
        ),
      ],
    );
  }
}
