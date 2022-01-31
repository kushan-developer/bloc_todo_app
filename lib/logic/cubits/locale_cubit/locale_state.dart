part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  // enum
  final Status status;
  final String? error;
  final Locale? locale;

  const LocaleState({required this.status, this.error, this.locale});

  @override
  List<Object?> get props => [status, error];

  LocaleState copyWith({Status? status, String? error, Locale? locale}) {
    return LocaleState(
      status: status ?? this.status,
      error: error ?? this.error,
      locale: locale ?? this.locale,
    );
  }
}
