class Complaint {
  Location location;
  String status;
  String sId;
  String customerId;
  String title;
  String description;
  int contact;
  String file;
  String email;
  String department;
  String subDepartment;
  String dateOfComplain;
  String createdAt;
  String updatedAt;
  int iV;

  Complaint(
      {this.location,
        this.status,
        this.sId,
        this.customerId,
        this.title,
        this.description,
        this.contact,
        this.file,
        this.email,
        this.department,
        this.subDepartment,
        this.dateOfComplain,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Complaint.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    status = json['status'];
    sId = json['_id'];
    customerId = json['customer_id'];
    title = json['title'];
    description = json['description'];
    contact = json['contact'];
    file = json['file'];
    email = json['email'];
    department = json['department'];
    subDepartment = json['sub_department'];
    dateOfComplain = json['date_of_complain'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['customer_id'] = this.customerId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['contact'] = this.contact;
    data['file'] = this.file;
    data['email'] = this.email;
    data['department'] = this.department;
    data['sub_department'] = this.subDepartment;
    data['date_of_complain'] = this.dateOfComplain;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Location {
  List<double> coordinates;

  Location({this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordinates'] = this.coordinates;
    return data;
  }
}