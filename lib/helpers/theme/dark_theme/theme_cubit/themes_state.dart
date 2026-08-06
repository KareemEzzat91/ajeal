part of 'themes_cubit.dart';

@immutable
class ThemeState {
  final ThemeData themeData;
  final Locale loc;
  const ThemeState(this.loc, this.themeData);
}
