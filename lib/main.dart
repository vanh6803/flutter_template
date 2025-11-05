import 'package:flutter/material.dart';
import 'package:flutter_template/core/widgets/base_widget.dart';
import 'package:flutter_template/app/service_locator.dart';
import 'package:flutter_template/domain/services/app_tracking_service.dart';
import 'package:flutter_template/screens/example_tracking_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await ServiceLocator.init();

  // Track app opening
  final appTrackingService = ServiceLocator.get<AppTrackingService>();
  await appTrackingService.trackAppOpen();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AppTrackingService _appTrackingService;

  @override
  void initState() {
    super.initState();
    _appTrackingService = ServiceLocator.get<AppTrackingService>();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _appTrackingService.trackAppLifecycle(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Template',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends BaseStatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseState<MyHomePage> {
  int _counter = 0;

  @override
  bool get keepAlive => true;

  @override
  String get screenName => 'Home';

  @override
  String get screenClass => 'HomePage';

  @override
  void onInitSync() {
    // TODO: init không cần context (controller/di/stream...)
  }

  @override
  void onReady() {
    // TODO: logic cần context sau frame đầu (SnackBar/Dialog/Provider.read...)
    // Screen view is automatically tracked by BaseState
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Track button tap
    trackButtonTap(
      'increment_button',
      additionalParams: {'counter_value': _counter},
    );
  }

  void _testFeature() {
    // Track feature usage
    trackFeatureUsed('test_feature');

    // Show snackbar
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Feature tracked!')));
  }

  void _simulateError() {
    try {
      throw Exception('This is a test error');
    } catch (e) {
      // Track the error
      trackError('test_error', e.toString(), errorCode: 'TEST001');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error tracked!')));
    }
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase Tracking Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _testFeature,
              child: const Text('Test Feature Tracking'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simulateError,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simulate Error'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                trackNavigation('ExampleTraking', method: 'button_tap');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExampleTrackingScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('View Tracking Examples'),
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
