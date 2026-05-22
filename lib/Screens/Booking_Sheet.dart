import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:subakaarya/Screens/Home_Screen.dart';

// ── Global booking store ──────────────────────────────────────
class BookingData {
  final String creatorName;
  final String date;
  final String time;
  final String eventType;
  final String guestName;
  final String phone;
  final String address;
  final String paymentMethod;
  final DateTime bookedAt;
  
  // Mahal Booking Specifics
  final String guestCount;
  final String cateringPref;
  final String roomsCount;
  final String bookingDuration;
  final String status; // 'Completed', 'On Hold', 'Cancelled'

  const BookingData({
    required this.creatorName,
    required this.date,
    required this.time,
    required this.eventType,
    required this.guestName,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.bookedAt,
    this.guestCount = '200 - 500',
    this.cateringPref = 'Veg Only',
    this.roomsCount = '1 - 2 Rooms',
    this.bookingDuration = 'Full Day',
    this.status = 'On Hold',
  });
}

final List<BookingData> globalBookings = [
  BookingData(
    creatorName: 'DR GRAND MAHAL',
    date: 'May 10, 2026',
    time: '09:00 AM',
    eventType: 'Wedding Reception',
    guestName: 'Karthik Raja',
    phone: '9876543210',
    address: 'No. 12, GST Road, Chennai',
    paymentMethod: 'Credit Card',
    bookedAt: DateTime.now().subtract(const Duration(days: 10)),
    status: 'On Going',
  ),
  BookingData(
    creatorName: 'Royal Orchid Decorators',
    date: 'May 21, 2026',
    time: '11:00 AM',
    eventType: 'Luxury Sangeet',
    guestName: 'Sanjay Kapoor',
    phone: '9845612300',
    address: 'ECR Road, Chennai',
    paymentMethod: 'UPI',
    bookedAt: DateTime.now().subtract(const Duration(hours: 4)),
    status: 'On Going',
  ),
  BookingData(
    creatorName: 'Stardust Planners',
    date: 'May 28, 2026',
    time: '06:00 PM',
    eventType: 'Birthday Bash',
    guestName: 'Anitha Selvam',
    phone: '9123456780',
    address: 'Anna Nagar, Chennai',
    paymentMethod: 'UPI / NetBanking',
    bookedAt: DateTime.now().subtract(const Duration(days: 1)),
    status: 'On Hold',
  ),
  BookingData(
    creatorName: 'Zara Decor & Royal Weddings',
    date: 'May 05, 2026',
    time: '10:00 AM',
    eventType: 'Corporate Gala',
    guestName: 'Rajesh Kumar',
    phone: '9001122334',
    address: 'OMR, Chennai',
    paymentMethod: 'Cash',
    bookedAt: DateTime.now().subtract(const Duration(days: 15)),
    status: 'Cancelled',
  ),
  BookingData(
    creatorName: 'Silverline Banquets',
    date: 'May 02, 2026',
    time: '07:00 PM',
    eventType: 'Reception & Dinner',
    guestName: 'Manoj Kumar',
    phone: '9444123456',
    address: 'Vadapalani, Chennai',
    paymentMethod: 'NetBanking',
    bookedAt: DateTime.now().subtract(const Duration(days: 20)),
    status: 'Completed',
  ),
];

class BookingSheet extends StatefulWidget {
  final String creatorName;
  final VoidCallback? onBookingConfirmed;

  const BookingSheet({
    super.key,
    required this.creatorName,
    this.onBookingConfirmed,
  });

  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;
  bool _isBooked = false;
  bool _isLoading = false;
  late ScrollController _scrollController;
  bool _isButtonVisible = true;

  int _currentStep = 0;
  int _selectedPaymentMethod = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedEventType = 'Wedding';
  final List<String> _eventTypes = ['Wedding', 'Reception', 'Engagement', 'Birthday Party', 'Corporate Event', 'Other'];

  String _selectedGuestCount = '200 - 500';
  final List<String> _guestCountOptions = ['Up to 200', '200 - 500', '500 - 1000', '1000 - 2000', '2000+'];

  String _selectedCateringPref = 'Veg Only';
  final List<String> _cateringPrefOptions = ['Veg Only', 'Veg & Non-Veg'];
  bool _isCateringNeeded = false;

  String _selectedAdvanceOption = 'Pay Advance Booking Fee (₹25,000)';
  final List<String> _advanceOptions = ['Pay Advance Booking Fee (₹25,000)', 'Pay Full Booking Amount (100%)'];

