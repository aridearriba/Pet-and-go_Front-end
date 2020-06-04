import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:petandgo/model/user.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/home.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/screens/quedadas/vistaPerreParada.dart';
import 'package:uuid/uuid.dart';
import '../../Credentials.dart';
import 'package:petandgo/global/global.dart' as Global;


class NuevaPerreParada extends StatefulWidget {
    NuevaPerreParada(this.user);
    User user;

    @override
    _NuevaPerreParadaState createState() => _NuevaPerreParadaState();
}

class _NuevaPerreParadaState extends State<NuevaPerreParada> {

    final _formKey = GlobalKey<FormState>();

    final FocusNode _focusNode = new FocusNode();
    final TextEditingController _searchQueryController = new TextEditingController();
    final _controladorDate = TextEditingController();
    final _controladorHour = TextEditingController();

    bool _isSearching = true;
    String _searchText = "";
    List<Prediction> _searchList;
    bool _onTap = false;
    int _onTapTextLength = 0;

    var _statusCode;
    var _id;
    var uuid;

    DateTime _dateTime;
    TimeOfDay _hour;

    List<Prediction> _predictions;
    Result _result;

    static double lat = 41.390205;
    static double lng = 2.154007;
    static String code = '';

    Completer<GoogleMapController> _controller = Completer();

