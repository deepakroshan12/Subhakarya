import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math';
import 'Profile_Screen.dart';
import 'Search_Screen.dart';
import 'Comments_Screen.dart';
import 'Booking_Sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExploreScreen extends StatefulWidget {
  final bool isTab;
  const ExploreScreen({super.key, this.isTab = false});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _isBottomNavVisible = true;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isKeyboardOpen = false;

  // Seeds for the 3-column grid — alternate tall items in col 0
  final List<Map<String, dynamic>> _gridItems = List.generate(30, (i) => {
    'seed': 'explore_img_$i',
    'isVideo': i % 5 == 0,
  });

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isKeyboardOpen = _searchFocusNode.hasFocus;
        if (_isKeyboardOpen) _isBottomNavVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    // When keyboard closes, show navbar again
    if (bottomInset == 0 && _isKeyboardOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isKeyboardOpen = false;
            _isBottomNavVisible = true;
          });
        }
      });
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gridBgColor = isDark ? const Color(0xFF121212) : Colors.white;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF7A5405),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: _buildAppBar(),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: gridBgColor,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (_isKeyboardOpen) return false;
                  if (notification.direction == ScrollDirection.reverse) {
                    if (_isBottomNavVisible) setState(() => _isBottomNavVisible = false);
                  } else if (notification.direction == ScrollDirection.forward) {
                    if (!_isBottomNavVisible) setState(() => _isBottomNavVisible = true);
                  }
                  return false;
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [

                    // Instagram explore staggered layout
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(1, 2, 1, widget.isTab ? 16 : 110),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          _buildInstagramLayout(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Floating bottom nav — hidden when keyboard is open
              if (!widget.isTab)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: _isBottomNavVisible ? 20 : -100,
                  left: 16,
                  right: 16,
                  child: _buildBottomNavigationBar(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCell(String seed, bool isVideo) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          'https://picsum.photos/seed/$seed/400/530',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFEBC140),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.image, color: Colors.grey),
          ),
        ),
        // Video / Image badge
        Positioned(
          top: 6,
          right: 6,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isVideo ? Icons.play_arrow_rounded : Icons.image_outlined,
              color: Colors.white,
              size: 13,
            ),
          ),
        ),
        // Ripple
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExploreDetailScreen(
                      seed: seed,
                      isVideo: isVideo,
                    ),
                  ),
                );
              },
              splashColor: Colors.black26,
              highlightColor: Colors.black12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7A5405), // Deep rich gold
              Color(0xFFA67B1E), // Mid rich gold
              Color(0xFFDCAE36), // Vibrant golden yellow
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    SizedBox(width: 12),
                    Icon(
                      Icons.search,
                      color: Colors.black54,
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search "wedding stage" or "birthday decor"',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.mic,
                      color: Colors.black54,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF7A5405).withOpacity(0.85),
                const Color(0xFFA67B1E).withOpacity(0.85),
                const Color(0xFFDCAE36).withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7A5405).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', onTap: () {
                Navigator.pop(context);
              }),
              _buildNavItem(Icons.explore_outlined, 'Explore', isActive: true),
              _buildNavItem(Icons.calendar_month_outlined, 'Bookings'),
              _buildNavItem(Icons.person_outline, 'Profile', onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool isActive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.white24,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                size: isActive ? 26 : 22,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                letterSpacing: isActive ? 0.3 : 0.0,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 2),
            // Glowing Indicator Dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 4,
              width: isActive ? 4 : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInstagramLayout() {
    List<Widget> blocks = [];
    int totalItems = _gridItems.length;
    int index = 0;
    int blockIndex = 0;

    while (index < totalItems) {
      bool isBlockA = blockIndex % 2 == 0;
      int itemsInBlock = 5;
      
      // If we don't have enough items for a full block, render remaining as square grid row
      if (index + itemsInBlock > totalItems) {
        List<Widget> rowItems = [];
        for (int i = index; i < totalItems; i++) {
          final item = _gridItems[i];
          rowItems.add(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: _buildGridCell(item['seed'] as String, item['isVideo'] as bool),
                ),
              ),
            ),
          );
        }
        while (rowItems.length < 3) {
          rowItems.add(const Expanded(child: SizedBox()));
        }
        blocks.add(Row(children: rowItems));
        break;
      }

      // Alternate Block A and Block B
      if (isBlockA) {
        // Block A: Left 4 small squares, Right 1 tall video
        final small1 = _gridItems[index];
        final small2 = _gridItems[index + 1];
        final small3 = _gridItems[index + 2];
        final small4 = _gridItems[index + 3];
        final tall = _gridItems[index + 4];

        blocks.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: AspectRatio(
              aspectRatio: 3 / 2, // Total width is 3 columns, total height is 2 rows
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left side (2/3 width) - Contains 4 small squares in a 2x2 grid
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: Padding(padding: const EdgeInsets.all(1.0), child: _buildGridCell(small1['seed'] as String, small1['isVideo'] as bool))),
                              Expanded(child: Padding(padding: const EdgeInsets.all(1.0), child: _buildGridCell(small2['seed'] as String, small2['isVideo'] as bool))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: Padding(padding: const EdgeInsets.all(1.0), child: _buildGridCell(small3['seed'] as String, small3['isVideo'] as bool))),
                              Expanded(child: Padding(padding: const EdgeInsets.all(1.0), child: _buildGridCell(small4['seed'] as String, small4['isVideo'] as bool))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side (1/3 width) - Contains 1 tall item (double height)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: _buildGridCell(tall['seed'] as String, tall['isVideo'] as bool),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        // Block B: Left 1 tall video, Right 4 small squares
        final tall = _gridItems[index];
        final small1 = _gridItems[index + 1];
        final small2 = _gridItems[index + 2];
        final small3 = _gridItems[index + 3];
        final small4 = _gridItems[index + 4];

        blocks.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left side (1/3 width) - Contains 1 tall item (double height)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: _buildGridCell(tall['seed'] as String, tall['isVideo'] as bool),
                    ),
                  ),
                  // Right side (2/3 width) - Contains 4 small squares in a 2x2 grid
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: Padding(padding: const EdgeInsets.all(1.0), child: _buildGridCell(small1['seed'] as String, small1['isVideo'] as bool))),
                              Expanded(child: Padding(padding: const EdgeInsets.all(1.0), child: _buildGridCell(small2['seed'] as String, small2['isVideo'] as bool))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: Padding(padding: const EdgeInsets.all(1.0), child: _buildGridCell(small3['seed'] as String, small3['isVideo'] as bool))),
                              Expanded(child: Padding(padding: const EdgeInsets.all(1.0), child: _buildGridCell(small4['seed'] as String, small4['isVideo'] as bool))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      index += itemsInBlock;
      blockIndex++;
    }

    return blocks;
  }
}

