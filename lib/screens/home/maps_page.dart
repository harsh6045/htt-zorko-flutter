import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Load ZORKO shop outlets and add markers to the map
    _loadZorkoShopOutlets();
  }

  void _loadZorkoShopOutlets() async {
    // Replace this with your logic to fetch ZORKO shop outlet data
    List<ZorkoShopOutlet> outlets = [

      ZorkoShopOutlet(
        id: 1,
        name: 'ZORKO Outlet 1',
        latitude: 21.18858328993433,
        longitude:  72.77957439398674,
        dineIn: true,
        offers: ['10% off on orders above \$20'],
        coupons: ['Buy 1 Get 1 Free'],
        deliveryDetails: 'Delivery available within 5 miles',
      ),
      ZorkoShopOutlet(
        id: 2,
        name: 'ZORKO Outlet 2',
        latitude: 21.17041446690912,
        longitude: 72.83844850057767,
        dineIn: false,
        offers: ['20% off on weekends'],
        coupons: ['Free Dessert with every order'],
        deliveryDetails: 'Delivery available within 3 miles',
      ),
    ];

    setState(() {
      markers = outlets.map((outlet) {
        return Marker(
          markerId: MarkerId(outlet.id.toString()),
          position: LatLng(outlet.latitude, outlet.longitude),
          infoWindow: InfoWindow(
            title: outlet.name,
            snippet: _getOutletDetails(outlet),
          ),
        );
      }).toSet();
    });
  }

  String _getOutletDetails(ZorkoShopOutlet outlet) {
    String details = '';
    if (outlet.dineIn) {
      details += 'Dine-in available\n';
    }
    if (outlet.offers.isNotEmpty) {
      details += 'Offers:\n${outlet.offers.join('\n')}\n';
    }
    if (outlet.coupons.isNotEmpty) {
      details += 'Coupons:\n${outlet.coupons.join('\n')}\n';
    }
    if (outlet.deliveryDetails.isNotEmpty) {
      details += 'Delivery Details: ${outlet.deliveryDetails}';
    }
    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ZORKO Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(21.23874754296938, 72.86445660508576), // Set initial camera position
          zoom: 12.0,
        ),
        markers: markers,
      ),
    );
  }
}

class ZorkoShopOutlet {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final bool dineIn;
  final List<String> offers;
  final List<String> coupons;
  final String deliveryDetails;

  ZorkoShopOutlet({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.dineIn,
    required this.offers,
    required this.coupons,
    required this.deliveryDetails,
  });
}