    static final CameraPosition _camPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 10,
    );


    _NuevaPerreParadaState() {
        _searchQueryController.addListener(() {
           if (_searchQueryController.text.isEmpty){
               setState(() {
                   _isSearching = false;
                   _searchText = "";
                   _searchList = List();
               });
           }
           else {
               setState(() {
                   _isSearching = true;
                   _searchText = _searchQueryController.text;
                   _onTap = _onTapTextLength == _searchText.length;
               });
           }
        });
    }

    Future<List<Prediction>> getLocations(String input) async {
        if (input.isEmpty){
            return List();
        }
        input = input.replaceAll(" ", "+");
        String URL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$PLACES_API_KEY&sessiontoken=${uuid}&location=${widget.user.pos.latitude},${widget.user.pos.longitude}&radius5000';
        final response = await http.get(URL);

        print(response.statusCode.toString());

        if (response.statusCode == 200) {
            var data = json.decode(response.body);
            var rest = data["predictions"] as List;
            print(rest);
            return rest.map<Prediction>((json) => Prediction.fromJson(json)).toList();
        } else {
            throw Exception('An error occurred getting places : PREDICTIONS');
        }
    }

    Future<void> getPlaceInfo(String name) async {
        String URL = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$name&key=$PLACES_API_KEY&sessiontoken=$uuid';
        final response = await http.get(URL);

        print(response.statusCode.toString());

        if (response.statusCode == 200) {
            var data = json.decode(response.body);
            var rest = data["result"];
            print(data);
            _result = Result.fromJson(rest);
            lat = _result.geo.loc.lat;
            lng = _result.geo.loc.lng;
        } else {
            throw Exception('An error occurred getting places : RESULT');
        }
    }

    @override
    void initState() {
        uuid = Uuid();
        super.initState();
        _isSearching = false;
    }

    @override
    Widget build(BuildContext context) {
    return new Scaffold(
        drawer: Menu(widget.user),
        appBar: AppBar(
            title: Text(
                AppLocalizations.of(context).translate('dogstops_new_title'),
                style: TextStyle(
                    color: Colors.white,
                ),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(widget.user))
                    ),
                )
            ],
        ),
        body: buildBody(),
    );
    }

    Future<void> add() async{
        var email = widget.user.email;
        var date = new DateTime(_dateTime.year, _dateTime.month, _dateTime.day, _dateTime.hour, _dateTime.minute).toString();
        var today = DateTime.now().toString().substring(0, 10);

        http.Response response = await http.post(new Uri.http(Global.apiURL, "/api/quedadas"),
            headers: <String, String>{
                HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.user.token.toString(),
            },
            body: jsonEncode({
                'admin': email,
                'createdAt': today,
                'fechaQuedada': date,
                'lugarInicio': _searchQueryController.text,
                'latitud':  lat,
                'longitud': lng,
                'idImageGoogle': '',
            }));
        _statusCode = response.statusCode;
        _id = int.parse(response.body);
    }

    Widget getFutureWidget() {
        return new FutureBuilder(
            future: _buildSearchList(),
            initialData: List<ListTile>(),
            builder: (BuildContext context, AsyncSnapshot<List<ListTile>> childItems) {
                return new Container(
                    color: Colors.white,
                    height: getChildren(childItems).length * 48.0,
                    width: MediaQuery.of(context).size.width,
                    child: new ListView(
                        padding: new EdgeInsets.only(left: 50.0),
                        children: childItems.data.isNotEmpty
                            ? ListTile.divideTiles(context: context, tiles: getChildren(childItems)).toList() : List(),
                    ),
                );
            },
        );
    }

    List<ListTile> getChildren(AsyncSnapshot<List<ListTile>> childItems) {
        if (_onTap && _searchText.length != _onTapTextLength) _onTap = false;
        List<ListTile> childrenList =
        _isSearching && !_onTap ? childItems.data : List();
        return childrenList;
    }

    ListTile _getListTile(String suggestedPhrase, String id) {
        return new ListTile(
            dense: true,
            title: new Text(
              suggestedPhrase,
            ),
            onTap: () {
                setState(() {
                    _onTap = true;
                    _isSearching = false;
                    _onTapTextLength = suggestedPhrase.length;
                    _searchQueryController.text = suggestedPhrase;
                    setPlace(id);
                });
                _searchQueryController.selection = TextSelection.fromPosition(new TextPosition(offset: suggestedPhrase.length));
            },
        );
    }

    Future<List<ListTile>> _buildSearchList() async {
        if (_searchText.isEmpty){
            _searchList = List();
            return List();
        }
        else {
            _searchList = await getLocations(_searchText) ?? List();

            List<ListTile> childItems = new List();
            for(var value in _searchList) {
                childItems.add(_getListTile(value.description, value.id));
            }
            return childItems;
        }
    }

    Future<void> setPlace(id) async{
        await getPlaceInfo(id);
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
           CameraPosition(
               target: LatLng(lat,lng),
               zoom: 16,
           )
        ));

    }

    Widget buildBody() {
        return new SafeArea(
            top: false,
            bottom: false,
            child: new SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                    key: _formKey,
                    child: new Stack(
                        children: <Widget>[
                            Column(
                                children: <Widget>[
                                    Container(
                                        height: MediaQuery.of(context).size.height,
                                        child: new Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                                new TextFormField(
                                                    controller: _searchQueryController,
                                                    focusNode: _focusNode,
                                                    onFieldSubmitted: (String value) {
                                                        print("submitted: $value");
                                                        setState(() {
                                                            _searchQueryController.text = value;
                                                            _onTap = true;
                                                        });
                                                    },
                                                    onSaved: (String value) => print("saved: $value"),
                                                    decoration: InputDecoration(
                                                        labelText: AppLocalizations.of(context).translate('dogstops_new_address')
                                                    ),
                                                    validator: (value){
                                                        if(value.isEmpty){
                                                            return AppLocalizations.of(context).translate('dogstops_new_empty-address');
                                                        }
                                                        return null;
                                                    },
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                    child: InkWell(
                                                        onTap: () async {
                                                            _dateTime = await showDatePicker(
                                                                context: context,
                                                                initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                                                firstDate: DateTime(DateTime.now().year - 20),
                                                                lastDate: DateTime(DateTime.now().year + 1)
                                                            );
                                                            _controladorDate.text = _dateTime.day.toString().padLeft(2, '0') + ". " + _dateTime.month.toString().padLeft(2, '0') + ". " + _dateTime.year.toString();
                                                        },
                                                        child: IgnorePointer(
                                                            child: new TextFormField(
                                                                decoration: new InputDecoration(labelText: AppLocalizations.of(context).translate('dogstops_new_date')),
                                                                controller: _controladorDate,
                                                                validator: (value){
                                                                    if(value.isEmpty){
                                                                        return AppLocalizations.of(context).translate('calendar_new-event_empty-date');
                                                                    }
                                                                    return null;
                                                                },
                                                                onSaved: (String val) {},
                                                            ),
                                                        ),
                                                    ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                                    child: InkWell(
                                                        onTap: () async {
                                                            _hour = await showTimePicker(
                                                                context: context,
                                                                initialTime: TimeOfDay(hour: 12, minute: 0),
                                                            );
                                                            _controladorHour.text = _hour.hour.toString().padLeft(2, '0') + ':' + _hour.minute.toString().padLeft(2, '0');
                                                        },
                                                        child: IgnorePointer(
                                                            child: new TextFormField(
                                                                decoration: new InputDecoration(labelText: AppLocalizations.of(context).translate('dogstops_new_time')),
                                                                controller: _controladorHour,
                                                                validator: (value){
                                                                    if(value.isEmpty){
                                                                        return AppLocalizations.of(context).translate('calendar_new-event_empty-time');
                                                                    }
                                                                    return null;
                                                                },
                                                                onSaved: (String val) {},
                                                            ),
                                                        ),
                                                    ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.all(20.0),
                                                ),
                                                Center(
                                                    child: Container(
                                                        width: 350,
                                                        height: 250,
                                                        child: GoogleMap(
                                                            mapType: MapType.hybrid,
                                                            initialCameraPosition: _camPosition,
                                                            onMapCreated: (GoogleMapController controller) {
                                                                _controller.complete(controller);
                                                            },
                                                        ),
                                                    ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 90.0),
                                                    child: RaisedButton(
                                                        onPressed: () {
                                                            FocusScope.of(context).requestFocus(FocusNode());
                                                            add().whenComplete(
                                                                    () {// comprueba que los campos sean correctos
                                                                    if (_formKey.currentState.validate()) {
                                                                        _formKey.currentState.save();
                                                                        // Si el formulario es válido, queremos mostrar un Snackbar
                                                                        if(_statusCode == 201) {
                                                                            Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => VistaPerreParada(widget.user, _id))
                                                                            );
                                                                        }
                                                                    }
                                                                });
                                                        },
                                                        child: Text(AppLocalizations.of(context).translate('calendar_new-event_add')),
                                                    )
                                                ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                            new Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.only(top: 60.0),
                                child: _isSearching && (!_onTap) ? getFutureWidget() : null
                            ),
                        ],
                    ),
                )
            ),
        );
    }
}

