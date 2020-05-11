// To parse this JSON data, do
//
//     final puntosInteres = puntosInteresFromJson(jsonString);

import 'dart:convert';

PuntosInteres puntosInteresFromJson(String str) => PuntosInteres.fromJson(json.decode(str));

String puntosInteresToJson(PuntosInteres data) => json.encode(data.toJson());

class PuntosInteres {
    List<dynamic> htmlAttributions;
    String nextPageToken;
    List<PuntoInteres> results;
    String status;

    PuntosInteres({
        this.htmlAttributions,
        this.nextPageToken,
        this.results,
        this.status,
    });

    factory PuntosInteres.fromJson(Map<String, dynamic> json) => PuntosInteres(
        htmlAttributions: List<dynamic>.from(json["html_attributions"].map((x) => x)),
        nextPageToken: json["next_page_token"],
        results: List<PuntoInteres>.from(json["results"].map((x) => PuntoInteres.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
        "next_page_token": nextPageToken,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
    };
}

class PuntoInteres {
    BusinessStatus businessStatus;
    String formattedAddress;
    Geometry geometry;
    String icon;
    String id;
    String name;
    OpeningHours openingHours;
    List<Photo> photos;
    String placeId;
    PlusCode plusCode;
    double rating;
    String reference;
    List<Type> types;
    int userRatingsTotal;

    PuntoInteres({
        this.businessStatus,
        this.formattedAddress,
        this.geometry,
        this.icon,
        this.id,
        this.name,
        this.openingHours,
        this.photos,
        this.placeId,
        this.plusCode,
        this.rating,
        this.reference,
        this.types,
        this.userRatingsTotal,
    });

    factory PuntoInteres.fromJson(Map<String, dynamic> json) => PuntoInteres(
        businessStatus: businessStatusValues.map[json["business_status"]],
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        icon: json["icon"],
        id: json["id"],
        name: json["name"],
        openingHours: json["opening_hours"] == null ? null : OpeningHours.fromJson(json["opening_hours"]),
        photos: json["photos"] == null ? null : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        placeId: json["place_id"],
        plusCode: PlusCode.fromJson(json["plus_code"]),
        rating: json["rating"].toDouble(),
        reference: json["reference"],
        types: List<Type>.from(json["types"].map((x) => typeValues.map[x])),
        userRatingsTotal: json["user_ratings_total"],
    );

    Map<String, dynamic> toJson() => {
        "business_status": businessStatusValues.reverse[businessStatus],
        "formatted_address": formattedAddress,
        "geometry": geometry.toJson(),
        "icon": icon,
        "id": id,
        "name": name,
        "opening_hours": openingHours == null ? null : openingHours.toJson(),
        "photos": photos == null ? null : List<dynamic>.from(photos.map((x) => x.toJson())),
        "place_id": placeId,
        "plus_code": plusCode.toJson(),
        "rating": rating,
        "reference": reference,
        "types": List<dynamic>.from(types.map((x) => typeValues.reverse[x])),
        "user_ratings_total": userRatingsTotal,
    };
}

enum BusinessStatus { OPERATIONAL }

final businessStatusValues = EnumValues({
    "OPERATIONAL": BusinessStatus.OPERATIONAL
});

class Geometry {
    Location location;
    Viewport viewport;

    Geometry({
        this.location,
        this.viewport,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        viewport: Viewport.fromJson(json["viewport"]),
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "viewport": viewport.toJson(),
    };
}

class Location {
    double lat;
    double lng;

    Location({
        this.lat,
        this.lng,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}

class Viewport {
    Location northeast;
    Location southwest;

    Viewport({
        this.northeast,
        this.southwest,
    });

    factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
    );

    Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
    };
}

class OpeningHours {
    bool openNow;

    OpeningHours({
        this.openNow,
    });

    factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
        openNow: json["open_now"],
    );

    Map<String, dynamic> toJson() => {
        "open_now": openNow,
    };
}

class Photo {
    int height;
    List<String> htmlAttributions;
    String photoReference;
    int width;

    Photo({
        this.height,
        this.htmlAttributions,
        this.photoReference,
        this.width,
    });

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        height: json["height"],
        htmlAttributions: List<String>.from(json["html_attributions"].map((x) => x)),
        photoReference: json["photo_reference"],
        width: json["width"],
    );

    Map<String, dynamic> toJson() => {
        "height": height,
        "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
        "photo_reference": photoReference,
        "width": width,
    };
}

class PlusCode {
    String compoundCode;
    String globalCode;

    PlusCode({
        this.compoundCode,
        this.globalCode,
    });

    factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
    );

    Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
    };
}

enum Type { VETERINARY_CARE, POINT_OF_INTEREST, ESTABLISHMENT, HEALTH, STORE, HOSPITAL }

final typeValues = EnumValues({
    "establishment": Type.ESTABLISHMENT,
    "health": Type.HEALTH,
    "hospital": Type.HOSPITAL,
    "point_of_interest": Type.POINT_OF_INTEREST,
    "store": Type.STORE,
    "veterinary_care": Type.VETERINARY_CARE
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
