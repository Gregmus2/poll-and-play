import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poll_and_play/grpc/events.dart';
import 'package:poll_and_play/pages/event_create.dart';
import 'package:poll_and_play/providers/events.dart';
import 'package:poll_and_play/providers/state.dart';
import 'package:poll_and_play/ui/dialog_button.dart';
import 'package:poll_and_play/ui/text_input.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  final $fixnum.Int64 eventID;

  const EventPage({super.key, required this.eventID});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    EventsProvider provider = Provider.of<EventsProvider>(context, listen: false);
    StateProvider stateProvider = Provider.of<StateProvider>(context, listen: false);
    EventsClient client = Provider.of<EventsClient>(context, listen: false);

    return FutureBuilder(
      initialData: Event(
        id: widget.eventID,
        name: "Loading...",
        startTime: $fixnum.Int64(0),
        ownerId: $fixnum.Int64(0),
        status: MemberStatus.MEMBER_STATUS_PENDING,
        type: EventType.EVENT_TYPE_PRIVATE,
      ),
      future: client.getEvent(widget.eventID),
      builder: (context, snapshot) {
        List<Widget> actions = [];
        if (snapshot.data!.ownerId == stateProvider.user!.id) {
          actions.add(IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              provider.deleteEvent(snapshot.data!.id);

              Navigator.pop(context);
            },
          ));
        }
        if (snapshot.data!.ownerId != stateProvider.user!.id &&
            snapshot.data!.status == MemberStatus.MEMBER_STATUS_PENDING) {
          actions.add(IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              provider.answerEvent(snapshot.data!.id, false, [], null);

              Navigator.pop(context);
            },
          ));
        }
        if (snapshot.data!.ownerId != stateProvider.user!.id &&
            (snapshot.data!.status == MemberStatus.MEMBER_STATUS_PENDING ||
                snapshot.data!.status == MemberStatus.MEMBER_STATUS_REJECTED)) {
          actions.add(IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // todo open accept event page
            },
          ));
        }

        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              centerTitle: true,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    snapshot.data!.name,
                  ),
                  // todo check how it works
                  snapshot.data!.ownerId == stateProvider.user!.id
                      ? IconButton(
                          onPressed: () {
                            _showEditNameDialog(context, snapshot.data!);
                          },
                          icon: const Icon(Icons.edit))
                      : const SizedBox(),
                ],
              ),
            ),
            floatingActionButton: Row(
              children: actions,
            ),
            body: Column(
              children: [
                Center(
                  child: Row(
                    children: [
                      Text(
                        DateFormat('dd/MM HH:mm')
                            .format(DateTime.fromMillisecondsSinceEpoch(snapshot.data!.startTime.toInt() * 1000)),
                        style: const TextStyle(fontSize: 24),
                      ),
                      // todo check how it works
                      snapshot.data!.ownerId == stateProvider.user!.id
                          ? IconButton(
                              onPressed: () {
                                _showEditStartTimeDialog(context, snapshot.data!);
                              },
                              icon: const Icon(Icons.edit))
                          : const SizedBox(),
                    ],
                  ),
                ),
                // todo members grid
                // todo games grid
              ],
            ));
      },
    );
  }

  void _showEditNameDialog(BuildContext context, Event event) {
    EventsClient client = Provider.of<EventsClient>(context, listen: false);
    TextEditingController nameInput = TextEditingController();
    nameInput.text = event.name;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Please enter the new name"),
                EntityNameTextInput(
                  nameInput: nameInput,
                  isValid: (value) => value.isNotEmpty,
                  isValidMessage: "Name cannot be empty",
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: simpleDialogButtons(context,
                ok: () => client
                        .updateEvent(event.id, nameInput.text,
                            DateTime.fromMillisecondsSinceEpoch(event.startTime.toInt() * 1000))
                        .then((value) {
                      Navigator.pop(context);
                    }),
                cancel: () => Navigator.pop(context)));
      },
    );
  }

  void _showEditStartTimeDialog(BuildContext context, Event event) {
    EventsClient client = Provider.of<EventsClient>(context, listen: false);
    DateTime startTime = DateTime.fromMillisecondsSinceEpoch(event.startTime.toInt() * 1000);

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: DateTimeSelection((datetime) {
              startTime = datetime;
            }),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: simpleDialogButtons(context,
                ok: () => client.updateEvent(event.id, event.name, startTime).then((value) {
                      Navigator.pop(context);
                    }),
                cancel: () => Navigator.pop(context)));
      },
    );
  }
}
