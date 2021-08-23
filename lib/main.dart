import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEDED),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
          ),
          Like1(),
          Like2(),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Like2 extends StatefulWidget {
  const Like2({
    Key? key,
  }) : super(key: key);

  @override
  _Like2State createState() => _Like2State();
}

class _Like2State extends State<Like2> {
  bool _status = false;
  String _animation = "Unlike";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_status) {
          setState(() {
            _animation = "Like";
          });
        } else {
          setState(() {
            _animation = "Unlike";
          });
        }
        _status = !_status;
      },
      child: SizedBox(
        height: 300,
        child: FlareActor(
          "assets/Like.flr",
          animation: _animation,
        ),
      ),
    );
  }
}

class Like1 extends StatefulWidget {
  const Like1({Key? key}) : super(key: key);

  @override
  _Like1State createState() => _Like1State();
}

class _Like1State extends State<Like1> {
  bool status = false;
  String animation = "Unlike";
  SMIInput<bool>? _like;
  String stateChangeMessage = '';
  Artboard? _riveArtboard;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/like_unlike.riv').then((data) async {
      final file = RiveFile.import(data);

      // The artboard is the root of the animation and gets drawn in the
      // Rive widget.
      final artboard = file.mainArtboard;

      final controller = StateMachineController.fromArtboard(
        artboard,
        'like_unlike',
        onStateChange: _onStateChange,
      );
      if (controller != null) {
        artboard.addController(controller);
        _like = controller.findInput<bool>('Like') as SMIBool;
        _like?.value = false;
      }
      setState(() {
        _riveArtboard = artboard;
      });
    });
  }

  void _onStateChange(String stateMachineName, String stateName) => setState(
        () => stateChangeMessage =
            'State Changed in $stateMachineName to $stateName',
      );

  @override
  Widget build(BuildContext context) {
    return _riveArtboard == null
        ? const SizedBox(
            // height: 300,
            )
        : SizedBox(
            height: 300,
            child: GestureDetector(
              onTap: () {
                print(_like?.value);
                _like?.value = !status;
                status = !status;
              },
              child: Rive(
                fit: BoxFit.contain,
                artboard: _riveArtboard!,
              ),
            ),
          );
  }
}
