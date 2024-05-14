import 'package:equatable/equatable.dart';

class EquatableList extends Equatable {
  final List<dynamic> list;

  EquatableList(this.list);

  @override
  List<Object?> get props => [list];
}
