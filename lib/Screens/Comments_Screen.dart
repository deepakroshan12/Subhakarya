import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommentsScreen extends StatefulWidget {
  final bool autoFocus;
  final bool showBackButton;
  const CommentsScreen({
    super.key,
    this.autoFocus = false,
    this.showBackButton = true,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }
  
  // Dummy starting premium comments list matching wedding decorator niche!
  final List<Map<String, dynamic>> _comments = [
    {
      'name': 'Zara Decor & Weddings',
      'avatar': 'https://picsum.photos/seed/ Zara/100/100',
      'comment': 'The fairy-light canopy setup in the reception hall is absolutely breath-taking! Outstanding job! 🤩✨',
      'time': '2h ago',
      'likes': 14,
      'isLiked': false,
    },
    {
      'name': 'DR Grand Mahal',
      'avatar': 'https://picsum.photos/seed/DrGrand/100/100',
      'comment': 'Highly professional work. The floral entrance decoration completely transformed our main hall. Looking forward to more bookings! 🌸👑',
      'time': '4h ago',
      'likes': 9,
      'isLiked': false,
    },
    {
      'name': 'Stardust Events',
      'avatar': 'https://picsum.photos/seed/Stardust/100/100',
      'comment': 'Stunning pastel color palette choice! The mint green and rose-gold backdrop looks so premium. 👌',
      'time': '5h ago',
      'likes': 3,
      'isLiked': false,
    },
    {
      'name': 'Royal Captures',
      'avatar': 'https://picsum.photos/seed/RoyalCap/100/100',
      'comment': 'The lighting was perfect for photography! Truly created a magical ambience for the couple. 📸✨',
      'time': '1d ago',
      'likes': 7,
      'isLiked': false,
    },
    {
      'name': 'Happy Bride Anjali',
      'avatar': 'https://picsum.photos/seed/Anjali/100/100',
      'comment': 'Thank you so much for making my wedding day a dream come true! Everybody loved the mandap decor. ❤️😭',
      'time': '2d ago',
      'likes': 22,
      'isLiked': false,
    },
  ];

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _comments.add({
        'name': 'You (SubaKaarya Pro)',
        'avatar': 'https://picsum.photos/seed/youpro/100/100',
        'comment': text,
        'time': 'Just now',
        'likes': 0,
        'isLiked': false,
      });
    });

    // Animate item insertion inside the list
    _listKey.currentState?.insertItem(
      _comments.length - 1,
      duration: const Duration(milliseconds: 450),
    );

    _commentController.clear();

    // Auto-scroll to the bottom with high fidelity spring scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeOutBack, // Gorgeous bounce spring scroll!
        );
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF7), // Warm off-white canvas
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFBF7),
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2C2C2C), size: 20),
                splashRadius: 22,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              )
            : null,
        title: Padding(
          padding: EdgeInsets.only(left: widget.showBackButton ? 0.0 : 16.0),
          child: const Text(
            'Comments',
            style: TextStyle(
              color: Color(0xFF2C2C2C),
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: -0.5,
            ),
          ),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '${_comments.length} items',
                style: const TextStyle(
                  color: Color(0xFF7A5405),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(color: Color(0xFFEFECE6), height: 1, thickness: 1),
            
            // Comments Scrollable List with AnimatedList (Silk Entrance!)
            Expanded(
              child: AnimatedList(
                key: _listKey,
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                initialItemCount: _comments.length,
                itemBuilder: (context, index, animation) {
                  final item = _comments[index];
                  // Ultra-premium slide and fade transition combined!
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0.0, 0.35),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOutBack)),
                    ),
                    child: FadeTransition(
                      opacity: animation,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildCommentTile(item, index),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Premium Bottom Interactive Message Input Bar
            _buildBottomInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentTile(Map<String, dynamic> item, int index) {
    final bool isLiked = item['isLiked'] ?? false;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFECE6).withOpacity(0.8), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Styled Gold Gradient Ring Avatar
          Container(
            padding: const EdgeInsets.all(1.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7A5405),
                  Color(0xFFDCAE36),
                  Color(0xFFFFF2A3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              radius: 19,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(item['avatar']),
                backgroundColor: Colors.grey.shade100,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Comment Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    Text(
                      item['time'],
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['comment'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A4A4A),
                    height: 1.45,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 10),
                
                // Reply Button & Small Like stats
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        _commentController.text = '@${item['name'].replaceAll(' ', '')} ';
                        _commentController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _commentController.text.length),
                        );
                        _focusNode.requestFocus(); // Focus the text field to automatically pop open the keyboard!
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: const [
                            Icon(Icons.reply_rounded, size: 14, color: Color(0xFF7A5405)),
                            SizedBox(width: 4),
                            Text(
                              'Reply',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7A5405),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    
                    // Likes Count label
                    if (item['likes'] > 0)
                      Text(
                        '${item['likes']} likes',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          
          // Tap-to-like comment button with elastic spring scale animation
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                item['isLiked'] = !isLiked;
                item['likes'] = isLiked ? item['likes'] - 1 : item['likes'] + 1;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: AnimatedScale(
                scale: isLiked ? 1.25 : 1.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack, // Elastic spring bounce!
                child: Icon(
                  isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: 18,
                  color: isLiked ? const Color(0xFFFF2D55) : const Color(0xFF7A5405),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar() {
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10.0,
        bottom: 12.0, // Fixed: standard bottom padding to avoid clashing with automatic scaffold resize!
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile thumbnail
          const CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage('https://picsum.photos/seed/youpro/100/100'),
          ),
          const SizedBox(width: 12),
          
          // Text Input Field Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFCFBF7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFEFECE6), width: 1.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      focusNode: _focusNode, // Assigned FocusNode to automatically pop open the keyboard!
                      style: const TextStyle(fontSize: 13, color: Color(0xFF2C2C2C)),
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onSubmitted: (_) => _addComment(),
                    ),
                  ),
                  
                  // Send button
                  GestureDetector(
                    onTap: _addComment,
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Color(0xFF7A5405),
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
