import 'dart:convert';

import 'package:petandgo/global/global.dart' as Global;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/model/avatar.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';

import 'package:http/http.dart' as http;
import 'package:petandgo/screens/user/profile.dart';


class Awards extends StatefulWidget {
    Awards(this.user);
    User user;

    @override
    _AwardsState createState() => _AwardsState();
}

class _AwardsState extends State<Awards>
{
    List<Avatar> _avatars;
    final rows = <TableRow>[];


    nProfile() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(widget.user))
        );
    }

    Widget build(BuildContext context) {
        return FutureBuilder<List<Avatar>>(
            future: getAvatars(),
            builder: (BuildContext context, AsyncSnapshot<List<Avatar>> snapshot) {
            return Scaffold(
                drawer: Menu(widget.user),
                appBar: AppBar(
                    title: Text(
                        'Premios',
                        style: TextStyle(
                            color: Colors.white,
                        ),

                    ),
                    iconTheme: IconThemeData(
                        color: Colors.white,
                    ),
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                            ),
                            onPressed: () => nProfile(),
                        ),
                    ],
                ),
                body: snapshot.hasData ? _showAvatars() : _loadingAvatars()
            );
        });
    }

    Widget _loadingAvatars(){
        return Center(
            child: Column(
                children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(20),
                    ),
                    SizedBox(
                        width: 30.0,
                        height: 30.0,

                        child: CircularProgressIndicator(backgroundColor: Colors.green, valueColor: AlwaysStoppedAnimation(Colors.lightGreen)),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(30),
                        child: Text('Cargando avatares...'),
                    )
                ],
            ),
        );
    }

    Widget _showAvatars(){
        return ListView(
            children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 30.0, right: 30.0),
                    child: Column(
                        children: <Widget>[
                            CircleAvatar(
                                backgroundImage:
                                    widget.user.avatar == null ?
                                    Image.network(_avatars.first.image).image :
                                    Image.network(widget.user.avatar).image,
                                radius: 110,
                                backgroundColor: Colors.transparent,
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    // USER
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                                        child: Text(
                                            "AVATAR",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                            ),
                                            textAlign: TextAlign.left,
                                        )
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0),
                                        child: Table(children: rows),
                                    ),
                                ],
                            ),
                        ],
                    )
                ),
            ]
        );
    }

    Widget _showAvatar(bool blocked, String link){
        return CircleAvatar(
            minRadius: 10,
            maxRadius: 40,
            backgroundColor: Colors.transparent,
            child: Stack(
                children: <Widget>[
                    ClipOval(
                        child: Image.network(link),
                    ),
                    blocked ? Positioned(
                        top: 0,
                        left: 60,
                        child: Container(
                            width: 20,
                            height: 20,
                            child:
                            ClipOval(
                                child: Icon(Icons.lock, color: Colors.black, size: 15),
                            )
                        )
                    ) : Positioned(
                            top: 0,
                            left: 60,
                            child: Container(
                                width: 20,
                                height: 20,)
                    ),
                ]
            ),
        );
    }

    Future<List<Avatar>> getAvatars() async{
        var email = widget.user.email;
        final response = await http.get(new Uri.http(Global.apiURL, "/api/avatares/"));
        Iterable list = json.decode(response.body);
        _avatars = list.map((model) =>  Avatar.fromJson(model)).toList();

        _avatars.sort((a,b) => a.level.compareTo(b.level));

        rows.clear();
        int count = 3;
        Avatar avatar1, avatar2, avatar3;
        for (var avatar in _avatars) {
            if (count == 1) {
                avatar3 = avatar;
                count = 4;
                _createRow(avatar1, avatar2, avatar3);
            }
            if (count == 2) avatar2 = avatar;
            if (count == 3) avatar1 = avatar;

            count--;
        }

        if (count == 1) {
            avatar3 = new Avatar();
            avatar3.image = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ursulamascaro.es%2Fblank-product.html&psig=AOvVaw0Z-SGnU2Ui9HWuXEJHzRkI&ust=1590695673220000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCIjY_Kbp1OkCFQAAAAAdAAAAABAS";
            _createRow(avatar1, avatar2, avatar3);
        }

        if (count == 2) {
            avatar3 = new Avatar();
            avatar3.image = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ursulamascaro.es%2Fblank-product.html&psig=AOvVaw0Z-SGnU2Ui9HWuXEJHzRkI&ust=1590695673220000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCIjY_Kbp1OkCFQAAAAAdAAAAABAS";
            avatar2 = new Avatar();
            avatar2.image = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ursulamascaro.es%2Fblank-product.html&psig=AOvVaw0Z-SGnU2Ui9HWuXEJHzRkI&ust=1590695673220000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCIjY_Kbp1OkCFQAAAAAdAAAAABAS";
            _createRow(avatar1, avatar2, avatar3);
        }

        return _avatars;
    }

    TableRow _createRow(Avatar avatar1, Avatar avatar2, Avatar avatar3) {
        rows.add(TableRow(children: [
            _showAvatar(widget.user.level <= avatar1.level ? true : false, avatar1.image),
            _showAvatar(widget.user.level <= avatar2.level ? true : false, avatar2.image),
            _showAvatar(widget.user.level <= avatar3.level ? true : false, avatar3.image)
        ]));
    }
}