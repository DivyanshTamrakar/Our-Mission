import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.profile,
    this.address,
    this.contact,
    this.location,
    this.verified,
  });

  String id;
  String name;
  String email;
  String profile;
  String address;
  int contact;
  Location location;
  String verified;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    profile: json["profile"],
    address: json["address"],
    contact: json["contact"],
    location: Location.fromJson(json["location"]),
    verified: json["verified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "profile": profile,
    "address": address,
    "contact": contact,
    "location": location.toJson(),
    "verified": verified,
  };
}

class Location {
  Location({
    this.coordinates,
  });

  List<dynamic> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    coordinates: List<dynamic>.from(json["coordinates"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}
