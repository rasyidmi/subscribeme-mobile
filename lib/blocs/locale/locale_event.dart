part of 'locale_bloc.dart';

abstract class LocaleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetNewLocale extends LocaleEvent {
  final String languageCode;
  SetNewLocale(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
