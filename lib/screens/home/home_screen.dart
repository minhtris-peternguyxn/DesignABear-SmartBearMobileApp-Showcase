import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/api/device_api.dart';
import '../../data/models/response/device_model.dart';
import '../../services/auth_service.dart';
import '../settings/settings_screen.dart';
import '../device/wifi_config_screen.dart';
import 'widgets/home_header.dart';
import 'widgets/device_card.dart';
import 'widgets/offline_view.dart';
import 'widgets/empty_device_view.dart';
import 'widgets/home_loading_view.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const HomeScreen({super.key, this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _deviceApi = DeviceApi();
  final _authService = AuthService();
  Timer? _statusTimer;

  bool _isLoading = true;
  bool _isConnected = false;
  bool _isBackendAlive = false;

  /// Each item: { deviceId, serialNumber, nickname, status, createdAt, profileName, currentMode, dailyCandyBalance, purchasedCandies }
  List<Map<String, dynamic>> _devices = [];

  Map<String, dynamic>? _currentUser;
  late final AnimationController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadAll();
    
    // Refresh status every 60 seconds
    _statusTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (mounted && _isConnected && !_isLoading) {
        _checkSystemHealth();
        _updateDevicesStatusFromCurrentList();
      }
    });
  }

  Future<void> _checkSystemHealth() async {
    final aliveResp = await _deviceApi.checkBackendAlive();
    if (mounted) {
      setState(() {
        _isBackendAlive = aliveResp.isSuccess;
      });
    }
  }

  Future<void> _updateDevicesStatusFromCurrentList() async {
    final List<DeviceModel> currentModels = _devices.map((d) => DeviceModel.fromJson(d)).toList();
    _updateDevicesStatus(currentModels);
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);

    await _authService.isLoggedIn();
    _currentUser = _authService.currentUser;

    try {
      // 1. Check Backend Health
      final aliveResp = await _deviceApi.checkBackendAlive();
      _isBackendAlive = aliveResp.isSuccess;

      final response = await _deviceApi.getMyDevices();
      if (response.isSuccess) {
        final rawDevices = response.value ?? [];
        // Initially set all to 'Offline' or 'Checking' to avoid false Online from DB
        _devices = rawDevices.map((d) {
          var json = d.toJson();
          json['status'] = 'Checking...'; 
          return json;
        }).toList();
        
        _isConnected = true;
        if (mounted) setState(() => _isLoading = false);

        // 2. Fetch real-time status from bridge in background
        _updateDevicesStatus(rawDevices);
        _logSystemStatus();
        return; 
      } else {
        _isConnected = false;
      }
    } catch (e) {
      _isConnected = false;
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _logSystemStatus() {
    debugPrint('──────────────────────────────────────────────────');
    debugPrint('STATUS: backend : ${_isBackendAlive ? "alive" : "down"}');
    for (var bear in _devices) {
      final mac = bear['serialNumber'] ?? 'Unknown';
      final status = bear['status'] ?? 'Offline';
      debugPrint('STATUS: bear    : $mac is ${status.toLowerCase()}');
    }
    debugPrint('──────────────────────────────────────────────────');
  }

  Future<void> _updateDevicesStatus(List<DeviceModel> rawDevices) async {
    for (var i = 0; i < rawDevices.length; i++) {
      final device = rawDevices[i];
      if (device.serialNumber != null) {
        final statusResp = await _deviceApi.isDeviceOnline(device.serialNumber!);
        if (mounted && statusResp.isSuccess) {
          setState(() {
            _devices[i]['status'] = statusResp.value! ? 'Online' : 'Offline';
          });
        }
      }
    }
    
    if (mounted) {
      _logSystemStatus();
    }
  }

  Future<void> _handleRefresh() async {
    _refreshController.forward(from: 0);
    await _loadAll();
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    widget.onLogout?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Map<String, dynamic>? user = _currentUser;
    final displayName = user?['name'] as String? ??
        user?['unique_name'] as String? ??
        user?['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] as String? ??
        user?['email']?.toString().split('@').first ??
        'Quý khách';
    final isPro = user?['isPro'] == true;

    return Scaffold(
      body: Stack(
        children: [
          // Premium Background Layer (Living Aura - Minimalist)
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          
          // Slow moving aura blobs (Warmer & Brighter)
          Positioned(
            top: -150,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFFFF8C42).withOpacity(0.15)
                  : const Color(0xFFFF8C42).withOpacity(0.08)),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .move(begin: const Offset(0, 0), end: const Offset(120, 180), duration: 25.seconds, curve: Curves.easeInOutSine),
          ),
          
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 550,
              height: 550,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF7C5CFC).withOpacity(0.15)
                  : const Color(0xFF7C5CFC).withOpacity(0.04)),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .move(begin: const Offset(0, 0), end: const Offset(-100, -150), duration: 30.seconds, curve: Curves.easeInOutSine),
          ),
          
          Positioned(
            top: 250,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B9D).withOpacity(0.06), // Accent Pink
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .move(begin: const Offset(0, 0), end: const Offset(-80, 120), duration: 20.seconds, curve: Curves.easeInOutSine),
          ),

          // Diffusion Layer (Creates the Light Spread effect)
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(color: Colors.transparent),
            ),
          ),

          SafeArea(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              displacement: 20,
              color: colorScheme.primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  // Header section
                  SliverToBoxAdapter(
                     child: HomeHeader(
                       displayName: displayName,
                       isPro: isPro,
                       onSettingsTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                            onLogout: () => setState(() {
                              _currentUser = null;
                              _loadAll();
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (_isLoading)
                    const HomeLoadingView()
                  else if (!_isConnected)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: OfflineView(onRetry: _handleRefresh),
                    )
                  else if (_devices.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyDeviceView(displayName: displayName),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) => DeviceCard(
                            device: _devices[i],
                            onDeviceUpdated: _loadAll,
                          ).animate().fade(delay: (200 * i).ms).slideY(begin: 0.1),
                          childCount: _devices.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 64,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final paired = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const WifiConfigScreen()),
            );
            if (paired == true) _loadAll();
          },
          icon: const Icon(Icons.add_rounded, size: 28),
          label: const Text('KẾT NỐI BẠN MỚI',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

