import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/PuntosInteres.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/puntosDeInteres/puntoInteres/visorImagenesWidget.dart';
import '../../../Credentials.dart';

import 'MapaPuntoInteresView.dart';


class PuntoInteresView extends StatefulWidget {
    User user;
    PuntoInteres puntoInteres;
    LatLng position;
    PuntosInteres pts;

    PuntoInteresView(User User, PuntoInteres puntoInteres,LatLng position) {
        this.user = User;
        this.puntoInteres = puntoInteres;
        this.position = position;
        this.pts = new PuntosInteres.vacio();
        pts.results = new List<PuntoInteres>();
        pts.results.add(puntoInteres);
    }

    @override
    PuntoInteresState createState() => PuntoInteresState();
}

class PuntoInteresState extends State<PuntoInteresView> {

    nMaps() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MapaPuntoInteresView(widget.user,widget.pts,widget.position)));
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(AppLocalizations.of(context).translate('points-of-interest_one_title'), style: TextStyle(color: Colors.white,),),
                iconTheme: IconThemeData(color: Colors.white,),
                actions: <Widget>[
                    IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                )
            ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: <Widget>[
                        buildSliderImage(context),
                        Text(""),
                        Text(
                            widget.puntoInteres.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                        Text(""),
                        Text(
                            widget.puntoInteres.formattedAddress,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                            ),
                        ),
                        Text(""),
                        if(widget.puntoInteres.openingHours.openNow)
                            Text(
                                AppLocalizations.of(context).translate('points-of-interest_one_opened'),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                ),
                            )
                        else
                            Text(
                                AppLocalizations.of(context).translate('points-of-interest_one_closed'),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                        Text(""),
                        Center(
                            child: MaterialButton(
                                color: Colors.lightGreen,
                                onPressed: () => nMaps(),
                                child: Text(
                                    AppLocalizations.of(context).translate('points-of-interest_one_see-map'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                    ),
                                ),
                            ),
                        ),
                    ]
                ),
            ),
        );
    }

    Widget buildSliderImage(BuildContext context) {
        return FutureBuilder(
            future: getImage(),
            builder: (BuildContext context, AsyncSnapshot<List<ImageProvider>> snapshot) {
                if (! snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(),
                    );
                } else {
                    return Container(
                        child: VisorImagenesWidget(widget.user,widget.puntoInteres,snapshot.data),
                    );
                }
            },
        );
    }

    Future<List<ImageProvider>> getImage() async{

        List<ImageProvider> result = new List<ImageProvider>();
        String ref;
        String urlImage;
        ImageProvider i;

        try{

            widget.puntoInteres.photos.forEach((element) {
                try {
                    ref = element.photoReference;
                    urlImage = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" + ref + "&key=" + PLACES_API_KEY;
                    i = Image.network(urlImage).image;
                    result.add(i);
                }catch(e){}
            });
            if(result.length == 0 ) result.add(AssetImage("assets/images/noImage.jpg"));
        }catch(e) {
            result.add(AssetImage("assets/images/noImage.jpg"));
            return result;
        }
        return result;
    }

}

