//  Add MemberDonation

class MemberDonation {
  String id;
  final String number;
  final String email;
  final String user_type;

  MemberDonation(
      {this.id = "",
      required this.number,
      required this.email,
      required this.user_type});

  Map<String, dynamic> toJson() =>
      {'id': id, 'number': number, 'email': email, 'user_type': user_type};

  static MemberDonation fromJson(Map<String, dynamic> json) => MemberDonation(
      id: json['id'],
      number: json['number'],
      email: 'email',
      user_type: 'user_type');
}

//  Add Users

class ImageModel {
  String id;
  final String url;

  ImageModel({
    this.id = "",
    required this.url,
  });

  Map<String, dynamic> toJson() => {'id': id, 'url': url};

  static ImageModel fromJson(Map<String, dynamic> json) =>
      ImageModel(id: json['id'], url: json['url']);
}

//  Add Users

class Users {
  String id;
  final String number;
  final String email;
  final String user_type;

  Users(
      {this.id = "",
      required this.number,
      required this.email,
      required this.user_type});

  Map<String, dynamic> toJson() =>
      {'id': id, 'number': number, 'email': email, 'user_type': user_type};

  static Users fromJson(Map<String, dynamic> json) => Users(
      id: json['id'],
      number: json['number'],
      email: 'email',
      user_type: 'user_type');
}

// members modal

class Members {
  String id;
  final String first_name;
  final String last_name;
  final String email;
  final String address;
  final String number;
  final String blood;
  final String url;

  Members({
    this.id = "",
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.address,
    required this.number,
    required this.blood,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'address': address,
        'number': int.parse(number),
        'email': email,
        'blood': blood,
        'url': url,
        'created_at': DateTime(2020, 3, 4)
      };

  static Members fromJson(Map<String, dynamic> json) => Members(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      address: json['address'],
      number: json['number'],
      blood: json['blood'],
      url: json['url']
      // created_at: (json['created_at'] as TimeStamp).toDate()
      );
}

class News {
  // int id;
  final String title;
  final String url;
  final String description;
  // final String date;

  News({
    // this.id = 0,
    required this.title,
    required this.description,
    required this.url,
    // required this.date,
  });

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'title': title,
        'description': description,
        'url': url,
        // 'date': DateTime.now()
      };

  static News fromJson(Map<String, dynamic> json) => News(
        // id: json['id'],
        title: json['title'],
        description: json['description'],
        url: json['url'],
        // date: json['date'],

        // created_at: (json['created_at'] as TimeStamp).toDate()
      );
}

// Events Model
class Event {
  String id;
  final String title;
  final String url;
  final String description;
  final String date;

  Event({
    this.id = "",
    required this.title,
    required this.description,
    required this.url,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'url': url,
        'date': DateTime.now()
      };

  static Event fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        url: json['url'],
        date: json['date'],

        // created_at: (json['created_at'] as TimeStamp).toDate()
      );
}
// Donation modal

class Donation {
  String id;
  final String first_name;
  final String last_name;
  final String number;
  final String donated;
  final String date;
  Donation({
    this.id = "",
    required this.first_name,
    required this.last_name,
    required this.number,
    required this.donated,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'number': number,
        'donated': donated,
        'date': DateTime.now()
      };

  static Donation fromJson(Map<String, dynamic> json) => Donation(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        number: json['number'],
        donated: 'donated',
        date: json['date'],
        // created_at: (json['created_at'] as TimeStamp).toDate()
      );
}

//Jennsy Donation modal

class Jennsy {
  String id;
  final String first_name;
  final String last_name;
  final String number;
  final String jennsy;
  final String date;
  Jennsy({
    this.id = "",
    required this.first_name,
    required this.last_name,
    required this.number,
    required this.jennsy,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'number': number,
        'jennsy': jennsy,
        'date': DateTime.now()
      };

  static Jennsy fromJson(Map<String, dynamic> json) => Jennsy(
        id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        number: json['number'],
        jennsy: 'jennsy',
        date: json['date'],
        // created_at: (json['created_at'] as TimeStamp).toDate()
      );
}

//  Add Volunteer

class Volunteer {
  // int id;
  final String first_name;
  final String last_name;
  final String number;
  final String email;
  final String address;
  final String date;
  Volunteer({
    // this.id = "",
    required this.first_name,
    required this.last_name,
    required this.number,
    required this.email,
    required this.address,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'number': number,
        'email': email,
        'address': address,
        'date': DateTime.now()
      };

  static Volunteer fromJson(Map<String, dynamic> json) => Volunteer(
        // id: json['id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        number: json['number'],
        email: 'email',
        address: 'address',
        date: json['date'],
        // created_at: (json['created_at'] as TimeStamp).toDate()
      );
}
