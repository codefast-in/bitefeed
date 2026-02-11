import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../bites/models/bite_model.dart';
import '../../../../core/models/pagination_model.dart';

class SearchResponseModel extends Equatable {
  final List<UserModel> users;
  final PaginationModel usersPagination;
  final List<BiteModel> bites;
  final PaginationModel bitesPagination;

  const SearchResponseModel({
    required this.users,
    required this.usersPagination,
    required this.bites,
    required this.bitesPagination,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      users: (json['users']?['results'] as List? ?? [])
          .map((u) => UserModel.fromJson(u as Map<String, dynamic>))
          .toList(),
      usersPagination: PaginationModel.fromJson(
        json['users']?['pagination'] ?? {},
      ),
      bites: (json['bites']?['results'] as List? ?? [])
          .map((b) => BiteModel.fromJson(b as Map<String, dynamic>))
          .toList(),
      bitesPagination: PaginationModel.fromJson(
        json['bites']?['pagination'] ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [users, usersPagination, bites, bitesPagination];
}
