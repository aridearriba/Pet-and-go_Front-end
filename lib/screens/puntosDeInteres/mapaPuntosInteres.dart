import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/model/user.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPuntosInteresWidget extends StatefulWidget {

    LatLng origen;
    PuntosInteres puntosInteres;
    User user;

    double minleft;
    double maxright;
    double minbottom;
    double maxtop;


    MapaPuntosInteresWidget(User user,PuntosInteres puntosInteres,LatLng origen){
        this.user = user;
        this.puntosInteres = puntosInteres;
        this.origen = origen;
        minleft = origen.latitude;
        maxright = origen.latitude;
        minbottom = origen.longitude;
        maxtop = origen.longitude;
    }

    @override
    _MapaPuntosInteresWidgetState createState() => _MapaPuntosInteresWidgetState();
}

class _MapaPuntosInteresWidgetState extends State<MapaPuntosInteresWidget> {
    GoogleMapController _mapController;

    @override
    Widget build(BuildContext context) {
        return GoogleMap(
            initialCameraPosition: CameraPosition(
                target: widget.origen,
                zoom: 10,
            ),
            markers: _createMarkers(),
            onMapCreated: _onMapCreated,
        );
    }

    Set<Marker> _createMarkers() {
        var tmp = Set<Marker>();
        LatLng position;

        widget.puntosInteres.results.forEach((element) {
            position = new LatLng(element.geometry.location.lat,element.geometry.location.lng);
            tmp.add(
                Marker(
                    markerId: MarkerId(element.formattedAddress),
                    position: position,
                    infoWindow: InfoWindow(title: element.name),
                ),
            );
            widget.minleft = min(element.geometry.location.lat, widget.minleft);
            widget.maxright = max(element.geometry.location.lat,widget.maxright);
            widget.minbottom = min(element.geometry.location.lng, widget.minbottom);
            widget.maxtop = max(element.geometry.location.lng, widget.maxtop);
        });

        return tmp;

    }

    void _onMapCreated(GoogleMapController controller) {
        _mapController = controller;

        _centerView();
    }

    _centerView() async {

        await _mapController.getVisibleRegion();

        var left =  widget.minleft;
        var right = widget.maxright;
        var top =  widget.maxtop;
        var bottom =  widget.minbottom;

        var bounds = LatLngBounds(
            southwest: LatLng(left, bottom),
            northeast: LatLng(right, top),
        );

        var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
        _mapController.animateCamera(cameraUpdate);

    }
}


