import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poll_and_play/pages/games.dart';
import 'package:poll_and_play/providers/friends.dart';
import 'package:poll_and_play/providers/games.dart';
import 'package:poll_and_play/providers/groups.dart';
import 'package:poll_play_proto_gen/public.dart';
import 'package:provider/provider.dart';

class EventCreatePage extends StatefulWidget {
  const EventCreatePage({super.key});

  @override
  State<EventCreatePage> createState() => _EventCreatePageState();
}

enum Target { group, users }

class _EventCreatePageState extends State<EventCreatePage> {
  SelectedTarget _target = SelectedTarget(Target.group, []);
  DateTime _dateTime = DateTime.now();
  List<GameWithStat> _selectedGames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: const Text(
            "Create Event",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // todo create event

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Card(
                    elevation: 3,
                    child: TargetSelection(
                      onTargetChanged: (SelectedTarget selected) {
                        setState(() {
                          _target = selected;
                        });
                      },
                    )),
                Card(
                    elevation: 3,
                    child: DateTimeSelection((date) {
                      setState(() {
                        _dateTime = date;
                      });
                    })),
                Expanded(
                  child: Card(
                    elevation: 3,
                    child: GamesSelection(
                      onGamesChanged: (games) {
                        setState(() {
                          _selectedGames = games;
                        });
                      },
                    ),
                  ),
                ),
              ],
            )));
  }
}

class GamesSelection extends StatefulWidget {
  final Function(List<GameWithStat>) onGamesChanged;

  const GamesSelection({
    super.key,
    required this.onGamesChanged,
  });

  @override
  State<GamesSelection> createState() => _GamesSelectionState();
}

class _GamesSelectionState extends State<GamesSelection> {
  final List<GameWithStat> _selectedGames = [];

  @override
  Widget build(BuildContext context) {
    GamesProvider gamesProvider = Provider.of<GamesProvider>(context, listen: false);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.68,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: gamesProvider.games.length,
      itemBuilder: (context, index) => SelectableGameTile(
          game: gamesProvider.games[index],
          onSelectionChanged: (isSelected) {
            setState(() {
              if (isSelected) {
                _selectedGames.add(gamesProvider.games[index]);
              } else {
                _selectedGames.remove(gamesProvider.games[index]);
              }
            });

            widget.onGamesChanged(_selectedGames);
          }),
    );
  }
}

class SelectableGameTile extends StatefulWidget {
  final GameWithStat game;
  final Function(bool) onSelectionChanged;

  const SelectableGameTile({
    super.key,
    required this.game,
    required this.onSelectionChanged,
  });

  @override
  State<SelectableGameTile> createState() => _SelectableGameTileState();
}

class _SelectableGameTileState extends State<SelectableGameTile> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: GameTile(
          game: widget.game,
          isSelected: _isSelected,
        ),
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
          });

          widget.onSelectionChanged(_isSelected);
        });
  }
}

class DateTimeSelection extends StatefulWidget {
  final Function(DateTime) onDateChanged;

  const DateTimeSelection(
    this.onDateChanged, {
    super.key,
  });

  @override
  State<DateTimeSelection> createState() => _DateTimeSelectionState();
}

class _DateTimeSelectionState extends State<DateTimeSelection> {
  DateTime date = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("HH:mm");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: FilledButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
                    ),
                  ),
                ),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    final combiDateTime =
                        DateTime(selectedDate.year, selectedDate.month, selectedDate.day, date.hour, date.minute);
                    setState(() {
                      date = combiDateTime;
                    });
                    widget.onDateChanged(combiDateTime);
                  }
                },
                child: Text(dateFormat.format(date))),
          ),
          Expanded(
              flex: 1,
              child: FilledButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(15)),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(date),
                    );
                    if (selectedTime != null) {
                      final combiDateTime =
                          DateTime(date.year, date.month, date.day, selectedTime.hour, selectedTime.minute);
                      setState(() {
                        date = combiDateTime;
                      });
                      widget.onDateChanged(combiDateTime);
                    }
                  },
                  child: Text(timeFormat.format(date)))),
        ],
      ),
    );
  }
}

class TargetSelection extends StatefulWidget {
  final Function(SelectedTarget) onTargetChanged;

  const TargetSelection({super.key, required this.onTargetChanged});

  @override
  State<TargetSelection> createState() => _TargetSelectionState();
}

class _TargetSelectionState extends State<TargetSelection> {
  SelectedTarget _target = SelectedTarget(Target.group, []);

  @override
  Widget build(BuildContext context) {
    GroupsProvider groupProvider = Provider.of<GroupsProvider>(context, listen: false);
    FriendsProvider friendsProvider = Provider.of<FriendsProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<Target>(
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                segments: const <ButtonSegment<Target>>[
                  ButtonSegment<Target>(
                      label: Text("Group"),
                      value: Target.group,
                      icon: Icon(Icons.group)),
                  ButtonSegment<Target>(
                      label: Text("Users"),
                      value: Target.users,
                      icon: Icon(Icons.person)),
                ],
                selected: <Target>{_target.type},
                onSelectionChanged: (Set<Target> selected) {
                  setState(() {
                    _target = SelectedTarget(selected.first, []);
                  });
                  widget.onTargetChanged(_target);
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: _target.type == Target.group
                ? DropdownButton(
                    isExpanded: true,
                    items: groupProvider.groups
                        .map<DropdownMenuItem<Group>>((Group value) => DropdownMenuItem<Group>(
                              value: value,
                              child: Text(value.name),
                            ))
                        .toList(),
                    onChanged: (Group? value) {
                      if (value != null) {
                        setState(() {
                          _target = SelectedTarget(Target.group, [value.id]);
                        });
                        widget.onTargetChanged(_target);
                      }
                    },
                    value: _target.id.isNotEmpty ? groupProvider.getGroup(_target.id.first) : null,
                  )
                : Wrap(
                    spacing: 7.0,
                    children: List<Widget>.generate(
                        friendsProvider.friends.length,
                        (index) => ChoiceChip(
                              label: Text(
                                friendsProvider.friends[index].name,
                              ),
                              selected: _target.id.contains(friendsProvider.friends[index].id),
                              onSelected: (bool selected) {
                                if (selected) {
                                  setState(() {
                                    _target = SelectedTarget(
                                        Target.users, _target.id..add(friendsProvider.friends[index].id));
                                  });
                                } else {
                                  setState(() {
                                    _target = SelectedTarget(
                                        Target.users, _target.id..remove(friendsProvider.friends[index].id));
                                  });
                                }
                                widget.onTargetChanged(_target);
                              },
                            ))),
          ),
        ],
      ),
    );
  }
}

class SelectedTarget {
  final Target type;
  final List<$fixnum.Int64> id;

  SelectedTarget(this.type, this.id);
}
