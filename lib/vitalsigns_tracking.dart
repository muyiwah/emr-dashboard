import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class VitalSignsHomePage extends StatefulWidget {
  @override
  _VitalSignsHomePageState createState() => _VitalSignsHomePageState();
}

class _VitalSignsHomePageState extends State<VitalSignsHomePage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _respiratoryController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _oxygenController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  bool _showNewEntry = false;

  @override
  void initState() {
    super.initState();
    _systolicController.text = '120';
    _diastolicController.text = '80';
    _heartRateController.text = '72';
    _respiratoryController.text = '16';
    _temperatureController.text = '98.6';
    _oxygenController.text = '98';
    _weightController.text = '165';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header with title and add button
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 60, 24, 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vital Signs Tracking',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF16A085),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _showNewEntry = !_showNewEntry;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Add Entry',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLatestReadings(),
                  SizedBox(height: 32),
                  _buildTrendsSection(),
                  if (_showNewEntry) ...[
                    SizedBox(height: 32),
                    _buildNewEntrySection(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestReadings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Readings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: 16),
        // First row
        Row(
          children: [
            Expanded(
              child: _buildVitalCard(
                icon: Icons.favorite,
                color: Color(0xFFE74C3C),
                title: 'Blood Pressure',
                value: '120/80',
                unit: 'mmHg',
                backgroundColor: Color(0xFFFDF2F2),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildVitalCard(
                icon: Icons.favorite,
                color: Color(0xFF3498DB),
                title: 'Heart Rate',
                value: '72',
                unit: 'bpm',
                backgroundColor: Color(0xFFF0F8FF),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildVitalCard(
                icon: Icons.air,
                color: Color(0xFF27AE60),
                title: 'Respiratory',
                value: '16',
                unit: 'rpm',
                backgroundColor: Color(0xFFF0FFF4),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        // Second row
        Row(
          children: [
            Expanded(
              child: _buildVitalCard(
                icon: Icons.thermostat,
                color: Color(0xFFF39C12),
                title: 'Temperature',
                value: '98.6°F',
                unit: '36.7°C',
                backgroundColor: Color(0xFFFEF9E7),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildVitalCard(
                icon: Icons.water_drop,
                color: Color(0xFF17A2B8),
                title: 'Oxygen Sat',
                value: '98%',
                unit: 'SpO2',
                backgroundColor: Color(0xFFE8F8F8),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildVitalCard(
                icon: Icons.monitor_weight,
                color: Color(0xFF8E44AD),
                title: 'Weight',
                value: '165 lbs',
                unit: '75 kg',
                backgroundColor: Color(0xFFF8F4FF),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'Last updated: Today, 2:30 PM',
          style: TextStyle(fontSize: 12, color: Color(0xFF6C757D)),
        ),
      ],
    );
  }

  Widget _buildVitalCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String unit,
    required Color backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6C757D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 2),
          Text(unit, style: TextStyle(fontSize: 11, color: Color(0xFF6C757D))),
        ],
      ),
    );
  }

  Widget _buildTrendsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF16A085),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Line',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFFE9ECEF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Bar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6C757D),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      const days = [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun',
                      ];
                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                        return Text(
                          days[value.toInt()],
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6C757D),
                          ),
                        );
                      }
                      return Text('');
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 72),
                    FlSpot(1, 75),
                    FlSpot(2, 70),
                    FlSpot(3, 78),
                    FlSpot(4, 74),
                    FlSpot(5, 72),
                    FlSpot(6, 76),
                  ],
                  isCurved: true,
                  color: Color(0xFF16A085),
                  barWidth: 2,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Color(0xFF16A085).withOpacity(0.1),
                  ),
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: Color(0xFF16A085),
                        strokeWidth: 0,
                      );
                    },
                  ),
                ),
              ],
              minY: 68,
              maxY: 80,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewEntrySection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Entry',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Date & Time',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _dateController,
            decoration: InputDecoration(
              hintText: 'mm/dd/yyyy, --:-- --',
              hintStyle: TextStyle(color: Color(0xFF6C757D)),
              suffixIcon: Icon(
                Icons.calendar_today,
                size: 20,
                color: Color(0xFF6C757D),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFDEE2E6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFDEE2E6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF16A085)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildInputField(
                      icon: Icons.favorite,
                      color: Color(0xFFE74C3C),
                      title: 'Blood Pressure',
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _systolicController,
                              decoration: _inputDecoration('Systolic'),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '/',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C757D),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _diastolicController,
                              decoration: _inputDecoration('Diastolic'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInputField(
                      icon: Icons.air,
                      color: Color(0xFF27AE60),
                      title: 'Respiratory Rate (rpm)',
                      child: TextFormField(
                        controller: _respiratoryController,
                        decoration: _inputDecoration('16'),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInputField(
                      icon: Icons.water_drop,
                      color: Color(0xFF17A2B8),
                      title: 'Oxygen Saturation (%)',
                      child: TextFormField(
                        controller: _oxygenController,
                        decoration: _inputDecoration('98'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildInputField(
                      icon: Icons.favorite,
                      color: Color(0xFF3498DB),
                      title: 'Heart Rate (bpm)',
                      child: TextFormField(
                        controller: _heartRateController,
                        decoration: _inputDecoration('72'),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInputField(
                      icon: Icons.thermostat,
                      color: Color(0xFFF39C12),
                      title: 'Temperature (°F)',
                      child: TextFormField(
                        controller: _temperatureController,
                        decoration: _inputDecoration('98.6'),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInputField(
                      icon: Icons.monitor_weight,
                      color: Color(0xFF8E44AD),
                      title: 'Weight (lbs)',
                      child: TextFormField(
                        controller: _weightController,
                        decoration: _inputDecoration('165'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showNewEntry = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Entry saved successfully!'),
                        backgroundColor: Color(0xFF16A085),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF16A085),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Save Entry',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showNewEntry = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFF6C757D),
                  side: BorderSide(color: Color(0xFFDEE2E6)),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required Color color,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Color(0xFF6C757D)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFDEE2E6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFDEE2E6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF16A085)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    _respiratoryController.dispose();
    _temperatureController.dispose();
    _oxygenController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
