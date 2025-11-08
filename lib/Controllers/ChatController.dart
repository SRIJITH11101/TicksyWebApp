import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ticksy_web/ApiCalls/ApiRequests.dart';
import 'package:ticksy_web/Controllers/HomeController.dart';
import 'package:ticksy_web/Models/Message.dart';
import 'package:ticksy_web/Models/Ticket.dart';

class ChatController extends GetxController {
  final String ticketId; // dynamically passed ticketId
  ChatController({required this.ticketId});

  final HomeController hmController = Get.find<HomeController>();
  final TextEditingController msgController = TextEditingController();
  final api = ApiRequests();
  final authStorage = GetStorage();
  final isLoading = true.obs;
  final chatList = <Message>[].obs;
  String? originalLangOfTicket;
  bool isClosing = false;

  StompClient? stompClient;

  @override
  void onInit() {
    super.onInit();
    print("🧩 ChatController initialized for ticket: $ticketId");
    fetchMessages();
    connectWebSocket();
  }

  @override
  void onClose() {
    disconnectWebSocket();
    msgController.dispose();
    super.onClose();
  }

  // ---------------- FETCH MESSAGES ----------------
  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;
      final fetched = await api.getMessagesByTicketId(
        ticketId,
        authStorage.read('accessToken'),
      );
      chatList.assignAll(fetched);

      // ✅ Capture the original language from the first message
      if (chatList.isNotEmpty) {
        originalLangOfTicket = chatList.first.originalLang;
        print(
          "🌐 Original language of ticket $ticketId: $originalLangOfTicket",
        );
      }

      print("✅ Loaded ${chatList.length} messages for ticket $ticketId");
    } catch (e) {
      print("❌ Error fetching messages for ticket $ticketId: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> closeTicket() async {
    try {
      isClosing = true;
      update();

      await api.closeTicket(ticketId, authStorage.read('accessToken'));
      print("✅ Ticket closed on server");

      // ✅ Update local model
      final ticket = getTicket();
      if (ticket != null) {
        ticket.status = "CLOSED";
        print("🧩 Ticket status updated locally to CLOSED");
      }

      // ✅ Trigger UI rebuild
      update();
      hmController.update();
    } catch (e) {
      print("❌ Error closing ticket for $ticketId: $e");
    } finally {
      isClosing = false;
      update();
    }
  }

  // ---------------- WEBSOCKET CONNECTION ----------------
  void connectWebSocket() {
    final token = authStorage.read('accessToken');

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://34.61.45.33:8080/ws',
        onConnect: (StompFrame frame) {
          print('✅ WebSocket connected');

          // Subscribe to topic for this ticket
          stompClient!.subscribe(
            destination: '/topic/ticket/$ticketId',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                final msg = Message.fromJson(
                  Map<String, dynamic>.from(jsonDecode(frame.body!)),
                );
                chatList.add(msg);
              }
            },
          );
        },
        beforeConnect: () async {
          print('Connecting WebSocket...');
          await Future.delayed(const Duration(milliseconds: 300));
        },
        onWebSocketError: (dynamic error) => print('❌ WebSocket error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    stompClient!.activate();
  }

  void disconnectWebSocket() {
    stompClient?.deactivate();
    print('🧹 WebSocket disconnected');
  }

  // ---------------- SEND MESSAGE (Agent Side) ----------------
  Future<void> sendMessage() async {
    final msgText = msgController.text.trim();
    if (msgText.isEmpty) return;

    final msg = {
      'ticketId': ticketId,
      'text': msgText,
      'originalLang': 'en',
      'translatedLang': originalLangOfTicket ?? 'en',
      'sentBy': 'AGENT',
      'attachmentUrls': [],
    };

    print("🚀 Sending message via WebSocket: ${jsonEncode(msg)}");

    try {
      stompClient?.send(destination: '/app/sendMessage', body: jsonEncode(msg));
      print("✅ Message sent successfully for ticket $ticketId");
    } catch (e) {
      print("❌ Failed to send message for ticket $ticketId: $e");
    }

    msgController.clear();
    update();
  }

  // ---------------- TICKET METADATA HELPERS ----------------
  Ticket? getTicket() {
    try {
      return hmController.allTickets.firstWhere((t) => t.id == ticketId);
    } catch (e) {
      return null;
    }
  }

  String get ticketName {
    final ticket = getTicket();
    return ticket?.translatedSubject ?? "Unknown Ticket";
  }

  String get ticketDepartment {
    final ticket = getTicket();
    return ticket?.department ?? "Unknown Department";
  }

  String get ticketStatus {
    final ticket = getTicket();
    return ticket?.status ?? "Unknown Status";
  }

  String get ticketPriority {
    final ticket = getTicket();
    return ticket?.priority ?? "Unknown Priority";
  }

  Color getStatusColor() {
    String status = getTicket()?.status ?? "";
    switch (status) {
      case "NEW":
        return Colors.green;
      case "ONGOING":
        return Colors.orange;
      case "CLOSED":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
