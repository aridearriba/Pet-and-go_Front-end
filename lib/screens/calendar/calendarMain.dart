import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:petandgo/model/user.dart';
import 'package:petandgo/screens/calendar/calendarList.dart';
import 'package:petandgo/screens/menu/menu.dart';
import 'mmaObjects.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CalendarMain extends StatefulWidget {
    CalendarMain(this.user);
    User user;

    @override
    _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<CalendarMain> {
    String statusString = ''; //Status string displayed to user

    //Booleans to track which mmaEvents to Query
    bool queryUFC = true;
    bool queryBellator = true;
    bool queryOneFC = true;

    //Calendar Variables
    bool deleted = false;
    bool calendarSelected = false;
    String calendarButtonText = 'Select Calendar to Add Events';
    String _currentCalendarID = '';
    DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();


    bool _setCalendarCallback(
        String calendarID, String calendarName, DeviceCalendarPlugin deviceCal) {
        //Calendar Callback Function used by Calendar Page
        //Calendar Page will call the callback to provide calendar info needed
        //to load mma events into calendar
        setState(() {
            _currentCalendarID = calendarID;
            calendarButtonText = calendarName;
            _deviceCalendarPlugin = deviceCal;
            calendarSelected = false;
        });
    }

    Widget calendarButtonOrCalendar() {
        //Returns a calendar button that displays 'Select Calendar' or Returns a
        // Calendar Page if the button was pressed
        if (!calendarSelected) {
            return new FlatButton.icon(
                icon: Icon(
                    Icons.calendar_today,
                    color: Colors.amber[600],
                ),
                label: Text(calendarButtonText,
                    style: Theme.of(context).textTheme.body1),
                onPressed: () {
                    setState(() {
                        calendarSelected = true;
                    });
                });
        } else {
            return new Calendario(this._setCalendarCallback);
        }
    }

    Widget loadFightsButton() {
        // Returns a null button if the Calendar was not selected, otherwise it returns
        // a button that is not null and can be used to query fights from the web
        // and add them to the user's selected calendar
        if (_currentCalendarID != '') {
            return new FlatButton.icon(
                onPressed: (){_queryMMAWebsite(false);},
                icon: Icon(
                    Icons.cached,
                    color: Colors.amber[600],
                ),
                label: Text('Load Fights and Add to Calendar',
                    style: Theme.of(context).textTheme.body1));
        } else {
            return new FlatButton.icon(
                onPressed: null,
                icon: Icon(
                    Icons.cached,
                    color: const Color(0xff979799),
                ),
                label: Text('Load Fights and Add to Calendar',
                    style: Theme.of(context).textTheme.subhead));
        }
    }

    Widget deleteFightsButton() {
        // Returns a null button if the Calendar was not selected, otherwise it returns
        // a button that is not null and can be used to query fights from the web
        // and delete them from the user's selected calendar
        if (_currentCalendarID != '') {
            return new FlatButton.icon(
                onPressed: (){_queryMMAWebsite(true);},
                icon: Icon(
                    Icons.delete,
                    color: Colors.amber[600],
                ),
                label: Text('Delete Fights From Calendar',
                    style: Theme.of(context).textTheme.body1));
        } else {
            return new FlatButton.icon(
                onPressed: null,
                icon: Icon(
                    Icons.delete,
                    color: const Color(0xff979799),
                ),
                label: Text('Delete Fights From Calendar',
                    style: Theme.of(context).textTheme.subhead));
        }
    }

    Text statusMessageHeader(){
        if(statusString != ''){
            if(deleted){
                return new Text('Events Deleted in Calendar:\n', style: Theme.of(context).textTheme.body2 );
            } else {
                return new Text('Events Added/Updated in Calendar:\n', style: Theme.of(context).textTheme.body2 );
            }
        } else {
            return new Text('');
        }
    }

    void setDeviceCalendarCallback(DeviceCalendarPlugin deviceCalendar) {
        setState(() {
            _deviceCalendarPlugin = deviceCalendar;
        });
    }

    void _toggleQueryUFC(bool) {
        setState(() {
            queryUFC = bool;
        });
    }

    void _toggleQueryBellator(bool) {
        setState(() {
            queryBellator = bool;
        });
    }

    void _toggleQueryOneFC(bool) {
        setState(() {
            queryOneFC = bool;
        });
    }

    void _queryMMAWebsite(delete) {
        //Reset the status back to blank, then query MMA events for MMA Events
        //depending on the checkboxes the user selected
        //Bool 'delete' indicates whether events should be deleted or added to calendar
        statusString = '';
        setState(() {
            //Update the global deleted bool variable so the status string displays
            //correct header
            deleted = delete;
        });
        if (queryUFC) {
            _queryAndParseWebsiteUFCBellator('ufc', delete);
        }
        if (queryBellator) {
            _queryAndParseWebsiteUFCBellator('bellator', delete);
        }
        if (queryOneFC) {
            _queryAndParseWebsiteOneFC(delete);
        }
    }

    Future _addEventsToCalendar(List<MMAEvent> mmaEvents) async {
        //Method to add events to the user's calendar
        //If called, the list of mmaEvents will be iterated through and the mma
        // Events will be added to the user's selected calendar

        //If the events have previously been added by the user, they will have a
        // shared preference key for the Event ID and the event will be UPDATED
        // instead of CREATED

        //If events are successfully created/added, then the events that were
        // CREATED/UPDATED will be displayed to the user in the status string

        var fightString = new StringBuffer('');
        SharedPreferences prefs = await SharedPreferences.getInstance();

        for (var mmaEvent in mmaEvents) {
            //Before adding MMA Event to calendar, check if it is ready for calendar
            // (i.e. ensure it is properly formatted)
            if (mmaEvent.readyForCalendar) {
                final eventTime = mmaEvent.eventDate;
                final eventToCreate = new Event(_currentCalendarID);
                eventToCreate.title = mmaEvent.eventName;
                eventToCreate.start = eventTime;
                eventToCreate.description = mmaEvent.eventDetails.toString();
                String mmaEventId = prefs.getString(mmaEvent.getPrefKey());
                bool previouslyDeleted = prefs.getBool(mmaEvent.getPrefBoolKey());
                if (mmaEventId != null) {
                    if (previouslyDeleted != null && !previouslyDeleted){
                        //If the event already has an ID (was already added) and has not
                        //been previously deleted, set the ID on the event to update
                        eventToCreate.eventId = mmaEventId;
                    }
                }
                eventToCreate.end = eventTime.add(new Duration(hours: 3));
                final createEventResult =
                await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);
                if (createEventResult.isSuccess &&
                    (createEventResult.data?.isNotEmpty ?? false)) {
                    prefs.setString(mmaEvent.getPrefKey(), createEventResult.data);
                    fightString.write(mmaEvent.eventName + '\n');
                }
            }
        }

        setState(() {
            statusString = statusString + fightString.toString();
        });
    }

    Future _deleteEventsFromCalendar(List<MMAEvent> mmaEvents) async {
        //Method to delete events from the user's calendar
        //If called, the list of mmaEvents will be iterated through and the mma
        // Events will be deleted from the user's selected calendar if they were
        // previously added

        //If the events have previously been added by the user, they will have a
        // shared preference key for the Event ID and the event will be DELETED

        //If the events have not been previously added, then the delete method will
        //not be called on them

        var fightString = new StringBuffer('');
        SharedPreferences prefs = await SharedPreferences.getInstance();

        for (var mmaEvent in mmaEvents) {
            //Before adding MMA Event to calendar, check if it is ready for calendar
            // (i.e. ensure it is properly formatted)
            if (mmaEvent.readyForCalendar) {
                final eventToCreate = new Event(_currentCalendarID);
                String mmaEventId = prefs.getString(mmaEvent.getPrefKey());
                if (mmaEventId != null) {
                    eventToCreate.eventId = mmaEventId;
                    final createEventResult =
                    await _deviceCalendarPlugin.deleteEvent(_currentCalendarID, eventToCreate.eventId);
                    if (createEventResult.isSuccess) {
                        fightString.write(mmaEvent.eventName + '\n');
                        //Set bool pref indicating event has been previously deleted
                        prefs.setBool(mmaEvent.getPrefBoolKey(), true);
                    }
                }
            }
        }

        setState(() {
            statusString = statusString + fightString.toString();
        });
    }

    Future _queryAndParseWebsiteUFCBellator(String eventType, bool delete) async {
        //Method to query mmafighting.com parse data for upcoming MMA Events
        //eventType can be 'UFC' or 'Bellator'
        //Different event types are queried depending on which checkboxes user has selected from main page UI

        var client = Client();
        StringBuffer url = new StringBuffer('https://www.mmafighting.com/schedule');
        url.write('/' + eventType);
        Response response = await client.get(url.toString());

        if (response.statusCode != 200) {
            //If HTTP OK response is not received, return empty body and let user
            //know if connection error
            setState(() {
                statusString = 'Error Connecting to Network';
            });
            return response.body;
        }

        var document = parse(response.body);

        //Get Dates (Dates all have H3 headers)
        var eventDate = document.querySelectorAll('h3');
        var eventDateIterator = eventDate.iterator;

        //Get Fights and Event Titles
        //Event titles all contain 'fight-card' in link HREF attribute
        //Fights all contain '/fight/' in the link HREF attribute
        var fightLinks = document.querySelectorAll('a');

        //List of MMA Events to create from parsed data
        List<MMAEvent> mmaEvents = [];

        for (var link in fightLinks) {
            String title = link.text;
            String href = link.attributes['href'];
            if (title != null && href != null && href.contains('fight-card')) {
                //If link contains 'fight card', link is referencing the event name
                //Create a new event with the event name
                var mmaEvent = new MMAEvent(title);
                mmaEvents.add(mmaEvent);
                if (eventDateIterator.moveNext()) {
                    //For every event name, there is an associated date (in the same order)
                    //Move the iterator to the next date and add the date to the MMA Event
                    mmaEvent.addDateUFCBellator(eventDateIterator.current.text);
                }
            } else if (title != null && href != null && href.contains('/fight/')) {
                //If the link contains '/fight/' then it is fight data
                //Add the fight data to the current event (last event in list of MMA events)
                mmaEvents.elementAt(mmaEvents.length - 1).addDetails(title);
            }
        }

        //Check if events are being deleted or added/updated
        if(!delete){
            //Add the queried events to the user's calendar
            _addEventsToCalendar(mmaEvents);
        } else {
            //Delete events from the user's calendar
            _deleteEventsFromCalendar(mmaEvents);
        }

        return response.body;
    }

    Future _queryAndParseWebsiteOneFC(bool delete) async {
        //Method to query onefc.com parse data for upcoming MMA Events

        var client = Client();
        StringBuffer url = new StringBuffer('https://www.onefc.com/events/');
        Response response = await client.get(url.toString());

        if (response.statusCode != 200) {
            //If HTTP OK response is not received, return empty body and let user
            //know if connection error
            setState(() {
                statusString = 'Error Connecting to Network';
            });
            return response.body;
        }

        var document = parse(response.body);

        //Get Dates (Dates all have div headers with class=date)
        var eventDate = document.querySelectorAll('div.date');
        var eventDateIterator = eventDate.iterator;
        //Move iterator by 1 so current bout is not added to calendar
        //Only future bouts are added to calendar
        eventDateIterator.moveNext();

        //Get Location and Event Titles
        var fightLinks = document.querySelectorAll('h3.title');
        var location = document.querySelectorAll('div.location');
        var locationIterator = location.iterator;
        //Skip the 1st (current) location
        //Only locations associated with future events are added to calendar
        locationIterator.moveNext();

        //List of MMA Events to create from parsed data
        List<MMAEvent> mmaEvents = [];

        for (var link in fightLinks) {
            String title = link.text;
            if (title != null ) {
                //Create a new event with the event name
                var mmaEvent = new MMAEvent(title);
                if (eventDateIterator.moveNext()) {
                    mmaEvents.add(mmaEvent);
                    //For every event name, there is an associated date and location
                    //(in the same order)
                    //Move the iterator to the next date and add the date to the MMA Event
                    mmaEvent.addDateOneFC(eventDateIterator.current.text);
                    if(locationIterator.moveNext()){
                        //Move the iterator to the next location and add to the MMA Eevnt
                        mmaEvent.addDetails(locationIterator.current.text);
                    }
                } else {
                    break;
                }

            }
        }

        //Check if events are being deleted or added/updated
        if(!delete){
            //Add the queried events to the user's calendar
            _addEventsToCalendar(mmaEvents);
        } else {
            //Delete events from the user's calendar
            _deleteEventsFromCalendar(mmaEvents);
        }


        return response.body;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            drawer: Menu(widget.user),
            appBar: AppBar(
                title: Text(
                    'Calendario',
                    style: TextStyle(
                        color: Colors.white,
                    ),

                ),
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                CheckboxListTile(
                                    value: queryUFC,
                                    title:
                                    Text('UFC', style: Theme.of(context).textTheme.body1),
                                    onChanged: _toggleQueryUFC),
                                CheckboxListTile(
                                    value: queryBellator,
                                    title: Text('Bellator',
                                        style: Theme.of(context).textTheme.body1),
                                    onChanged: _toggleQueryBellator),
                                CheckboxListTile(
                                    value: queryOneFC,
                                    title: Text('One FC',
                                        style: Theme.of(context).textTheme.body1),
                                    onChanged: _toggleQueryOneFC),
                            ],
                        ),
                        new Expanded(child: calendarButtonOrCalendar()),
                        loadFightsButton(),
                        deleteFightsButton(),
                        statusMessageHeader(),
                        new Expanded(
                            child: SingleChildScrollView(
                                child: Text(
                                    statusString,
                                    style: Theme.of(context).textTheme.body1,
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