  String _selectedRoomsCount = '1 - 2 Rooms';
  final List<String> _roomsCountOptions = ['None', '1 - 2 Rooms', '3 - 5 Rooms', '6 - 10 Rooms', '10+ Rooms'];
  bool _isRoomsNeeded = false;

  String _selectedBookingDuration = 'Full Day';
  final List<String> _bookingDurationOptions = ['Full Day', 'Morning Session (6 AM - 2 PM)', 'Evening Session (3 PM - 10 PM)', 'Multi-Day'];


  String _getMahalAddress() {
    final name = widget.creatorName.toLowerCase();
    if (name.contains('svt') || name.contains('s.v.t')) {
      return 'SVT Mahal, 12, Bypass Road, Madurai, Tamil Nadu 625016';
    } else if (name.contains('vignesh')) {
      return 'Vignesh Mahal, Melur Main Road, Madurai, Tamil Nadu 625020';
    } else if (name.contains('royal') || name.contains('palace')) {
      return 'Royal Palace Hall, 45, Anna Salai, Chennai, Tamil Nadu 600002';
    } else if (name.contains('gokulam')) {
      return 'Gokulam Hall, Avinashi Road, Coimbatore, Tamil Nadu 641018';
    } else if (name.contains('star')) {
      return 'Star Function Hall, Palace Road, Trichy, Tamil Nadu 620001';
    } else {
      return '${widget.creatorName}, Bypass Ring Road, Madurai, Tamil Nadu 625012';
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _dates.addAll(_generateSequentialDates(DateTime.now()));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isButtonVisible) {
        setState(() {
          _isButtonVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isButtonVisible) {
        setState(() {
          _isButtonVisible = true;
        });
      }
    }
  }

  final List<Map<String, dynamic>> _extraReviews = [
    {
      'reviewer': 'Rajesh Kumar',
      'text': 'Decorations la design ellame super ah irundhuchi, correct timing ku finish panni kuduthanga. Highly recommended for premium look!',
      'stars': 5
    },
    {
      'reviewer': 'Meera Krishnan',
      'text': 'Quality of work is very premium. Prices are high but completely worth it for luxurious wedding setups and excellent service.',
      'stars': 4
    },
    {
      'reviewer': 'Senthil V',
      'text': 'Founders and decorators behavior was very soft and professional. Response and communication is clean. Happy booking!',
      'stars': 5
    },
    {
      'reviewer': 'Anitha R',
      'text': 'Subakaarya app valiya book pannadhala extra discounts kidaichadhu. Payment safe ah irundhuchu. No issues at all. Highly satisfied!',
      'stars': 5
    },
  ];

  final List<Map<String, String>> _dates = [];

  List<Map<String, String>> _generateSequentialDates(DateTime startDate) {
    final List<String> weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    final List<String> months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

    return List.generate(10, (i) {
      final date = startDate.add(Duration(days: i));
      final monthStr = months[date.month - 1];
      final dayStr = date.day.toString().padLeft(2, '0');
      final weekdayStr = weekdays[date.weekday % 7];

      final int day = date.day;
      final int weekday = date.weekday;
      String statusStr;
      String slotsStr;
      if (weekday == 6 || weekday == 7) {
        if (day % 3 == 0) {
          statusStr = 'filling';
          slotsStr = '2';
        } else {
          statusStr = 'booked';
          slotsStr = '0';
        }
      } else if (weekday == 5 || weekday == 1) {
        if (day % 2 == 0) {
          statusStr = 'booked';
          slotsStr = '0';
        } else {
          statusStr = 'filling';
          slotsStr = '1';
        }
      } else {
        if (day % 5 == 0) {
          statusStr = 'filling';
          slotsStr = '2';
        } else {
          statusStr = 'available';
          slotsStr = '4';
        }
      }

      return {
        'month': monthStr,
        'day': dayStr,
        'weekday': weekdayStr,
        'slots': slotsStr,
        'status': statusStr,
      };
    });
  }

  final List<String> _times = [
    '09:00 AM',
    '11:00 AM',
    '05:35 PM',
    '07:00 PM',
  ];

  void _confirmBooking() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        HapticFeedback.vibrate();
        // Save booking to global store
        final paymentLabels = ['UPI / GPay / PhonePe', 'Credit / Debit Card', 'Pay on Arrival (Cash)'];
        globalBookings.insert(0, BookingData(
          creatorName: widget.creatorName,
          date: '${_dates[_selectedDateIndex]['weekday']}, ${_dates[_selectedDateIndex]['day']} ${_dates[_selectedDateIndex]['month']}',
          time: _times[_selectedTimeIndex == -1 ? 0 : _selectedTimeIndex],
          eventType: _selectedEventType,
          guestName: _nameController.text.isNotEmpty ? _nameController.text : 'Guest',
          phone: _phoneController.text,
          address: _getMahalAddress(),
          paymentMethod: paymentLabels[_selectedPaymentMethod],
          bookedAt: DateTime.now(),
          guestCount: _selectedGuestCount,
          cateringPref: _isCateringNeeded ? _selectedCateringPref : 'No Catering Needed (Hall Only)',
          roomsCount: _isRoomsNeeded ? _selectedRoomsCount : 'None',
          bookingDuration: _selectedBookingDuration,
        ));
        setState(() {
          _isLoading = false;
          _isBooked = true;
        });
      }
    });
  }

  Widget _buildStepIndicator() {
    final steps = ['Booking', 'Details', 'Payment'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i == _currentStep;
          final isDone = i < _currentStep;
          return Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? const Color(0xFF388E3C)
                        : isActive
                            ? const Color(0xFF7A5405)
                            : Colors.grey.shade200,
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                        : Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.white : Colors.grey.shade400,
                            ),
                          ),
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isDone ? const Color(0xFF388E3C) : Colors.grey.shade200,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDetailsForm() {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF7A5405).withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDCAE36).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, color: Color(0xFF7A5405), size: 18),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_dates[_selectedDateIndex]['weekday']}, ${_dates[_selectedDateIndex]['day']} ${_dates[_selectedDateIndex]['month']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C2C2C)),
                      ),
                      Text(
                        _times[_selectedTimeIndex == -1 ? 0 : _selectedTimeIndex],
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Your Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your full name',
                prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF7A5405), size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7A5405))),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '+91 00000 00000',
                prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF7A5405), size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7A5405))),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Please enter your phone number' : null,
            ),
            const SizedBox(height: 16),
            const Text('Event Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedEventType,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A5405)),
                  items: _eventTypes.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                  onChanged: (v) => setState(() => _selectedEventType = v!),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.business_rounded, color: Color(0xFF7A5405), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Mahal Booking Details'.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: Color(0xFF7A5405),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: const Color(0xFF7A5405).withOpacity(0.15), height: 1),
            const SizedBox(height: 16),

            // Row for Guest Capacity & Booking Duration
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expected Guests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGuestCount,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A5405)),
                            items: _guestCountOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
                            onChanged: (v) => setState(() => _selectedGuestCount = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Booking Duration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedBookingDuration,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A5405)),
                            items: _bookingDurationOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
                            onChanged: (v) => setState(() => _selectedBookingDuration = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rooms Required Switch Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _isRoomsNeeded ? const Color(0xFF7A5405).withOpacity(0.3) : Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.king_bed_rounded, color: _isRoomsNeeded ? const Color(0xFF7A5405) : Colors.grey.shade400, size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Rooms Required?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
                          Text(
                            _isRoomsNeeded ? 'Yes, reserve rooms at venue' : 'No rooms needed',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _isRoomsNeeded,
                    activeColor: const Color(0xFF7A5405),
                    onChanged: (v) {
                      setState(() {
                        _isRoomsNeeded = v;
                        if (v && _selectedRoomsCount == 'None') {
                          _selectedRoomsCount = '1 - 2 Rooms';
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_isRoomsNeeded) ...[
              const SizedBox(height: 12),
              const Text('Select Number of Rooms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRoomsCount == 'None' ? '1 - 2 Rooms' : _selectedRoomsCount,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A5405)),
                    items: _roomsCountOptions.where((opt) => opt != 'None').map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (v) => setState(() => _selectedRoomsCount = v!),
                  ),
                ),
              ),
            ],

            // ── Catering Preferences ──────────────────────────────────────
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.restaurant_rounded, color: Color(0xFF7A5405), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Catering Preferences'.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: Color(0xFF7A5405),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: const Color(0xFF7A5405).withOpacity(0.15), height: 1),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _isCateringNeeded ? const Color(0xFF7A5405).withOpacity(0.3) : Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dining_rounded, color: _isCateringNeeded ? const Color(0xFF7A5405) : Colors.grey.shade400, size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Catering Needed?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
                          Text(
                            _isCateringNeeded ? 'Yes, include food service' : 'No, hall only',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: _isCateringNeeded,
                    activeColor: const Color(0xFF7A5405),
                    onChanged: (v) => setState(() => _isCateringNeeded = v),
                  ),
                ],
              ),
            ),
            if (_isCateringNeeded) ...[
              const SizedBox(height: 12),
              const Text('Food Preference', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2C2C2C))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCateringPref,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF7A5405)),
                    items: _cateringPrefOptions.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (v) => setState(() => _selectedCateringPref = v!),
                  ),
                ),
              ),
            ],

            // ── Payment & Advance Details ─────────────────────────────────
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF7A5405), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Payment & Advance Details'.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: Color(0xFF7A5405),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: const Color(0xFF7A5405).withOpacity(0.15), height: 1),
            const SizedBox(height: 12),
            ...List.generate(_advanceOptions.length, (i) {
              final isSelected = _selectedAdvanceOption == _advanceOptions[i];
              return GestureDetector(
                onTap: () => setState(() => _selectedAdvanceOption = _advanceOptions[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF7A5405).withOpacity(0.07) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF7A5405) : Colors.grey.shade200,
                      width: isSelected ? 1.8 : 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF7A5405) : Colors.grey.shade400,
                            width: 2,
                          ),
                          color: isSelected ? const Color(0xFF7A5405) : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _advanceOptions[i],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isSelected ? const Color(0xFF2C2C2C) : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Color(0xFF7A5405), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Advance amount is non-refundable. Balance to be paid before the event date.',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentPage() {
    final methods = [
      {'icon': Icons.account_balance_wallet_rounded, 'label': 'UPI / GPay / PhonePe'},
      {'icon': Icons.credit_card_rounded, 'label': 'Credit / Debit Card'},
      {'icon': Icons.currency_rupee_rounded, 'label': 'Pay on Arrival (Cash)'},
    ];

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF7A5405), Color(0xFFDCAE36)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Booking Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('${_dates[_selectedDateIndex]['weekday']}, ${_dates[_selectedDateIndex]['day']} ${_dates[_selectedDateIndex]['month']} • ${_times[_selectedTimeIndex == -1 ? 0 : _selectedTimeIndex]}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(_nameController.text.isNotEmpty ? _nameController.text : 'Guest', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Choose Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2C2C2C))),
          const SizedBox(height: 12),
          ...List.generate(methods.length, (i) {
            final isSelected = _selectedPaymentMethod == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedPaymentMethod = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF7A5405).withOpacity(0.07) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF7A5405) : Colors.grey.shade200,
                    width: isSelected ? 1.8 : 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF7A5405) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(methods[i]['icon'] as IconData, color: isSelected ? Colors.white : Colors.grey.shade600, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Text(methods[i]['label'] as String, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isSelected ? const Color(0xFF2C2C2C) : Colors.grey.shade700)),
                    const Spacer(),
                    if (isSelected) const Icon(Icons.check_circle_rounded, color: Color(0xFF7A5405), size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFF0FFF4), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB7EB8F))),
            child: const Row(
              children: [
                Icon(Icons.lock_outline_rounded, color: Color(0xFF389E0D), size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('Your payment is 100% secure & encrypted by Subakaarya', style: TextStyle(fontSize: 12, color: Color(0xFF389E0D), fontWeight: FontWeight.w500))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dates.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final selectedDate = _dates[_selectedDateIndex];
    final isBookedDate = selectedDate['status'] == 'booked';

    String stepTitle = 'Confirm Booking';
    if (_currentStep == 1) stepTitle = 'Your Details';
    if (_currentStep == 2) stepTitle = 'Payment';

    String buttonLabel = 'Continue to Details';
    if (_currentStep == 1) buttonLabel = 'Continue to Payment';
    if (_currentStep == 2) buttonLabel = 'Confirm & Pay Now';

    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBF7),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Premium Full-Screen Immersive Gradient Header
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
                          color: const Color(0xFF7A5405).withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_currentStep == 0) {
                              Navigator.pop(context);
                            } else {
                              setState(() => _currentStep--);
                            }
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
                        Text(
                          stepTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        _currentStep == 0
                            ? GestureDetector(
                                onTap: () => _selectCustomDate(context),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
                                ),
                              )
                            : const SizedBox(width: 36),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Step content
                Expanded(
                  child: _currentStep == 0
                      ? _buildBookingStep(selectedDate, isBookedDate)
                      : _currentStep == 1
                          ? _buildDetailsForm()
                          : _buildPaymentPage(),
                ),
              ],
            ),

            // Fixed bottom button
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: (_currentStep == 0 && isBookedDate)
                      ? const LinearGradient(colors: [Color(0xFFB0BEC5), Color(0xFFCFD8DC)])
                      : const LinearGradient(colors: [Color(0xFF7A5405), Color(0xFFDCAE36)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: (_currentStep == 0 && isBookedDate)
                      ? null
                      : [BoxShadow(color: const Color(0xFF7A5405).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: ElevatedButton(
                  onPressed: (_isLoading || (_currentStep == 0 && isBookedDate))
                      ? null
                      : () {
                          HapticFeedback.mediumImpact();
                          if (_currentStep == 0) {
                            setState(() => _currentStep = 1);
                          } else if (_currentStep == 1) {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _currentStep = 2);
                            }
                          } else {
                            _confirmBooking();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text(
                          (_currentStep == 0 && isBookedDate) ? 'Fully Booked on this Date' : buttonLabel,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ),

            // Booked success overlay
            if (_isBooked)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: AnimatedScale(
                      scale: _isBooked ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.elasticOut,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 28),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF7A5405), Color(0xFFDCAE36)]),
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: const Color(0xFFDCAE36).withOpacity(0.35), blurRadius: 18, spreadRadius: 2)],
                              ),
                              child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
                            ),
                            const SizedBox(height: 20),
                            const Text('Booking Confirmed! 🎉', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2C2C2C))),
                            const SizedBox(height: 10),
                            const Text(
                              'Your Subakaarya decorator is successfully reserved.\nOur team will contact you shortly.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: Color(0xFF6C6C6C), height: 1.5),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Navigate to Bookings tab (index 2)
                                  navigateToTabNotifier.value = 2;
                                  widget.onBookingConfirmed?.call();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7A5405),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text('Awesome! 🙌', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectCustomDate(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => _CustomCalendarDialog(initialDate: DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        _dates.clear();
        _dates.addAll(_generateSequentialDates(picked));
        _selectedDateIndex = 0;
        final statusStr = _dates[0]['status']!;
        _selectedTimeIndex = statusStr == 'booked' ? -1 : 0;
      });
      HapticFeedback.mediumImpact();
    }
  }

  Widget _buildBookingStep(Map<String, String> selectedDate, bool isBookedDate) {
    return Column(
      children: [
        // Horizontal Dates list
        SizedBox(
          height: 98,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _dates.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedDateIndex == index;
              final date = _dates[index];
              final status = date['status'] ?? 'available';
              Color statusColor;
              String statusLabel;

              if (status == 'booked') {
                statusColor = const Color(0xFFD32F2F);
                statusLabel = 'BOOKED';
              } else if (status == 'filling') {
                statusColor = const Color(0xFFFFB300);
                statusLabel = '1-2 SLOTS';
              } else {
                statusColor = const Color(0xFF388E3C);
                statusLabel = 'AVAIL';
              }

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedDateIndex = index;
                    final newStatus = _dates[index]['status'] ?? 'available';
                    if (newStatus == 'booked') {
                      _selectedTimeIndex = -1;
                    } else {
                      _selectedTimeIndex = 0;
                    }
                  });
                },
                child: AnimatedScale(
                  scale: isSelected ? 1.04 : 0.96,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 68,
                    decoration: BoxDecoration(
                      color: isSelected ? statusColor : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: isSelected
                          ? null
                          : Border.all(color: statusColor.withOpacity(0.35), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? statusColor.withOpacity(0.3) : Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 6),
                        Text(date['month']!, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: isSelected ? Colors.white70 : Colors.grey.shade600)),
                        Text(date['day']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : const Color(0xFF2C2C2C))),
                        Text(date['weekday']!, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: isSelected ? Colors.white70 : Colors.grey.shade600)),
                        const SizedBox(height: 2),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white.withOpacity(0.18) : statusColor.withOpacity(0.12),
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                          ),
                          child: Center(
                            child: Text(statusLabel, style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : statusColor, letterSpacing: 0.2)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // Scrollable content
        Flexible(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timing Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8))],
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Timing of booking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF2C2C2C))),
                      const SizedBox(height: 4),
                      if (isBookedDate) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFFCDD2))),
                          child: Row(children: const [
                            Icon(Icons.error_outline_rounded, color: Color(0xFFD32F2F), size: 16),
                            SizedBox(width: 8),
                            Expanded(child: Text('No slots available! All timings are fully booked for this date.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)))),
                          ]),
                        ),
                      ] else ...[
                        Text('Cancelation available', style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                      ],
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 16,
                        children: List.generate(_times.length, (index) {
                          final String status = selectedDate['status'] ?? 'available';
                          final int slotsCount = int.tryParse(selectedDate['slots'] ?? '4') ?? 4;
                          bool isSlotEnabled = true;
                          if (status == 'booked') {
                            isSlotEnabled = false;
                          } else if (status == 'filling') {
                            if (slotsCount == 1) isSlotEnabled = index == 0;
                            else if (slotsCount == 2) isSlotEnabled = index < 2;
                          }
                          final isSelected = _selectedTimeIndex == index;
                          return GestureDetector(
                            onTap: !isSlotEnabled ? null : () {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedTimeIndex = index);
                            },
                            child: AnimatedScale(
                              scale: !isSlotEnabled ? 1.0 : (isSelected ? 1.05 : 0.95),
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutBack,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: BoxDecoration(
                                  color: !isSlotEnabled ? Colors.grey.shade100 : (isSelected ? const Color(0xFF7A5405) : Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: !isSlotEnabled ? Colors.grey.shade300 : (isSelected ? const Color(0xFF7A5405) : const Color(0xFFDCAE36)), width: 1.5),
                                ),
                                child: Text(_times[index], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: !isSlotEnabled ? Colors.grey.shade400 : (isSelected ? Colors.white : const Color(0xFF2C2C2C)))),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Mahal Address Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFDCAE36).withOpacity(0.3)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A5405).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.location_on_rounded, color: Color(0xFF7A5405), size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MAHAL ADDRESS',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF7A5405),
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getMahalAddress(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C2C2C),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Reviews
                const Text('Customer reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF2C2C2C))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(4, (i) => const Icon(Icons.star_rounded, color: Color(0xFFDCAE36), size: 18)),
                    const Icon(Icons.star_half_rounded, color: Color(0xFFDCAE36), size: 18),
                    const SizedBox(width: 8),
                    const Text('4.5', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2C))),
                    const SizedBox(width: 4),
                    Text('(128 reviews)', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
                const SizedBox(height: 20),
                ..._extraReviews.map((review) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 18, backgroundColor: const Color(0xFF7A5405).withOpacity(0.1), child: const Icon(Icons.person_outline_rounded, color: Color(0xFF7A5405), size: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review['reviewer'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2C))),
                              const SizedBox(height: 4),
                              Text(review['text'] as String, style: const TextStyle(fontSize: 13, color: Color(0xFF4A4A4A), height: 1.45, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Row(children: [
                                ...List.generate(review['stars'] as int, (i) => const Icon(Icons.star, color: Color(0xFFDCAE36), size: 16)),
                                ...List.generate(5 - (review['stars'] as int), (i) => const Icon(Icons.star_border, color: Color(0xFFDCAE36), size: 16)),
                                const SizedBox(width: 6),
                                Text('${review['stars']} out of 5 ratings', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class _CustomCalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  const _CustomCalendarDialog({required this.initialDate});

  @override
  State<_CustomCalendarDialog> createState() => _CustomCalendarDialogState();
}

class _CustomCalendarDialogState extends State<_CustomCalendarDialog> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  bool _isChoosingMonthYear = false;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    _selectedDate = widget.initialDate;
  }

  String _getDayStatus(DateTime date) {
    // Generate deterministic availability status
    final day = date.day;
    final weekday = date.weekday;
    
    if (weekday == 6 || weekday == 7) {
      if (day % 3 == 0) return 'filling';
      return 'booked';
    } else if (weekday == 5 || weekday == 1) {
      if (day % 2 == 0) return 'booked';
      return 'filling';
    } else {
      if (day % 5 == 0) return 'filling';
      return 'available';
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final monthsAbbrev = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final int year = _currentMonth.year;
    final int month = _currentMonth.month;
    
    final firstDayOfMonth = DateTime(year, month, 1);
    final totalDays = DateTime(year, month + 1, 0).day;
    
    // Sunday = 0, Monday = 1, ... Saturday = 6
    final int firstDayOffset = firstDayOfMonth.weekday % 7;
    
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);

    return Dialog(
      backgroundColor: const Color(0xFFFCFBF7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _isChoosingMonthYear
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF7A5405), size: 16),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _isChoosingMonthYear = false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'Choose Month & Year',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Selection body
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Months grid (Left side)
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 240,
                            child: GridView.builder(
                              itemCount: 12,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1.2,
                              ),
                              itemBuilder: (context, index) {
                                final isCurrent = (index + 1) == _currentMonth.month;
                                return GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      _currentMonth = DateTime(_currentMonth.year, index + 1, 1);
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isCurrent ? const Color(0xFF7A5405) : const Color(0xFF7A5405).withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      monthsAbbrev[index],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isCurrent ? Colors.white : const Color(0xFF7A5405),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Years list (Right side)
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 240,
                            decoration: BoxDecoration(
                              border: Border(left: BorderSide(color: Colors.grey.shade200, width: 1.5)),
                            ),
                            padding: const EdgeInsets.only(left: 12),
                            child: ListView.builder(
                              itemCount: 6, // 2026 to 2031
                              itemBuilder: (context, index) {
                                final int yearNum = 2026 + index;
                                final isCurrent = yearNum == _currentMonth.year;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      setState(() {
                                        _currentMonth = DateTime(yearNum, _currentMonth.month, 1);
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isCurrent ? const Color(0xFF7A5405) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: isCurrent ? null : Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Text(
                                        '$yearNum',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrent ? Colors.white : const Color(0xFF2C2C2C),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Done Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF7A5405), Color(0xFFDCAE36)]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _isChoosingMonthYear = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Confirm Month & Year',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header: Title
                    const Text(
                      'Select Booking Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2C2C2C),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Month Switcher Selector Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF7A5405), size: 28),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _currentMonth = DateTime(year, month - 1, 1);
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _isChoosingMonthYear = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7A5405).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${months[month - 1]} $year',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF7A5405),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF7A5405), size: 20),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF7A5405), size: 28),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _currentMonth = DateTime(year, month + 1, 1);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Weekday initials row (Sun to Sat)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _WeekdayHeader('S'),
                        _WeekdayHeader('M'),
                        _WeekdayHeader('T'),
                        _WeekdayHeader('W'),
                        _WeekdayHeader('T'),
                        _WeekdayHeader('F'),
                        _WeekdayHeader('S'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Grid of days
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: firstDayOffset + totalDays,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        if (index < firstDayOffset) {
                          return const SizedBox();
                        }
                        
                        final int dayNum = index - firstDayOffset + 1;
                        final date = DateTime(year, month, dayNum);
                        final isPast = date.isBefore(todayMidnight);
                        final isSelected = date.year == _selectedDate.year &&
                                           date.month == _selectedDate.month &&
                                           date.day == _selectedDate.day;
                        
                        final status = _getDayStatus(date);
                        Color textColor;
                        Color cellBg;
                        Color cellBorder;

                        if (status == 'booked') {
                          cellBg = const Color(0xFFFFF1F0);
                          cellBorder = const Color(0xFFFFA39E);
                          textColor = const Color(0xFFCF1322);
                        } else if (status == 'filling') {
                          cellBg = const Color(0xFFFFFBE6);
                          cellBorder = const Color(0xFFFFE58F);
                          textColor = const Color(0xFFD46B08);
                        } else {
                          cellBg = const Color(0xFFF6FFED);
                          cellBorder = const Color(0xFFB7EB8F);
                          textColor = const Color(0xFF389E0D);
                        }

                        if (isPast) {
                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              '$dayNum',
                              style: TextStyle(color: Colors.grey.shade300, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF7A5405) : cellBg,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected 
                                  ? null 
                                  : Border.all(color: cellBorder, width: 1.2),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: const Color(0xFF7A5405).withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]
                                  : null,
                            ),
                            child: Text(
                              '$dayNum',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : textColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _LegendItem(color: const Color(0xFF388E3C), label: 'Slots Full'),
                        _LegendItem(color: const Color(0xFFFFB300), label: '1-2 Slots'),
                        _LegendItem(color: const Color(0xFFD32F2F), label: 'Booked'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Action Buttons Selector
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF7A5405), width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: const Color(0xFF7A5405), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFF7A5405), Color(0xFFDCAE36)]),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                Navigator.pop(context, _selectedDate);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Select',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String label;
  const _WeekdayHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
