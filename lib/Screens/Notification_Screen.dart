import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Comments_Screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF7), // Ultra-premium warm off-white canvas
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFBF7),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2C2C2C), size: 20),
          splashRadius: 22,
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Comments luxury card
              _buildCommentsCard(context),
              const SizedBox(height: 28),
              
              // Section Header: Likes & Activity
              _buildSectionHeader('Likes & Activity'),
              const SizedBox(height: 14),
              
              // Notification List Tiles
              _buildNotificationTile(
                creatorName: 'Zara Decor & Royal Weddings',
                action: 'liked your reception post.',
                time: '2h ago',
                imageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=150&q=80',
              ),
              const SizedBox(height: 12),
              _buildNotificationTile(
                creatorName: 'Stardust Events',
                action: 'commented: "Stunning color palette! 😍"',
                time: '5h ago',
                imageUrl: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&w=150&q=80',
              ),
              const SizedBox(height: 12),
              _buildNotificationTile(
                creatorName: 'Crafty Hands & 3 others',
                action: 'saved your canopy light idea.',
                time: '1d ago',
                imageUrl: 'https://images.unsplash.com/photo-1478812954026-9c750f0e89fc?auto=format&fit=crop&w=150&q=80',
              ),
              const SizedBox(height: 12),
              _buildNotificationTile(
                creatorName: 'Dream Planners',
                action: 'shared your table setup with a client.',
                time: '2d ago',
                imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=150&q=80',
              ),
              
              const SizedBox(height: 28),
              const Divider(color: Color(0xFFEFECE6), thickness: 1.2),
              const SizedBox(height: 20),
              
              // Section Header: Suggested for you
              _buildSectionHeader('Suggested for you'),
              const SizedBox(height: 16),
              
              // Suggestion List
              const SuggestionTile(
                name: 'Event Planner Pro',
                subtitle: 'Suggested for you',
                imageUrl: 'https://picsum.photos/seed/sug1/100/100',
              ),
              const SizedBox(height: 14),
              const SuggestionTile(
                name: 'Royal Decorators',
                subtitle: 'Followed by user1 + 3 more',
                imageUrl: 'https://picsum.photos/seed/sug2/100/100',
              ),
              const SizedBox(height: 14),
              const SuggestionTile(
                name: 'Classic Captures',
                subtitle: 'Suggested for you',
                imageUrl: 'https://picsum.photos/seed/sug3/100/100',
              ),
              const SizedBox(height: 14),
              const SuggestionTile(
                name: 'Grand Mahals',
                subtitle: 'New to SubaKaarya',
                imageUrl: 'https://picsum.photos/seed/sug4/100/100',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF7A5405), // Royal gold tag marker!
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2C2C2C),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF7A5405).withOpacity(0.12), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7A5405).withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A5405).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_rounded,
                  color: Color(0xFF7A5405), // Royal Gold chat icon
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Recent Comments',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStackedAvatars(
                'https://picsum.photos/seed/c1/100/100',
                'https://picsum.photos/seed/c2/100/100',
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.4,
                      color: Color(0xFF4A4A4A),
                      fontFamily: 'Roboto',
                    ),
                    children: [
                      TextSpan(
                        text: 'Pr event decoration & DR Grand Mahal ',
                        style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2C2C2C)),
                      ),
                      TextSpan(
                        text: 'and others posted comments on your wedding project.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommentsScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF7A5405),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: Color(0xFF7A5405),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required String creatorName,
    required String action,
    required String time,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFEFECE6).withOpacity(0.5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
          },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStackedAvatars(
                  'https://picsum.photos/seed/${creatorName.hashCode}/100/100',
                  'https://picsum.photos/seed/${creatorName.hashCode + 1}/100/100',
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF4A4A4A),
                            fontFamily: 'Roboto',
                          ),
                          children: [
                            TextSpan(
                              text: '$creatorName ',
                              style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2C2C2C)),
                            ),
                            TextSpan(
                              text: action,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 60,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade200, width: 0.8),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStackedAvatars(String img1, String img2) {
    return SizedBox(
      width: 52,
      height: 44,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFF2A3), width: 1.5), // Luxury gold ring
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(img1),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF7A5405), width: 1.5), // Luxury gold ring
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(img2),
                backgroundColor: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestionTile extends StatefulWidget {
  final String name;
  final String subtitle;
  final String imageUrl;

  const SuggestionTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  State<SuggestionTile> createState() => _SuggestionTileState();
}

class _SuggestionTileState extends State<SuggestionTile> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFECE6).withOpacity(0.8), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
          },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
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
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.imageUrl),
                      backgroundColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Color(0xFF2C2C2C),
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      isFollowing = !isFollowing;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                    decoration: isFollowing
                        ? BoxDecoration(
                            color: const Color(0xFF7A5405), // Royal Gold filled background
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF7A5405)),
                          )
                        : BoxDecoration(
                            color: Colors.transparent, // Hollow royal outline
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF7A5405),
                              width: 1.3,
                            ),
                          ),
                    child: Text(
                      isFollowing ? 'Unfollow' : 'Follow',
                      style: TextStyle(
                        color: isFollowing ? Colors.white : const Color(0xFF7A5405),
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
