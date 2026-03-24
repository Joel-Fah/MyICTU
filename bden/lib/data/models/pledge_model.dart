import '../../core/enums/blood_type.dart';
import '../../core/enums/pledge_status.dart';

class PledgeModel {
  final String id;
  final String campaignId;
  final String donorId;
  final String donorName;
  final BloodType donorBloodType;
  final PledgeStatus status;
  final DateTime? scheduledDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PledgeModel({
    required this.id,
    required this.campaignId,
    required this.donorId,
    required this.donorName,
    required this.donorBloodType,
    required this.status,
    this.scheduledDate,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == PledgeStatus.pledged;

  factory PledgeModel.fromJson(Map<String, dynamic> json) => PledgeModel(
        id: json['id'],
        campaignId: json['campaignId'],
        donorId: json['donorId'],
        donorName: json['donorName'],
        donorBloodType: BloodType.fromString(json['donorBloodType']),
        status: PledgeStatus.values.byName(json['status']),
        scheduledDate: json['scheduledDate'] != null
            ? DateTime.parse(json['scheduledDate'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'campaignId': campaignId,
        'donorId': donorId,
        'donorName': donorName,
        'donorBloodType': donorBloodType.label,
        'status': status.name,
        'scheduledDate': scheduledDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  PledgeModel copyWith({
    PledgeStatus? status,
    DateTime? scheduledDate,
    DateTime? updatedAt,
  }) =>
      PledgeModel(
        id: id,
        campaignId: campaignId,
        donorId: donorId,
        donorName: donorName,
        donorBloodType: donorBloodType,
        createdAt: createdAt,
        status: status ?? this.status,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        updatedAt: updatedAt ?? DateTime.now(),
      );
}