// Custom Spinning Music Disc for Reels
class SpinningMusicDisc extends StatefulWidget {
  const SpinningMusicDisc({super.key});

  @override
  State<SpinningMusicDisc> createState() => _SpinningMusicDiscState();
}

class _SpinningMusicDiscState extends State<SpinningMusicDisc> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.8),
          border: Border.all(color: Colors.white54, width: 1.5),
        ),
        child: const Icon(
          Icons.music_note_rounded,
          color: Color(0xFFFFF2A3),
          size: 16,
        ),
      ),
    );
  }
}

// Custom Immersive Visual Viewer Screen for Posts and Momentos
class ExploreDetailScreen extends StatefulWidget {
  final String seed;
  final bool isVideo;

  const ExploreDetailScreen({
    super.key,
    required this.seed,
    required this.isVideo,
  });

  @override
  State<ExploreDetailScreen> createState() => _ExploreDetailScreenState();
}

class _ExploreDetailScreenState extends State<ExploreDetailScreen> {
  late List<Map<String, dynamic>> _reelsList;
  late List<Map<String, dynamic>> _postsList;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Build a list of reels starting with the selected one
    _reelsList = [
      {'seed': widget.seed, 'isVideo': true},
      ...List.generate(15, (index) {
        final seedIndex = (widget.seed.hashCode + index + 1) % 30;
        return {
          'seed': 'explore_img_$seedIndex',
          'isVideo': true,
        };
      })
    ];
    
