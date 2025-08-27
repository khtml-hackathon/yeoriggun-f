import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'ui/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'state/session_state.dart';

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SessionState>(
      create: (_) => SessionState(),
      child: MaterialApp(
        title: 'Cursor + Figma(MCP) Starter',
        theme: AppTheme.light,
        initialRoute: AppRoutes.initial,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
