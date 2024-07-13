import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/features/history/models/screen_config_model.dart';
import 'package:mood_tracker/features/history/repos/screen_config_repository.dart';

class ScreenConfigViewModel extends Notifier<ScreenConfigModel> {
  final ScreenConfigRepository _repository;

  ScreenConfigViewModel(this._repository);

  @override
  ScreenConfigModel build() {
    return ScreenConfigModel(
      dark: _repository.isDark(),
    );
  }

  late final ScreenConfigModel _model = ScreenConfigModel(
    dark: _repository.isDark(),
  );

  bool get dark => _model.dark;

  void setDark(bool value) {
    _repository.setDark(value);
    state = ScreenConfigModel(
      dark: value,
    );
  }
}

final screenConfigProvider =
    NotifierProvider<ScreenConfigViewModel, ScreenConfigModel>(
  () => throw UnimplementedError(),
);
