import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zorko/components/chart.dart';
import 'package:zorko/provider/currentLocationProvider.dart';
import 'package:zorko/provider/userPlaceProvider.dart';
import 'package:zorko/screens/components/location_picker.dart';
import 'package:zorko/screens/home/filter_page.dart';
import 'package:zorko/screens/home/home_content.dart';
import 'package:zorko/screens/home/profile.dart';
import 'package:zorko/utils/app_styles.dart';
import 'package:zorko/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/map.dart';
import '../home/community_page.dart';

double lat = 0;
double lng = 0;
Future<void> _getCurrentLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();

  lat = locationData.latitude!;
  lng = locationData.longitude!;
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  List<ScreenHiddenDrawer> pages = [];

  String? country;
  String? state;
  String? city;
  @override
  void initState() {
    super.initState();

    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Home',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Community',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        CommunityPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Maps',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        MapScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Filter Option',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        FilterPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Profile',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        ProfilePage(),
      ),
      /*ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Coupons',
            baseStyle: kRalewayMedium,
            colorLineSelected: kBlue,
            selectedStyle: kRalewayMedium),
        CouponPage(),
      ),*/
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Social Links',
          baseStyle: kRalewayMedium,
          colorLineSelected: kBlue,
          selectedStyle: kRalewayMedium,
        ),
        SocialLinksPage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    country = ref.watch(userPlace).country;
    city = ref.watch(userPlace).city;
    state = ref.watch(userPlace).state;
    _getCurrentLocation().then((value) {
      ref.read(currentLocation).latitude = lat;
      ref.read(currentLocation).longitude = lng;
    });
    SizeConfig().init(context);
    return HiddenDrawerMenu(
      screens: pages,
      backgroundColorMenu: kBlue.withOpacity(0.2),
      initPositionSelected: 0,
      backgroundColorAppBar: kBlue,
      disableAppBarDefault: false,
      tittleAppBar: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Zorko"),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        (country != null && city != null && state != null)
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LocationPicker(
                                        onSelectLocation: () {
                                          setState(() {});
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          state!,
                                          style: kRalewayRegular.copyWith(
                                              color: kGrey,
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal! *
                                                  2),
                                        ),
                                        Text(city!)
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(Icons.location_on)
                                  ],
                                ),
                              )
                            : IconButton(
                                icon: const Icon(Icons.location_on),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LocationPicker(
                                        onSelectLocation: () {
                                          setState(() {});
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      slidePercent: 50,
    );
  }
}

class SocialLinksPage extends StatelessWidget {
  final List<String> socialLinks = [
    'https://zorko.in/',
    'https://www.youtube.com/@ZORKOBRAND',
    'https://www.facebook.com/ZorkoBrand',
    'https://www.instagram.com/zorkobrand/?hl=en',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Center(
                  child: Text(
                    "Zorko",
                    style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: Text(
                    "Brand of food lovers...!",
                    style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/zorko.jpg"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ZORKO Pvt Ltd. is a DIPP recognised Startup by Government of India as a young manufacturing company with a zeal to make a difference in society and environmental sustainability and public health improvement by advocating for reduced meat consumption and supporting animal welfare. We have Extended our work in Food Manufacturing, Horeca Supply, Processing, Health Supplements and upcoming Tech based Services. We are driven by a deep philosophy of Ethics & Trust, backed by experienced people in diverse sectors and advised by a committed team of professionals. Our company’s vision is to popularize the vegetarian menu globally, aiming to add 1000+ new vegetarian restaurants in the next 1000 days."
                , style: TextStyle(
                    fontSize: 18
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("        Connect with us for \n         partnership at \n      +91 7383912525 \n                 OR \n      +91 9081782145",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),)
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.globe, size: 30),
                      iconSize: 20,
                      onPressed: () => _launchUrl(socialLinks[0]),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.youtube, size: 30),
                      iconSize: 20,
                      onPressed: () => _launchUrl(socialLinks[1]),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.facebook, size: 30),
                      iconSize: 20,
                      onPressed: () => _launchUrl(socialLinks[2]),
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.instagram, size: 30),
                      iconSize: 20,
                      onPressed: () => _launchUrl(socialLinks[3]),
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

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      try {
        await launch(
          url,
          forceSafariVC: false, // iOS
          forceWebView: false, // Android
        );
      } catch (e) {
        // Handle the exception, e.g., show a message to the user
        print('Could not launch $url: $e');
      }
    } else {
      // URL is not launchable
      print('Could not launch $url');
    }
  }

}
