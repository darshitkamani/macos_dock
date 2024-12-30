import 'package:flutter/material.dart';
import 'package:macos_dock/dock_item_view.dart';
import 'package:macos_dock/dock_provider.dart';
import 'package:provider/provider.dart';

/// Entrypoint of the application.
void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DockProvider())],
      child:
          const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp())));
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    DockProvider dockProvider = context.read<DockProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dockProvider.getContainerWidth();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: DockItemView()),
    );
  }
}