//GOOGLE MAPS RESPONSE CLASSES

class Prediction {
    String _description;
    String _id;

    Prediction({String desc, String id})
    {
        this._description = desc;
        this._id = id;
    }

    String get description => _description;
    String get id => this._id;

    factory Prediction.fromJson(Map<String, dynamic> json){
        return Prediction(
            desc:  json['description'],
            id: json['place_id']
        );
    }
}

class Result {
    Geometry _geo;
    String _name;

    Result({Geometry geo, String name})
    {
        this._geo = geo;
        this._name = name;
    }

    Geometry get geo => _geo;
    String get name => _name;

    factory Result.fromJson(Map<String, dynamic> json){
        return Result(
            geo: Geometry.fromJson(json['geometry']),
            name: json['formatted_address'],
        );
    }
}

class Geometry {

    Location _loc;

    Geometry({Location loc})
    {
        this._loc = loc;
    }

    Location get loc => _loc;

    factory Geometry.fromJson(Map<String, dynamic> json){
        return Geometry(
            loc: Location.fromJson(json ['location'])
        );
    }
}

class Location {

    double _lat, _lng;

    Location({double lat, double lng})
    {
        this._lat = lat;
        this._lng = lng;
    }

    double get lat => _lat;
    double get lng => _lng;


    factory Location.fromJson(Map<String, dynamic> json){
        return Location(
            lat: json['lat'],
            lng: json['lng']
        );
    }
}

class Photo {
    double _height, _width;
    String _ref;

    Photo({double h, double w, String ref})
    {
        this._height = h;
        this._width = w;
        this._ref = ref;
    }

    double get height => _height;
    double get width => _width;
    String get ref => _ref;


    factory Photo.fromJson(Map<String, dynamic> json){
        return Photo(
            h: json['height'],
            w: json['width'],
            ref: json['photo_reference']
        );
    }
}
