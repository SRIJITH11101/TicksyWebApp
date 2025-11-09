import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ticksy_web/ApiCalls/ApiRequests.dart';
import 'package:ticksy_web/Controllers/ChatController.dart';
import 'package:ticksy_web/Models/Ticket.dart';

class HomeController extends GetxController {
  final authStorage = GetStorage();
  final api = ApiRequests();
  final TextEditingController searchController = TextEditingController();
  bool isTicketFetching = false;

  // Source lists:
  List<Ticket> allTickets = []; // raw full list from loadTickets()
  List<Ticket> unfilteredList =
      []; // the last "source" list (either allTickets or search results)
  List<Ticket> selectedList =
      []; // the list actually shown in UI (after filtering)

  int ticketListSize = 7;

  // current priority filter: 'ALL','HIGH','MEDIUM','LOW'
  String currentPriorityFilter = 'ALL';

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadTickets();
  }

  Future<void> loadTickets() async {
    isTicketFetching = true;
    update();

    allTickets = await api.fetchUserTickets(
      authStorage.read('department'),
      authStorage.read('accessToken'),
    );

    // When loading default tickets, both unfiltered and displayed list should come from allTickets
    unfilteredList = List.from(allTickets);
    selectedList = List.from(unfilteredList);

    // reset priority filter
    currentPriorityFilter = 'ALL';

    isTicketFetching = false;
    update();
  }

  Future<void> reloadTickets() async {
    await loadTickets();
  }

  String selectedTicketId = "";
  void setSelectedTicketId(String id) {
    selectedTicketId = id;
    print("ticket id: $id .....................");

    // Optimistic local update: if ticket is NEW, mark it ONGOING immediately
    _setTicketStatusLocally(id, 'ONGOING');

    // Dispose old ChatController if any
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
    }

    // Initialize new ChatController with selected ticket
    ChatController chController = Get.put(ChatController(ticketId: id));
    chController.isLoading.value = false;
    chController.update();

    update(); // update Home UI
  }

  // helper: update status in all source lists so UI sees it everywhere
  void _setTicketStatusLocally(String ticketId, String newStatus) {
    for (final list in [allTickets, unfilteredList, selectedList]) {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == ticketId && list[i].status == "NEW") {
          list[i].status = newStatus;
        }
      }
    }
    update();
  }

  /// Called when the user presses the search icon or submits the search text.
  /// If the query is empty -> fall back to loadTickets()
  /// else -> call search endpoint and update unfilteredList + selectedList.
  Future<void> performSearch() async {
    final query = searchController.text.trim();
    if (query.isEmpty) {
      // revert to default full fetch
      await loadTickets();
      return;
    }

    isTicketFetching = true;
    update();
    try {
      final results =
          await api.searchTicket(query, authStorage.read('accessToken')) ??
          <Ticket>[];

      // results become the source for subsequent filtering (so filter can be applied on search results)
      unfilteredList = List.from(results);

      // if a priority filter is already active, apply it; otherwise show full results
      if (currentPriorityFilter != 'ALL') {
        _applyPriorityFilterOnUnfiltered();
      } else {
        selectedList = List.from(unfilteredList);
      }
    } finally {
      isTicketFetching = false;
      update();
    }
  }

  /// Filter currently-displayed set of tickets by priority.
  /// Priority values: 'ALL', 'HIGH', 'MEDIUM', 'LOW'
  void filterTicketsByPriority(String priority) {
    currentPriorityFilter = priority.toUpperCase();
    _applyPriorityFilterOnUnfiltered();
    update();
  }

  // internal helper that filters `unfilteredList` using currentPriorityFilter
  void _applyPriorityFilterOnUnfiltered() {
    if (currentPriorityFilter == 'ALL') {
      selectedList = List.from(unfilteredList);
      return;
    }

    selectedList = unfilteredList.where((t) {
      final p = (t.priority ?? '').toString().toUpperCase();
      return p == currentPriorityFilter;
    }).toList();
  }
}
