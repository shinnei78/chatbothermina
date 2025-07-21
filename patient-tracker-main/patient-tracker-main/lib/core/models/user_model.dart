class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String phone;
  final String address;
  final String bloodType;
  final List<String> allergies;
  final String photoUrl;

  // Konstruktor untuk inisialisasi semua properti UserModel
  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.address,
    required this.bloodType,
    required this.allergies,
    required this.photoUrl,
  });

  // Factory method untuk membuat UserModel dari Map (biasanya untuk data dari Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,  // Menggunakan UID yang sudah ada
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      bloodType: map['bloodType'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  // Method untuk membuat salinan UserModel dengan data yang baru (copyWith untuk pembaruan data)
  UserModel copyWithFromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: uid,  // UID tetap sama
      email: email,  // Email tetap sama
      firstName: map['firstName'] ?? firstName,  // Jika ada perubahan, update firstName
      lastName: map['lastName'] ?? lastName,  // Jika ada perubahan, update lastName
      dob: map['dob'] ?? dob,  // Jika ada perubahan, update dob
      gender: map['gender'] ?? gender,  // Jika ada perubahan, update gender
      phone: map['phone'] ?? phone,  // Jika ada perubahan, update phone
      address: map['address'] ?? address,  // Jika ada perubahan, update address
      bloodType: map['bloodType'] ?? bloodType,  // Jika ada perubahan, update bloodType
      allergies: map['allergies'] != null
          ? List<String>.from(map['allergies'])  // Jika ada perubahan pada allergies, update
          : allergies,
      photoUrl: map['photoUrl'] ?? photoUrl,  // Jika ada perubahan, update photoUrl
    );
  }
}
