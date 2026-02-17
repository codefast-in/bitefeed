import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../bites/models/bite_model.dart';
import '../../../../core/models/pagination_model.dart';

class OtherUserProfileModel extends Equatable {
  final UserModel profile;
  final List<BiteModel> bites;
  final PaginationModel pagination;

  const OtherUserProfileModel({
    required this.profile,
    required this.bites,
    required this.pagination,
  });

  factory OtherUserProfileModel.fromJson(Map<String, dynamic> json) {
    final bitesData = json['bites'];
    final bitesList = (bitesData is Map)
        ? (bitesData['list'] as List?)
        : (bitesData as List?);

    return OtherUserProfileModel(
      profile: UserModel.fromJson(json['profile'] ?? {}),
      bites: (bitesList ?? [])
          .map((b) => BiteModel.fromJson(b as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
        json['pagination'] ?? bitesData ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [profile, bites, pagination];
}
