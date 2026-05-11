import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../data/api/media_api.dart';
import '../../data/models/response/media_response.dart';
import '../../config/app_config.dart';
import 'widgets/settings_header.dart';

class LibraryPreviewScreen extends StatefulWidget {
  const LibraryPreviewScreen({super.key});

  @override
  State<LibraryPreviewScreen> createState() => _LibraryPreviewScreenState();
}

class _LibraryPreviewScreenState extends State<LibraryPreviewScreen> {
  final _mediaApi = MediaApi();
  final _audioPlayer = AudioPlayer();
  
  List<SongModel> _allSongs = [];
  List<SongModel> _allStories = [];
  List<SongModel> _filteredItems = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedTab = 0; // 0: Nhạc, 1: Truyện
  
  String? _currentlyPlayingId;
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    _loadSongs();
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });
    
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) setState(() {
        _currentlyPlayingId = null;
        _playerState = PlayerState.stopped;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadSongs() async {
    setState(() => _isLoading = true);
    
    final songsResp = await _mediaApi.getSongs();
    final storiesResp = await _mediaApi.getStories();

    if (mounted) {
      setState(() {
        _allSongs = songsResp.value ?? [];
        _allStories = storiesResp.value ?? [];
        _isLoading = false;
        _updateFilteredList();
      });
    }
  }

  void _updateFilteredList() {
    final source = _selectedTab == 0 ? _allSongs : _allStories;
    _filteredItems = source.where((s) {
      final name = s.name.toLowerCase();
      final artist = s.artist?.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase()) || artist.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _filterSongs(String query) {
    setState(() {
      _searchQuery = query;
      _updateFilteredList();
    });
  }

  Future<void> _togglePlay(SongModel song) async {
    if (_currentlyPlayingId == song.id) {
      if (_playerState == PlayerState.playing) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
    } else {
      await _audioPlayer.stop();
      String? finalUrl;
      
      // Use the backend proxy/redirect endpoint for better compatibility and signed URLs
      finalUrl = '${AppConfig.baseUrl}/api/media/play/${_selectedTab == 0 ? 'music' : 'story'}/${song.id}';
      
      // Only fallback to Google TTS if it's a story and we want to ensure some audio plays 
      // (though the play endpoint should handle GCS files correctly)
      if ((song.audioUrl == null || song.audioUrl!.isEmpty || song.audioUrl == 'GCS') && _selectedTab == 1) {
         // Optionally keep Google TTS as a secondary fallback if the story has no content/audio yet
         // But for now, let's prioritize the real content from the play endpoint
      }

      if (finalUrl.isNotEmpty) {
        debugPrint('>>> Playing Preview via Proxy: $finalUrl');
        
        setState(() {
          _currentlyPlayingId = song.id;
        });
        await _audioPlayer.play(UrlSource(finalUrl));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không có link nhạc thử cho bài này')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildAuraBlobs(),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 120, sigmaY: 120),
              child: Container(color: Colors.transparent),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SettingsHeader(
                  title: 'Thư viện',
                  subtitle: 'KHO NHẠC & TRUYỆN',
                  onBack: () => Navigator.pop(context),
                ),
                _buildTabs(),
                _buildSearchBar(),
                Expanded(
                  child: _isLoading
                      ? _buildLoadingView()
                      : _filteredItems.isEmpty
                          ? _buildEmptyView()
                          : _buildSongList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _buildTabItem(0, 'Âm nhạc', Icons.music_note_rounded),
          const SizedBox(width: 12),
          _buildTabItem(1, 'Truyện kể', Icons.auto_stories_rounded),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          await _audioPlayer.stop();
          setState(() {
            _selectedTab = index;
            _currentlyPlayingId = null;
            _updateFilteredList();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
              ? const Color(0xFF7C5CFC) 
              : Theme.of(context).cardTheme.color?.withOpacity(0.5) ?? Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected ? [
              BoxShadow(
                color: const Color(0xFF7C5CFC).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.beVietnamPro(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color?.withOpacity(0.8) ?? Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextField(
          onChanged: _filterSongs,
          style: GoogleFonts.beVietnamPro(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm nhạc hoặc truyện...',
            hintStyle: GoogleFonts.beVietnamPro(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF7C5CFC)),
          const SizedBox(height: 20),
          Text(
            'Đang tải thư viện...',
            style: GoogleFonts.beVietnamPro(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_music_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'Chưa có nội dung nào trong thư viện' : 'Không tìm thấy kết quả phù hợp',
            style: GoogleFonts.beVietnamPro(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSongList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final song = _filteredItems[index];
        final isPlaying = _currentlyPlayingId == song.id && _playerState == PlayerState.playing;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color ?? Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPlaying 
                    ? [const Color(0xFF7C5CFC), const Color(0xFF4ECDC4)]
                    : [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _selectedTab == 0 ? Icons.music_note_rounded : Icons.auto_stories_rounded,
                color: isPlaying ? Colors.white : Colors.grey[600],
              ),
            ),
            title: Text(
              song.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            subtitle: Text(
              _selectedTab == 1 && (song.audioUrl == null || song.audioUrl!.isEmpty || song.audioUrl == 'GCS')
                ? 'Giọng đọc Google TTS (Mặc định)'
                : (song.artist ?? (_selectedTab == 0 ? 'Nghệ sĩ ẩn danh' : 'Truyện cổ tích')),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.beVietnamPro(fontSize: 12, color: Colors.grey),
            ),
            trailing: GestureDetector(
              onTap: () => _togglePlay(song),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isPlaying ? const Color(0xFF7C5CFC) : Colors.grey[100])?.withOpacity(isPlaying ? 1.0 : 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: isPlaying ? Colors.white : Colors.grey[700],
                  size: 24,
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
      },
    );
  }

  Widget _buildAuraBlobs() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8C42).withOpacity(0.06),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7C5CFC).withOpacity(0.06),
            ),
          ),
        ),
      ],
    );
  }
}