    // Build a list of posts starting with the selected one
    _postsList = [
      {'seed': widget.seed, 'isVideo': false},
      ...List.generate(15, (index) {
        final seedIndex = (widget.seed.hashCode + index + 3) % 30;
        return {
          'seed': 'explore_img_$seedIndex',
          'isVideo': false,
        };
      })
    ];
    
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVideo) {
      return _buildReelView();
    } else {
      return _buildPostView();
    }
  }

  Widget _buildReelView() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _reelsList.length,
      itemBuilder: (context, index) {
        final reelItem = _reelsList[index];
        return ReelItemWidget(
          seed: reelItem['seed'] as String,
          itemIndex: index,
          onBack: () => Navigator.pop(context),
        );
      },
    );
  }

  Widget _buildPostView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFCFBF7);
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Explore Feed',
          style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 18),
        ),
        titleSpacing: 0,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _postsList.length,
        itemBuilder: (context, index) {
          final postItem = _postsList[index];
          return PostItemWidget(
            seed: postItem['seed'] as String,
          );
        },
      ),
    );
  }
}

class ReelItemWidget extends StatefulWidget {
  final String seed;
  final int itemIndex;
  final VoidCallback onBack;

  const ReelItemWidget({
    super.key,
    required this.seed,
    required this.itemIndex,
    required this.onBack,
  });

  @override
  State<ReelItemWidget> createState() => _ReelItemWidgetState();
}

class _ReelItemWidgetState extends State<ReelItemWidget> with TickerProviderStateMixin {
  bool _isLiked = false;
  bool _isSaved = false;
  bool _isFollowing = false;
  int _likeCount = 384;
  bool _showHeartOverlay = false;
  
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  
  late AnimationController _likeController;
  late Animation<double> _likeScale;
  late AnimationController _heartOverlayController;
  late Animation<double> _heartScale;
  late Animation<Offset> _heartSlide;

  @override
  void initState() {
    super.initState();
    _likeCount = 100 + widget.seed.hashCode % 900; // randomized like count based on seed!
    
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_likeController);

