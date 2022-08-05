import 'package:flutter/material.dart';
import 'package:session_next/session_next.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SessionNext example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SessionNext example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _message;

  @override
  void initState() {
    if (!SessionNext().isActive()) {
      setState(() {
        _message = 'Session inactive';
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      // Important: If you want to be able to have a session that can expire, you need to update the session (reset the timeout count) to keep it alive.
      // This can be done by adding a Listener that calls SessionNext.update() to reset the timer on each onPointerDown event.
      // You could also update the session on other events, like onPointerMove, onPointerUp etc
      // Try for yourself in this example: as long as you keep touching the screen (somewhere in the blank area for example) the session is prolonged.
      onPointerDown: _updateSession,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'SessionNext\nexample',
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
              ),
              Container(
                height: 20,
              ),
              OutlinedButton(
                onPressed: _startSession,
                child: const Text('Start Session'),
              ),
              OutlinedButton(
                onPressed: _pauseSession,
                child: const Text('Pause Session'),
              ),
              OutlinedButton(
                onPressed: _resumeSession,
                child: const Text('Resume Session'),
              ),
              OutlinedButton(
                onPressed: _destroySession,
                child: const Text('Destroy Session'),
              ),
              OutlinedButton(
                onPressed: _storeValue,
                child: const Text('Store value'),
              ),
              OutlinedButton(
                onPressed: _getValue,
                child: const Text('Get value'),
              ),
              Container(
                height: 20,
              ),
              const Text('Press a button, and see the result below:'),
              Text(
                '$_message',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startSession() {
    SessionNext().start(
      sessionTimeOut: 5,
      onExpire: () => {_handleExpiry()},
    );

    setState(() {
      _message = 'Session: started';
    });
  }

  void _destroySession() {
    SessionNext().destroy();

    setState(() {
      _message = 'Session: destroyed';
    });
  }

  void _pauseSession() {
    SessionNext().pause();

    setState(() {
      _message = 'Session: paused';
    });
  }

  void _resumeSession() {
    SessionNext().resume();

    setState(() {
      _message = 'Session: resumed';
    });
  }

  void _storeValue() {
    var someKey = 'someValue';

    SessionNext().set('someKey', someKey);

    setState(() {
      _message = 'Stored: $someKey';
    });
  }

  void _getValue() {
    setState(() {
      _message = 'Retrieved: ${SessionNext().get<String>('someKey')}';
    });
  }

  void _handleExpiry() {
    setState(() {
      _message = 'Session: expired';
    });
  }

  void _updateSession(_) {
    SessionNext().update();

    setState(() {
      if (SessionNext().isActive()) {
        _message = 'Session: updated';
      }
    });
  }
}
