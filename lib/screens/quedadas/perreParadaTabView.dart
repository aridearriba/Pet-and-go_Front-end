import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petandgo/multilanguage/appLocalizations.dart';
import 'package:petandgo/screens/quedadas/listadoPerreParadasView.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'package:petandgo/model/user.dart';

class QuedadasTabView extends StatefulWidget {
    QuedadasTabView(this.user);
    User user;

    @override
    QuedadasTabState createState() => QuedadasTabState();
}

class QuedadasTabState extends State<QuedadasTabView>{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(AppLocalizations.of(context).translate('meetings_my-meetings_title'), style: TextStyle(color: Colors.white,),),
                iconTheme: IconThemeData(color: Colors.white,),
            ),
            body: Column(
                children: <Widget>[
                    Expanded(
                        child: Column(
                            children: <Widget>[
                                DefaultTabController(
                                    length: 2,
                                    child: Expanded(
                                        child: Column(
                                            children: <Widget>[
                                                TabBar(
                                                    unselectedLabelColor: Colors.grey,
                                                    indicatorColor: Colors.green,
                                                    tabs: [
                                                        Tab(text: AppLocalizations.of(context).translate('meetings_my-meetings_title')),
                                                        Tab(text: AppLocalizations.of(context).translate('meetings_my-dogstops_title')),
                                                    ],
                                                ),
                                                Expanded(
                                                    child: TabBarView(
                                                        children: [
                                                            ListaPerreParadasWidget(widget.user,"participante", '0'),
                                                            ListaPerreParadasWidget(widget.user,"admin", '0'),
                                                        ],
                                                    ),
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                ]
            ),
        );
    }
}