    _heartOverlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300), // Super slow, luxurious floating flow
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 45), // Stays fully visible longer while floating slowly
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: _heartOverlayController,
      curve: Curves.easeInOut,
    ));

    _heartSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -0.6), // Floating upwards
    ).animate(CurvedAnimation(
      parent: _heartOverlayController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize Video Player with fast loading, secure raw GitHub CDN MP4 assets
    final List<String> videoUrls = [
      'https://github.com/intel-iot-devkit/sample-videos/raw/master/classroom.mp4',
      'https://github.com/intel-iot-devkit/sample-videos/raw/master/bolt-detection.mp4',
      'https://github.com/intel-iot-devkit/sample-videos/raw/master/car-detection.mp4',
      'https://github.com/intel-iot-devkit/sample-videos/raw/master/people-detection.mp4',
      'https://github.com/intel-iot-devkit/sample-videos/raw/master/face-demographics-detection.mp4',
      'https://github.com/intel-iot-devkit/sample-videos/raw/master/one-by-one-person-detection.mp4',
      'https://github.com/flutter/assets-for-api-docs/raw/main/assets/videos/butterfly.mp4',
      'https://github.com/flutter/assets-for-api-docs/raw/main/assets/videos/bee.mp4',
    ];
    final String selectedVideo = videoUrls[widget.itemIndex % videoUrls.length];
    
    _videoController = VideoPlayerController.networkUrl(Uri.parse(selectedVideo))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController?.setLooping(true);
          _videoController?.play();
        }
      }).catchError((error) {
        debugPrint("Video Player Error: $error");
      });
  }

  @override
  void dispose() {
    _likeController.dispose();
    _heartOverlayController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    HapticFeedback.mediumImpact();
    setState(() {
      _showHeartOverlay = true;
      if (!_isLiked) {
        _isLiked = true;
        _likeCount++;
        _likeController.forward(from: 0.0);
      }
    });
    _heartOverlayController.forward(from: 0.0).then((_) {
      setState(() {
        _showHeartOverlay = false;
      });
    });
  }

  Widget _buildPremiumGradientHeart(Animation<double> animation) {
    return IgnorePointer(
      child: SlideTransition(
        position: _heartSlide,
        child: ScaleTransition(
          scale: animation,
          child: Transform.rotate(
            angle: -0.15, // Dynamic organic tilt like Instagram
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Premium Glowing Drop Shadow Behind
                const Icon(
                  Icons.favorite_rounded,
                  color: Color(0x99D50000), // Glowing deep crimson red shadow
                  size: 114, // Slightly larger backing shadow for immersive feel
                  shadows: [
                    Shadow(
                      color: Colors.black38,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                // Ultra-Premium Linear-Gradient Front Heart
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFFFF5252), // Premium Vibrant Coral Red
                        Color(0xFFFF1744), // Gorgeous Deep Red
                        Color(0xFFC62828), // Premium Luxurious Crimson
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 110,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCreatorName() {
    final list = [
      "Zara Decor & Royal Weddings",
      "Grand Mahal Events",
      "Stardust Planners",
      "Royal Canopy Lights",
      "Classic Stage Designs"
    ];
    return list[widget.seed.hashCode % list.length];
  }

  String _getDescription() {
    final list = [
      "Luxurious floral canopy setup for a premium outdoor wedding reception. Sparkling fairy lights and handcrafted roses. ✨🌹",
      "Modern minimalist stage decoration with subtle golden accents and pastel drapes. Perfect for elegant evening engagements! 💍✨",
      "Grand entrance decor featuring towering floral arches and a glowing custom monogram pathway. Welcoming guests in absolute luxury! 🎉",
      "Exquisite ceiling lighting decor with thousands of hanging micro-fairy lights creating a celestial dome effect! 🌟💡",
      "Royal wedding mandap setup combining traditional brass lamps with exotic orchids. Pure elegance for holy matrimony! 🌸🕯️"
    ];
    return list[widget.seed.hashCode % list.length];
  }

  @override
  Widget build(BuildContext context) {
    final creator = _getCreatorName();
    final desc = _getDescription();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Immersive Fullscreen Interactive Video Player
          GestureDetector(
            onDoubleTap: _onDoubleTap,
            onTap: () {
              HapticFeedback.lightImpact();
              if (_isVideoInitialized && _videoController != null) {
                setState(() {
                  if (_videoController!.value.isPlaying) {
                    _videoController!.pause();
                  } else {
                    _videoController!.play();
                  }
                });
              }
            },
            child: _isVideoInitialized && _videoController != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: _videoController!.value.size.width,
                            height: _videoController!.value.size.height,
                            child: VideoPlayer(_videoController!),
                          ),
                        ),
                      ),
                      // Animated fading play icon if paused
                      if (!_videoController!.value.isPlaying)
                        AnimatedOpacity(
                          opacity: !_videoController!.value.isPlaying ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                        ),
                    ],
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://picsum.photos/seed/${widget.seed}/1080/1920',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade900,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                          ),
                        ),
                      ),
                      const Center(
                        child: CircularProgressIndicator(color: Color(0xFF7A5405)),
                      ),
                    ],
                  ),
          ),

          // Bottom & Top elegant dark overlays
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // Top Header
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onBack,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.black38,
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Momento',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
                const SizedBox(width: 34), // Spacer balancing the back button
              ],
            ),
          ),

          // Floating Actions on the right side
          Positioned(
            bottom: 40,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Avatar with "+" button
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7A5405),
                      ),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://picsum.photos/seed/${widget.seed}/100/100'),
                      ),
                    ),
                    if (!_isFollowing)
                      Positioned(
                        bottom: -5,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _isFollowing = true;
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF7A5405),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: const Icon(Icons.add, color: Colors.white, size: 10),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Animated Like Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _isLiked = !_isLiked;
                      if (_isLiked) {
                        _likeCount++;
                        _likeController.forward(from: 0.0);
                      } else {
                        _likeCount--;
                      }
                    });
                  },
                  child: ScaleTransition(
                    scale: _likeScale,
                    child: Icon(
                      _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _isLiked ? const Color(0xFFFF1744) : Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_likeCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Comment Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withOpacity(0.55),
                      builder: (context) {
                        return ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.78,
                            color: const Color(0xFFFCFBF7),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Container(
                                  width: 40,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7A5405).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                ),
                                const Expanded(
                                  child: CommentsScreen(autoFocus: true, showBackButton: false),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.mode_comment_outlined, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 6),
                const Text(
                  '82',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Share Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                  },
                  child: const Icon(Icons.near_me_outlined, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 6),
                const Text(
                  '18',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Save Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                  },
                  child: Icon(
                    _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: _isSaved ? const Color(0xFFFFF2A3) : Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 24),

                // Spinning Music Disc
                const SpinningMusicDisc(),
              ],
            ),
          ),

          // Bottom Description and Info
          Positioned(
            left: 16,
            right: 80,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      creator,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: _isFollowing
                            ? BoxDecoration(
                                color: const Color(0xFF7A5405),
                                borderRadius: BorderRadius.circular(16),
                              )
                            : BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white, width: 1.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                        child: Text(
                          _isFollowing ? 'Unfollow' : 'Follow',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Icon(Icons.music_note_rounded, color: Colors.white70, size: 14),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Original Sound - Zara Decorators',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Double Tap Heart Overlay
          if (_showHeartOverlay)
            Center(
              child: _buildPremiumGradientHeart(_heartScale),
            ),
        ],
      ),
    );
  }
}

