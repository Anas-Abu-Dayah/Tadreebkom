import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tadreebkomapplication/controller/auth/centerlocationcontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/functions/validateinput.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/customtextformauth.dart';

class CenterLocation extends StatelessWidget {
  const CenterLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final CenterLocationControllerImp controller = Get.put(
      CenterLocationControllerImp(),
    );

    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
        elevation: 0.0,
      ),
      body: Form(
        key: controller.formstate,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(height: 70),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Choose your location",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Please put your location on the map",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 50),

              // Google Map
              SizedBox(
                height: 300,
                width: double.infinity,
                child: GetBuilder<CenterLocationControllerImp>(
                  builder: (controller) {
                    if (controller.cameraPosition == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return GoogleMap(
                      zoomGesturesEnabled: true,
                      initialCameraPosition: controller.cameraPosition!,
                      mapType: MapType.normal,
                      onMapCreated: controller.onMapCreated,
                      markers: controller.markers,
                      scrollGesturesEnabled: true,
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                      onTap: controller.onMapTap,
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),

              Obx(
                () => CustomTextFormAuth(
                  hinttext: 'Street',
                  labeltext: 'Street',
                  mycontroller: TextEditingController(
                    text: controller.street.value,
                  ),
                  icondata: Icons.location_on,
                  valid: (val) {
                    return validateInput(val!, 0, 1000, "Location");
                  },
                  isNumber: false,
                ),
              ),
              Obx(
                () => CustomTextFormAuth(
                  hinttext: 'City',
                  labeltext: 'City',
                  mycontroller: TextEditingController(
                    text: controller.city.value,
                  ),
                  icondata: Icons.location_city,
                  valid: (val) {
                    return validateInput(val!, 0, 1000, "Location");
                  },
                  isNumber: false,
                ),
              ),
              Obx(
                () => CustomTextFormAuth(
                  hinttext: 'State',
                  labeltext: 'State',
                  mycontroller: TextEditingController(
                    text: controller.state.value,
                  ),
                  icondata: Icons.place,
                  valid: (val) {
                    return validateInput(val!, 0, 1000, "Location");
                  },
                  isNumber: false,
                ),
              ),
              Obx(
                () => CustomTextFormAuth(
                  hinttext: 'Country',
                  labeltext: 'Country',
                  mycontroller: TextEditingController(
                    text: controller.country.value,
                  ),
                  icondata: Icons.flag,
                  valid: (val) {
                    return validateInput(val!, 0, 1000, "Location");
                  },
                  isNumber: false,
                ),
              ),

              const SizedBox(height: 15),

              CustomButtonAuth(
                text: "Confirm Address Location",
                onPressed: () {
                  controller.confirmAddressLocation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
