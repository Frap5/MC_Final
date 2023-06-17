
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark, // 다크 모드 적용
        platform: TargetPlatform.iOS, // Cupertino 스타일의 디자인 설정
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are You Oh... Game?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputScreen(),
                  ),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  String task = '';
  int taskHours = 0;
  int taskMinutes = 0;
  TimeOfDay sleepStartTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay sleepEndTime = TimeOfDay(hour: 0, minute: 0);

  String _formatTime12Hour(TimeOfDay timeOfDay) {
    String period = 'AM';
    int hour = timeOfDay.hour;
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12;
    }
    return '${hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task and Sleep'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Text(
              'Task',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            CupertinoTextField(
              onChanged: (value) {
                setState(() {
                  task = value;
                });
              },
              style: TextStyle(color: Colors.white), // 흰색 글씨로 설정
            ),
            SizedBox(height: 16),
            Text(
              'Task Duration',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 300,
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  child: CupertinoTimerPicker(
                                    mode: CupertinoTimerPickerMode.hm,
                                    initialTimerDuration: Duration(
                                      hours: taskHours,
                                      minutes: taskMinutes,
                                    ),
                                    onTimerDurationChanged: (Duration value) {
                                      setState(() {
                                        taskHours = value.inHours;
                                        taskMinutes = value.inMinutes.remainder(60);
                                      });
                                    },
                                  ),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Done'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      '${taskHours.toString().padLeft(2, '0')}:${taskMinutes.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Sleep Start Time',
              textAlign: TextAlign.center,
            ),
            CupertinoButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                sleepStartTime.hour,
                                sleepStartTime.minute,
                              ),
                              onDateTimeChanged: (DateTime value) {
                                setState(() {
                                  sleepStartTime = TimeOfDay.fromDateTime(value);
                                });
                              },
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Done'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                '${_formatTime12Hour(sleepStartTime)}',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sleep End Time',
              textAlign: TextAlign.center,
            ),
            CupertinoButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                sleepEndTime.hour,
                                sleepEndTime.minute,
                              ),
                              onDateTimeChanged: (DateTime value) {
                                setState(() {
                                  sleepEndTime = TimeOfDay.fromDateTime(value);
                                });
                              },
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Done'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                '${_formatTime12Hour(sleepEndTime)}',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            Spacer(),
            CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameTimeScreen(
                      task: task,
                      taskHours: taskHours,
                      taskMinutes: taskMinutes,
                      sleepStartTime: sleepStartTime,
                      sleepEndTime: sleepEndTime,
                    ),
                  ),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameTimeScreen extends StatefulWidget {
  final String task;
  final int taskHours;
  final int taskMinutes;
  final TimeOfDay sleepStartTime;
  final TimeOfDay sleepEndTime;

  GameTimeScreen({
    required this.task,
    required this.taskHours,
    required this.taskMinutes,
    required this.sleepStartTime,
    required this.sleepEndTime,
  });

  @override
  _GameTimeScreenState createState() => _GameTimeScreenState();
}

class _GameTimeScreenState extends State<GameTimeScreen> {
  TimeOfDay gameStartTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay gameEndTime = TimeOfDay(hour: 0, minute: 0);

  String _formatTime12Hour(TimeOfDay timeOfDay) {
    String period = 'AM';
    int hour = timeOfDay.hour;
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) hour -= 12;
    }
    return '${hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Game Time'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Text(
              'Game Start Time',
              textAlign: TextAlign.center,
            ),
            CupertinoButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                gameStartTime.hour,
                                gameStartTime.minute,
                              ),
                              onDateTimeChanged: (DateTime value) {
                                setState(() {
                                  gameStartTime = TimeOfDay.fromDateTime(value);
                                });
                              },
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Done'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                '${_formatTime12Hour(gameStartTime)}',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Game End Time',
              textAlign: TextAlign.center,
            ),
            CupertinoButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                gameEndTime.hour,
                                gameEndTime.minute,
                              ),
                              onDateTimeChanged: (DateTime value) {
                                setState(() {
                                  gameEndTime = TimeOfDay.fromDateTime(value);
                                });
                              },
                            ),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Done'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                '${_formatTime12Hour(gameEndTime)}',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            Spacer(),
            CupertinoButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      task: widget.task,
                      taskHours: widget.taskHours,
                      taskMinutes: widget.taskMinutes,
                      sleepStartTime: widget.sleepStartTime,
                      sleepEndTime: widget.sleepEndTime,
                      gameStartTime: gameStartTime,
                      gameEndTime: gameEndTime,
                    ),
                  ),
                );
              },
              child: Text('Result'),
            ),
          ],
        ),
      ),
    );
  }
}


