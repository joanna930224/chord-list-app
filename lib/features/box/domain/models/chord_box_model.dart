import 'package:chord_list_app/shared/data/db/app_database.dart';

class ChordBoxModel {
  const ChordBoxModel({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String? description;
  final DateTime createdAt;

  factory ChordBoxModel.fromData(ChordBox data) => ChordBoxModel(
    id: data.id,
    title: data.title,
    description: data.description,
    createdAt: data.createdAt,
  );
}
