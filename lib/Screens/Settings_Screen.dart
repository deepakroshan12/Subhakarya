import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Home_Screen.dart'; // To access appThemeModeNotifier

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _whatsAppReminders = true;
  bool _twoFactorAuth = false;
  bool _darkMode = false;
  String _selectedLanguage = 'English';
  String _defaultSeating = 'Banquet';

  @override
  void initState() {
    super.initState();
    // Initialize dark mode state based on global ValueNotifier
    _darkMode = appThemeModeNotifier.value == ThemeMode.dark;
  }

  void _showLogoutDialog() {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _darkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log Out',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: _darkMode ? Colors.white : const Color(0xFF2C2C2C),
          ),
        ),
        content: Text(
          'Are you sure you want to log out of Subakaarya?',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: _darkMode ? Colors.grey.shade400 : const Color(0xFF6C6C6C),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF7A5405), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.vibrate();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Pop Settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Successfully logged out!', style: TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.grey.shade800,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.all(20),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isDark = _darkMode;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFFCFBF7);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Immersive Gradient Header
          AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7A5405), Color(0xFFDCAE36)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7A5405).withOpacity(isDark ? 0.3 : 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 36),
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              children: [
                // Account & Business Section
                _buildSectionHeader('Account & Business'),
                _buildCard([
                  _buildListTile(
                    icon: Icons.bookmark_outline_rounded,
                    title: 'Saved Favorites',
                    subtitle: 'Quickly access saved halls & decorators',
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.history_rounded,
                    title: 'Your Activity & History',
                    subtitle: 'Check detailed logs of your bookings',
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.storefront_rounded,
                    title: 'Manage Host Profile',
                    subtitle: 'Hall capacity, seating count & parking details',
                    onTap: () {
                      HapticFeedback.mediumImpact();
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.receipt_long_rounded,
                    title: 'GST & Invoicing Profile',
                    subtitle: 'GST details, billing address & payment history',
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                ]),
                const SizedBox(height: 24),

                // Communication Settings
                _buildSectionHeader('Communication'),
                _buildCard([
                  _buildSwitchTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Push Notifications',
                    subtitle: 'Instant alerts for booking request updates',
                    value: _pushNotifications,
                    onChanged: (v) => setState(() => _pushNotifications = v),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Email Invoices & Reports',
                    subtitle: 'Weekly service summary and payment details',
                    value: _emailAlerts,
                    onChanged: (v) => setState(() => _emailAlerts = v),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'WhatsApp Guest Reminders',
                    subtitle: 'Send automated wedding invite links & updates',
                    value: _whatsAppReminders,
                    onChanged: (v) => setState(() => _whatsAppReminders = v),
                  ),
                ]),
                const SizedBox(height: 24),

                // App Preferences
                _buildSectionHeader('App Preferences'),
                _buildCard([
                  _buildDropdownTile(
                    icon: Icons.translate_rounded,
                    title: 'App Language',
                    value: _selectedLanguage,
                    items: ['English', 'Tamil'],
                    onChanged: (v) => setState(() => _selectedLanguage = v!),
                  ),
                  _buildDivider(),
                  _buildDropdownTile(
                    icon: Icons.event_seat_rounded,
                    title: 'Default Stage Layout',
                    value: _defaultSeating,
                    items: ['Banquet', 'Theater Style', 'Cluster Seating', 'U-Shape Style'],
                    onChanged: (v) => setState(() => _defaultSeating = v!),
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode Theme',
                    subtitle: 'Saves battery & easier on eyes',
                    value: _darkMode,
                    onChanged: (v) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _darkMode = v;
                      });
                      // Update global ValueNotifier to trigger app-wide re-render
                      appThemeModeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ]),
                const SizedBox(height: 24),

                // Security & Help Section
                _buildSectionHeader('Security & Help'),
                _buildCard([
                  _buildSwitchTile(
                    icon: Icons.security_outlined,
                    title: 'Two-Factor Authentication (2FA)',
                    subtitle: 'Secure host login using OTP validation',
                    value: _twoFactorAuth,
                    onChanged: (v) => setState(() => _twoFactorAuth = v),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.menu_book_rounded,
                    title: 'Wedding Planner FAQ Guide',
                    subtitle: 'Decorator onboarding guides and resources',
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'How we protect your business data',
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    subtitle: 'Rules for booking and hosting services',
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                  ),
                  _buildDivider(),
                  _buildListTile(
                    icon: Icons.support_agent_rounded,
                    title: 'Help Desk Support',
                    subtitle: 'Contact customer help desk 24/7',
                    onTap: () {
                      HapticFeedback.mediumImpact();
                    },
                  ),
                ]),
                const SizedBox(height: 32),

                // Log out Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: _showLogoutDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF2E2E2E) : Colors.red.shade100,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(isDark ? 0.0 : 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.logout_rounded, color: Color(0xFFD32F2F), size: 20),
                          SizedBox(width: 12),
                          Text(
                            'Log Out of Account',
                            style: TextStyle(
                              color: Color(0xFFD32F2F),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          color: Color(0xFF7A5405),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    final isDark = _darkMode;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2E2E2E) : Colors.grey.shade100;
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    final isDark = _darkMode;
    final dividerColor = isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100;
    return Divider(height: 1, thickness: 1, color: dividerColor);
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = _darkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade500;
    final iconBgColor = const Color(0xFF7A5405).withOpacity(isDark ? 0.18 : 0.08);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF7A5405), size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: subtitleColor, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 14),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = _darkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade500;
    final iconBgColor = const Color(0xFF7A5405).withOpacity(isDark ? 0.18 : 0.08);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF7A5405), size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: subtitleColor, fontWeight: FontWeight.w500)),
      trailing: Switch(
        value: value,
        activeColor: const Color(0xFF7A5405),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = _darkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    final iconBgColor = const Color(0xFF7A5405).withOpacity(isDark ? 0.18 : 0.08);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF7A5405), size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A5405)),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isDark ? Colors.white : const Color(0xFF7A5405),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
