import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MedicalImagingPopup extends StatefulWidget {
  MedicalImagingPopup({super.key, required this.image});
  String image;
  @override
  _MedicalImagingPopupState createState() => _MedicalImagingPopupState();
}

class _MedicalImagingPopupState extends State<MedicalImagingPopup> {
  double _zoomLevel = 1.0;
  final GlobalKey<ExtendedImageGestureState> _gestureKey = GlobalKey();
  late AnimationController _zoomController;
  void _handleZoomUpdate() {
    final state = _gestureKey.currentState;
    if (state != null && state.gestureDetails != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _zoomLevel = state.gestureDetails!.totalScale!;
            print(_zoomLevel);
          });
        }
      });
    }
  }

  void _zoomIn() {
    print('sdfsadfasd');
    // Add a small delay to ensure the widget is fully initialized
    Future.delayed(Duration(seconds: 1), () {
      final state = _gestureKey.currentState;
      print(state);
      if (state != null && state.gestureDetails != null) {
        print('zoom');
        final newScale = (_zoomLevel + 0.5).clamp(1.0, 5.0);
        state.handleDoubleTap(scale: newScale);
        if (mounted) {
          setState(() => _zoomLevel = newScale);
        }
      } else {
        // Fallback if state isn't available
        if (mounted) {
          setState(() => _zoomLevel = (_zoomLevel + 0.5).clamp(1.0, 5.0));
        }
      }
    });
  }

  void _zoomOut() {
    final state = _gestureKey.currentState;
    if (state != null) {
      final newScale = (_zoomLevel - 0.5).clamp(1.0, 5.0);
      state.handleDoubleTap(scale: newScale);
      setState(() => _zoomLevel = newScale);
    }
  }

  void _resetZoom() {
    final state = _gestureKey.currentState;
    if (state != null) {
      state.reset();
      setState(() => _zoomLevel = 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(child: _buildPopup()),
    );
  }

  Widget _buildPopup() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [_buildHeader(), Expanded(child: _buildImagingResult())],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 103, 103, 103),

        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Imaging Results',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Radiology Report',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(child: const Icon(Icons.person)),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sarah Johnson', style: TextStyle(color: Colors.white)),
              Text(
                'Exam Date: March 15, 2024',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Age 34',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              SizedBox(width: 8),
              Text(
                'ID 34344',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildImagingResult() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          ExtendedImage.asset(
          widget.image
          ,
            key: _gestureKey,
            mode: ExtendedImageMode.gesture,
            fit: BoxFit.contain,
            initGestureConfigHandler:
                (state) => GestureConfig(
                  minScale: 1.0,
                  maxScale: 5.0,
                  animationMinScale: 0.8,
                  animationMaxScale: 6.0,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: false,
                  initialAlignment: InitialAlignment.center,
                  reverseMousePointerScrollDirection: false,
                ),
            onDoubleTap: (state) {
              final newScale = _zoomLevel != 1.0 ? 1.0 : 3.0;
              state.handleDoubleTap(scale: newScale);
              setState(() => _zoomLevel = newScale);
            },
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.completed) {
                return Listener(
                  onPointerMove: (_) => _handleZoomUpdate(),
                  onPointerUp: (_) => _handleZoomUpdate(),
                  child: state.completedWidget,
                );
              }
              return null;
            },
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,
                  heroTag: 'zoomIn',
                  onPressed: _zoomIn,
                  child: const Icon(Icons.zoom_in),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  mini: true,
                  heroTag: 'zoomOut',
                  onPressed: _zoomOut,
                  child: const Icon(Icons.zoom_out),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  mini: true,
                  heroTag: 'reset',
                  onPressed: _resetZoom,
                  child: const Icon(Icons.refresh),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: AnimatedOpacity(
              opacity: _zoomLevel != 1.0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Zoom: ${_zoomLevel.toStringAsFixed(2)}x",
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
