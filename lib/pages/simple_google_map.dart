import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_map_flutter/pages/simple_google_map_binding.dart' ;
import 'package:google_map_flutter/res/google_map_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class SimpleGoogleMap extends GetView<SimpleGoogleMapController> {
  const SimpleGoogleMap({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map Flutter"),
        titleTextStyle: Theme.of(context).textTheme.headline5,
        centerTitle: true,
        actions: [
          popupMenuButton(context, controller)
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: FloatingActionButton(
          child: const Icon(Icons.my_location_outlined),
          onPressed: (){
            controller.fixCameraPosition();
          },
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            GoogleMap(
              myLocationEnabled: false,
              tiltGesturesEnabled: false,
              compassEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: false,
              markers: controller.markers.value,
              polylines: controller.polyLines.value,
              mapType: MapType.normal,
              initialCameraPosition: controller.initialCameraPosition.value,
              onMapCreated: (GoogleMapController newController) {
                controller.mapController.value.complete(newController);
              },
            ),
            Positioned(
                bottom: 10,
                right: 100,
                left: 100,
                child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: Text("X: ${controller.currentLocation.value.latitude} \nY: ${controller.currentLocation.value.longitude}",
                      textAlign: TextAlign.justify,
                      overflow: TextOverflow.visible,)
                )
            )
          ],
        );
      } ,
      ),
    );
  }

  PopupMenuButton<int> popupMenuButton(BuildContext context, SimpleGoogleMapController controller) => PopupMenuButton<int>(
    icon: const Icon(Icons.filter_alt_outlined,
        color: Colors.black),
    tooltip: "Filter",
    itemBuilder: (context) => [
      // popupmenu item 1
      PopupMenuItem(
        value: 1,
        // row has two child icon and text.
        child: Row(children: const [
          Icon(Icons.filter_3,
              color: Colors.black),
          SizedBox(width: 10,),
          Text("Filter 3 km")
        ],),
      ),
      // popupmenu item 2
      PopupMenuItem(
        value: 2,
        // row has two child icon and text
        child: Row(children: const [
          Icon(Icons.filter_5,
              color: Colors.black),
          SizedBox(width: 10,),
          Text("Filter 5 km")
        ],),
      ),
      PopupMenuItem(
        value: 3,
        // row has two child icon and text
        child: Row(children: const [
          Icon(Icons.filter_alt_off_outlined,
            color: Colors.black,
          ),
          SizedBox(width: 10,),
          Text("Don't Filter")
        ],),
      ),
    ],
    offset: Offset(5, 55),
    // color: Colors.white,
    elevation: 2,
    onSelected: (value){
      if(value == 1){
        controller.showDataNearby(distance: Distance.km3);
      }
      if(value == 2){
        controller.showDataNearby(distance: Distance.km5);
      }
      if(value == 3){
        controller.showDataNearby();
      }
    },
  );
}

