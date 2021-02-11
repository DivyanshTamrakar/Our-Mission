import 'dart:convert';

Department departmentFromJson(String str) => Department.fromJson(json.decode(str));

String departmentToJson(Department data) => json.encode(data.toJson());

class Department {
    Department({
        this.subDepartment,
        this.status,
        this.id,
        this.title,
        this.description,
        this.file,
    });

    List<String> subDepartment;
    String status;
    String id;
    String title;
    String description;
    String file;

    factory Department.fromJson(Map<String, dynamic> json) => Department(
        subDepartment: List<String>.from(json["sub_department"].map((x) => x)),
        status: json["status"],
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        file: json["file"],
    );

    Map<String, dynamic> toJson() => {
        "sub_department": List<dynamic>.from(subDepartment.map((x) => x)),
        "status": status,
        "_id": id,
        "title": title,
        "description": description,
        "file": file,
    };
}
