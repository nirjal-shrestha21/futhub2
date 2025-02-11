import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'pages.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await WebViewPlatform.instance!.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Futhub2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define the routes within the MaterialApp widget
      routes: {
        '/': (context) => const LandingPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/Admin Dashboard': (context) => const AdminDashboard(),
        '/admin-players': (context) => const AdminPlayersPage(),
        '/Futsal Owner Dashboard': (context) => const FutsalOwnerDashboard(),
        '/add-futsal': (context) => const AddFutsalPage(),
        '/Browse Futsals': (context) => const PlayerHomePage(),
        '/futsal-details': (context) => const FutsalDetailsPage(),
        '/payment': (context) => const PaymentPage(),
        '/player-team-search': (context) => const PlayerTeamSearchPage(),
        '/player-booking-details': (context) =>
            const PlayerBookingDetailsPage(),
      },
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
