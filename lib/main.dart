import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/network/api_config_manager.dart';
import 'core/network/base_api_client.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/intro/intro_screen.dart';
import 'services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'services/theme_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // Initialize Theme and Network Config
  await ThemeService().init();
  await ApiConfigManager().init();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const SmartBearApp());
}

class SmartBearApp extends StatelessWidget {
  const SmartBearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService().themeNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'SmartBear',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            textTheme: GoogleFonts.beVietnamProTextTheme().copyWith(
              headlineLarge: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
              headlineMedium: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700, color: const Color(0xFF1A1A2E)),
              headlineSmall: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E)),
              titleLarge: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E)),
              titleMedium: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E)),
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF17409A),
              primary: const Color(0xFF17409A),
              secondary: const Color(0xFF3F3D56),
              tertiary: const Color(0xFFFF8C42), // Accent Warm
              surface: Colors.white,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF4F7FF),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              color: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: GoogleFonts.fredoka(color: const Color(0xFF1A1A2E), fontSize: 22, fontWeight: FontWeight.bold),
              iconTheme: const IconThemeData(color: Color(0xFF1A1A2E)),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            textTheme: GoogleFonts.beVietnamProTextTheme(ThemeData.dark().textTheme).copyWith(
              headlineLarge: GoogleFonts.beVietnamPro(fontWeight: FontWeight.bold, color: Colors.white),
              headlineMedium: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700, color: Colors.white),
              headlineSmall: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.white),
              titleLarge: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.white),
              titleMedium: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w600, color: Colors.white),
              bodyLarge: GoogleFonts.beVietnamPro(color: Colors.white70),
              bodyMedium: GoogleFonts.beVietnamPro(color: Colors.white70),
              bodySmall: GoogleFonts.beVietnamPro(color: Colors.white54),
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF7C5CFC),
              primary: const Color(0xFF7C5CFC),
              onPrimary: Colors.white,
              brightness: Brightness.dark,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
              background: const Color(0xFF121212),
              onBackground: Colors.white,
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              color: const Color(0xFF252525),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF252525),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              hintStyle: const TextStyle(color: Colors.white38),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const AuthGate(),
          },
        );
      },
    );
  }
}

/// Root widget that checks authentication state and routes accordingly.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();
  bool _isChecking = true;
  bool _isLoggedIn = false;
  bool _showIntro = true;

  @override
  void initState() {
    super.initState();
    
    // Register global unauthorized callback to handle session expiration
    BaseApiClient.onUnauthorized = () {
      if (mounted && _isLoggedIn) {
        _onLogout();
      }
    };
    
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await _authService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _isChecking = false;
      });
    }
  }

  void _onLoginSuccess() {
    setState(() => _isLoggedIn = true);
  }

  void _onLogout() {
    _authService.logout();
    if (mounted) {
      setState(() => _isLoggedIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Content (Background layer)
        if (!_isChecking)
          _isLoggedIn
              ? HomeScreen(onLogout: _onLogout)
              : LoginScreen(onLoginSuccess: _onLoginSuccess)
        else
          // Minimal loading background to match IntroScreen
          const Scaffold(backgroundColor: Color(0xFFF4F7FF)),

        // Intro Overlay (Foreground layer)
        if (_showIntro)
          IntroScreen(
            onFinished: () {
              setState(() => _showIntro = false);
            },
          ).animate(onPlay: (c) => c.forward())
           .fadeOut(delay: 2200.ms, duration: 400.ms)
           .slideY(end: -0.05, curve: Curves.easeIn),
      ],
    );
  }
}
