import 'package:equatable/equatable.dart';

class PaginationModel extends Equatable {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? json['pages'] ?? 1,
    );
  }

  @override
  List<Object?> get props => [total, page, limit, totalPages];
}
