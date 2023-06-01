import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleInit()) {
    on<SetNewLocale>(_onSetNewLocale);
  }

  Future<void> _onSetNewLocale(
      SetNewLocale event, Emitter<LocaleState> emit) async {
    emit(NewLocaleSet(event.languageCode));
  }
}