class ResultScreen extends StatelessWidget {
  final String task;
  final int taskHours;
  final int taskMinutes;
  final TimeOfDay sleepStartTime;
  final TimeOfDay sleepEndTime;
  final TimeOfDay gameStartTime;
  final TimeOfDay gameEndTime;

  ResultScreen({
    required this.task,
    required this.taskHours,
    required this.taskMinutes,
    required this.sleepStartTime,
    required this.sleepEndTime,
    required this.gameStartTime,
    required this.gameEndTime,
  });

  double calculateOverlapPercentage() {
    DateTime sleepStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      sleepStartTime.hour,
      sleepStartTime.minute,
    );
    DateTime sleepEnd = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      sleepEndTime.hour,
      sleepEndTime.minute,
    );
    DateTime gameStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      gameStartTime.hour,
      gameStartTime.minute,
    );
    DateTime gameEnd = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      gameEndTime.hour,
      gameEndTime.minute,
    );

    if (gameEnd.isBefore(gameStart)) gameEnd = gameEnd.add(Duration(days: 1));
    if (sleepEnd.isBefore(sleepStart)) sleepEnd = sleepEnd.add(Duration(days: 1));

    // Check if game start and end times are both in the morning
    if (gameStartTime.hour < 12 && gameEndTime.hour < 12) {
      gameStart = gameStart.add(Duration(days: 1));
      gameEnd = gameEnd.add(Duration(days: 1));
    }

    DateTime overlapStart = sleepStart.isAfter(gameStart) ? sleepStart : gameStart;
    DateTime overlapEnd = sleepEnd.isBefore(gameEnd) ? sleepEnd : gameEnd;

    if (overlapEnd.isBefore(overlapStart)) return 0;

    Duration overlapDuration = overlapEnd.difference(overlapStart);
    int taskDuration = (taskHours * 60) + taskMinutes;
    double overlapRatio = overlapDuration.inMinutes / taskDuration;
    double overlapPercentage = overlapRatio * 100;
    return overlapPercentage.clamp(0, 100);
  }

  Duration calculateOverlapTime() {
    DateTime sleepStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      sleepStartTime.hour,
      sleepStartTime.minute,
    );
    DateTime sleepEnd = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      sleepEndTime.hour,
      sleepEndTime.minute,
    );
    DateTime gameStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      gameStartTime.hour,
      gameStartTime.minute,
    );
    DateTime gameEnd = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      gameEndTime.hour,
      gameEndTime.minute,
    );

    if (gameEnd.isBefore(gameStart)) gameEnd = gameEnd.add(Duration(days: 1));
    if (sleepEnd.isBefore(sleepStart)) sleepEnd = sleepEnd.add(Duration(days: 1));

    // Check if game start and end times are both in the morning
    if (gameStartTime.hour < 12 && gameEndTime.hour < 12) {
      gameStart = gameStart.add(Duration(days: 1));
      gameEnd = gameEnd.add(Duration(days: 1));
    }

    DateTime overlapStart = sleepStart.isAfter(gameStart) ? sleepStart : gameStart;
    DateTime overlapEnd = sleepEnd.isBefore(gameEnd) ? sleepEnd : gameEnd;

    if (overlapEnd.isBefore(overlapStart)) return Duration.zero;

    return overlapEnd.difference(overlapStart);
  }

  @override
  Widget build(BuildContext context) {
    double overlapPercentage = calculateOverlapPercentage();
    Duration overlapTime = calculateOverlapTime();

    String overlapText = 'Task Percentage is ${overlapPercentage.toStringAsFixed(2)}%';
    String overlapTimeText =
        'Sleep Overlap time is ${overlapTime.inHours} hours and ${overlapTime.inMinutes.remainder(60)} minutes.';
    String statusText = overlapTime.inHours >= 6 || overlapPercentage >= 100
        ? '위험'
        : overlapTime.inHours >= 3 || overlapPercentage >= 50
        ? '심각'
        : '양호';

    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Task Name: $task'),
            SizedBox(height: 16),
            Text(overlapText),
            SizedBox(height: 16),
            Text(overlapTimeText),
            SizedBox(height: 16),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: overlapTime.inHours >= 6 || overlapPercentage >= 100
                    ? Colors.red
                    : overlapTime.inHours >= 3 || overlapPercentage >= 50
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputScreen(),
                  ),
                );
              },
              child: Text('Go Check Again'),
            ),
          ],
        ),
      ),
    );
  }
}
