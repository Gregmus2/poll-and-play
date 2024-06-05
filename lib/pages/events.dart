import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poll_and_play/pages/event_create.dart';
import 'package:poll_and_play/pages/event_page.dart';
import 'package:poll_and_play/pages/page.dart' as page;
import 'package:poll_and_play/providers/events.dart';
import 'package:poll_and_play/ui/cross_platform_refresh.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatelessWidget implements page.Page {
  const EventsPage({super.key});

  @override
  Icon getIcon(BuildContext context) {
    return const Icon(Icons.event);
  }

  @override
  Icon getUnselectedIcon(BuildContext context) {
    return const Icon(Icons.event_outlined);
  }

  @override
  String getLabel() {
    return "Events";
  }

  @override
  Widget? floatingActionButton(BuildContext context) => FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventCreatePage()),
        ),
        child: const Icon(
          Icons.add,
        ),
      );

  @override
  Widget build(BuildContext context) {
    EventsProvider provider = Provider.of<EventsProvider>(context);

    return CrossPlatformRefreshIndicator(
        onRefresh: provider.refresh,
        child: ListView(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: provider.events
                  .where((element) => element.startTime > DateTime.now().millisecondsSinceEpoch ~/ 1000)
                  .map(
                    (e) => EventTile(
                      e: e,
                    ),
                  )
                  .toList(),
            ),
            ExpansionTile(title: const Text("Past Events"), children: [
              ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: provider.events
                    .where((element) => element.startTime <= DateTime.now().millisecondsSinceEpoch ~/ 1000)
                    .map((e) => EventTile(
                          e: e,
                        ))
                    .toList(),
              ),
            ]),
          ],
        ));
  }
}

class EventTile extends StatelessWidget {
  final ListEventsResponse_EventShort e;

  const EventTile({
    super.key,
    required this.e,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventPage(eventID: e.id)),
        );
      },
      title: Text(e.name),
      // todo move color to schema
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(DateFormat('dd/MM HH:mm').format(DateTime.fromMillisecondsSinceEpoch(e.startTime.toInt() * 1000))),
          const SizedBox(width: 10),
          SizedBox(
              width: 100,
              child: MultiProgress(
                items: [
                  ProgressItem(e.pendingAmount as double, Colors.amber),
                  ProgressItem(e.rejectedAmount as double, Colors.red),
                  ProgressItem(e.acceptedAmount as double, Colors.green),
                ],
              )),
        ],
      ),
    );
  }
}

class ProgressItem {
  final double value;
  final Color color;

  ProgressItem(this.value, this.color);
}

// todo add numbers
class MultiProgress extends StatelessWidget {
  const MultiProgress({super.key, required this.items});

  final List<ProgressItem> items;

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (var item in items) {
      total += item.value;
    }
    if (total == 0) {
      total = 1;
    }

    List<double> progress = [];
    double last = 0;
    for (var item in items) {
      if (item.value == 0) {
        continue;
      }

      last += item.value / total;
      progress.add(last);
    }

    return Stack(
      children: List.generate(
          progress.length,
          (index) => LinearProgressIndicator(
                minHeight: 10,
                borderRadius: index == 0
                    ? const BorderRadius.all(Radius.circular(10))
                    : const BorderRadius.horizontal(left: Radius.circular(10)),
                value: progress[progress.length - index - 1],
                backgroundColor: Colors.transparent,
                color: items[progress.length - index - 1].color,
              )),
    );
  }
}

class Dot extends StatelessWidget {
  final Color color;

  const Dot(
    this.color, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: ShapeDecoration(
        color: color,
        shape: const CircleBorder(),
      ),
    );
  }
}
