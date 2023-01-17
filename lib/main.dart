import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyApp());
}

// Called when Doing Background Work initiated from Widget
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'updatecounter') {
    int counter = 0;
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0).then((value) {
      counter = value!;
      counter++;
    });
    await HomeWidget.saveWidgetData<int>('_counter', counter);
    await HomeWidget.updateWidget(name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Screen Widgets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Screen Widgets'),  
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    HomeWidget.widgetClicked.listen((Uri? uri) => loadData());
    loadData(); // This will load data from widget every time app is opened
  }

  void loadData() async {
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0).then((value) {
      _counter = value!;
    });
    setState(() {});
  }

  Future<void> updateAppWidget() async {
    await HomeWidget.saveWidgetData<int>('_counter', _counter);
    await HomeWidget.updateWidget(name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    updateAppWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