class PostItemWidget extends StatefulWidget {
  final String seed;

  const PostItemWidget({
    super.key,
    required this.seed,
  });

  @override
  State<PostItemWidget> createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<PostItemWidget> with TickerProviderStateMixin {
  bool _isLiked = false;
  bool _isFollowing = false;
  int _likeCount = 384;
  bool _showHeartOverlay = false;
  Offset? _doubleTapPosition;
  
  late AnimationController _likeController;
  late Animation<double> _likeScale;
  late AnimationController _heartOverlayController;
  late Animation<double> _heartScale;
  late Animation<Offset> _heartSlide;

  @override
  void initState() {
    super.initState();
    _likeCount = 120 + widget.seed.hashCode % 800; // randomized like count based on seed!
    
    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_likeController);

    _heartOverlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300), // Slow luxurious float
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 45), // Stays fully visible longer while floating slowly
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: _heartOverlayController,
      curve: Curves.easeInOut,
    ));

    _heartSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, -0.6), // Float upwards elegantly
    ).animate(CurvedAnimation(
      parent: _heartOverlayController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _likeController.dispose();
    _heartOverlayController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    HapticFeedback.mediumImpact();
    
    final random = Random();
    final double cardWidth = MediaQuery.of(context).size.width - 32;
    
    // Generate organic random coordinate offset near tap area
    final double randomDx = 50.0 + random.nextDouble() * (cardWidth - 100.0);
    final double randomDy = 50.0 + random.nextDouble() * 150.0;
    
    setState(() {
      _doubleTapPosition = Offset(randomDx, randomDy);
      _showHeartOverlay = true;
      if (!_isLiked) {
        _isLiked = true;
        _likeCount++;
        _likeController.forward(from: 0.0);
      }
    });
    _heartOverlayController.forward(from: 0.0).then((_) {
      setState(() {
        _showHeartOverlay = false;
      });
    });
  }

  Widget _buildPremiumGradientHeart(Animation<double> animation) {
    return IgnorePointer(
      child: SlideTransition(
        position: _heartSlide,
        child: ScaleTransition(
          scale: animation,
          child: Transform.rotate(
            angle: -0.15, // Dynamic Instagram organic tilt
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Color(0x99D50000), // Glowing drop shadow back icon
                  size: 104,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xFFFF5252), // Premium Coral Red
                        Color(0xFFFF1744), // Gorgeous Deep Red
                        Color(0xFFC62828), // Luxurious Crimson Red
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCreatorName() {
    final list = [
      "Zara Decor & Royal Weddings",
      "Grand Mahal Events",
      "Stardust Planners",
      "Royal Canopy Lights",
      "Classic Stage Designs"
    ];
    return list[widget.seed.hashCode % list.length];
  }

  String _getDescription() {
    final list = [
      "Luxurious floral canopy setup for a premium outdoor wedding reception. Sparkling fairy lights and handcrafted roses. ✨🌹",
      "Modern minimalist stage decoration with subtle golden accents and pastel drapes. Perfect for elegant evening engagements! 💍✨",
      "Grand entrance decor featuring towering floral arches and a glowing custom monogram pathway. Welcoming guests in absolute luxury! 🎉",
      "Exquisite ceiling lighting decor with thousands of hanging micro-fairy lights creating a celestial dome effect! 🌟💡",
      "Royal wedding mandap setup combining traditional brass lamps with exotic orchids. Pure elegance for holy matrimony! 🌸🕯️"
    ];
    return list[widget.seed.hashCode % list.length];
  }

  @override
  Widget build(BuildContext context) {
    final creator = _getCreatorName();
    final desc = _getDescription();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF7A5405),
                            Color(0xFFDCAE36),
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage('https://picsum.photos/seed/${widget.seed}/100/100'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      creator,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF2C2C2C)),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _isFollowing = !_isFollowing;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: _isFollowing
                        ? BoxDecoration(
                            color: const Color(0xFF7A5405),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF7A5405)),
                          )
                        : BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF7A5405), width: 1.3),
                          ),
                    child: Text(
                      _isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                        color: _isFollowing ? Colors.white : const Color(0xFF7A5405),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Post Image with double tap like
          GestureDetector(
            onDoubleTap: _onDoubleTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://picsum.photos/seed/${widget.seed}/600/600',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 300,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(color: Color(0xFF7A5405)),
                      ),
                    );
                  },
                ),
                if (_showHeartOverlay)
                  _doubleTapPosition != null
                      ? Positioned(
                          left: _doubleTapPosition!.dx - 50, // Center coordinates
                          top: _doubleTapPosition!.dy - 50,
                          child: _buildPremiumGradientHeart(_heartScale),
                        )
                      : _buildPremiumGradientHeart(_heartScale),
              ],
            ),
          ),

          // Post Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _isLiked = !_isLiked;
                              if (_isLiked) {
                                _likeCount++;
                                _likeController.forward(from: 0.0);
                              } else {
                                _likeCount--;
                              }
                            });
                          },
                          child: ScaleTransition(
                            scale: _likeScale,
                            child: Icon(
                              _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 26,
                              color: _isLiked ? const Color(0xFFE0245E) : const Color(0xFF2C2C2C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_likeCount',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.78,
                                    color: const Color(0xFFFCFBF7),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        Container(
                                          width: 40,
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF7A5405).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(2.5),
                                          ),
                                        ),
                                        const Expanded(
                                          child: CommentsScreen(autoFocus: true, showBackButton: false),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.mode_comment_outlined, size: 24, color: Color(0xFF2C2C2C)),
                              SizedBox(width: 6),
                              Text(
                                '82',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C2C2C)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.near_me_outlined, size: 26, color: Color(0xFF2C2C2C)),
                              SizedBox(width: 6),
                              Text(
                                '18',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF2C2C2C)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingSheet(creatorName: creator),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7A5405), Color(0xFFDCAE36)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          child: Text(
                            'Book Now',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

