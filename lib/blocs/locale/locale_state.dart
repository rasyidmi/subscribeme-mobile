part of 'locale_bloc.dart';

abstract class LocaleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocaleInit extends LocaleState {}

class NewLocaleSet extends LocaleState {
  final String languageCode;
  NewLocaleSet(this.languageCode);
  @override
  List<Object?> get props => [languageCode];
}
