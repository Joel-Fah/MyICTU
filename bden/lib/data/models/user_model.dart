import '../../core/enums/blood_type.dart';
import '../../core/enums/user_role.dart';
import '../../core/enums/auth_provider_type.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final UserRole role;
  final AuthProviderType authProvider;
  final BloodType? bloodType;
  final String? city;
  final String? region;
  final bool isEligible;
  final DateTime? lastDonationDate;
  final int totalDonations;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.role,
    required this.authProvider,
    this.bloodType,
    this.city,
    this.region,
    this.isEligible = true,
    this.lastDonationDate,
    this.totalDonations = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOrganizer => role == UserRole.organizer;
  bool get isDonor => role == UserRole.donor;
  bool get canDonate => isEligible && bloodType != null;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        email: json['email'],
        displayName: json['displayName'],
        photoUrl: json['photoUrl'],
        role: UserRole.values.byName(json['role']),
        authProvider: AuthProviderType.values.byName(json['authProvider']),
        bloodType: json['bloodType'] != null
            ? BloodType.fromString(json['bloodType'])
            : null,
        city: json['city'],
        region: json['region'],
        isEligible: json['isEligible'] ?? true,
        lastDonationDate: json['lastDonationDate'] != null
            ? DateTime.parse(json['lastDonationDate'])
            : null,
        totalDonations: json['totalDonations'] ?? 0,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'role': role.name,
        'authProvider': authProvider.name,
        'bloodType': bloodType?.label,
        'city': city,
        'region': region,
        'isEligible': isEligible,
        'lastDonationDate': lastDonationDate?.toIso8601String(),
        'totalDonations': totalDonations,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    BloodType? bloodType,
    String? city,
    String? region,
    bool? isEligible,
    DateTime? lastDonationDate,
    int? totalDonations,
    UserRole? role,
    DateTime? updatedAt,
  }) =>
      UserModel(
        uid: uid,
        email: email,
        displayName: displayName ?? this.displayName,
        photoUrl: photoUrl ?? this.photoUrl,
        role: role ?? this.role,
        authProvider: authProvider,
        bloodType: bloodType ?? this.bloodType,
        city: city ?? this.city,
        region: region ?? this.region,
        isEligible: isEligible ?? this.isEligible,
        lastDonationDate: lastDonationDate ?? this.lastDonationDate,
        totalDonations: totalDonations ?? this.totalDonations,
        createdAt: createdAt,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
