# Custom bash script to generate some codes that needed by this project.

flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run easy_localization:generate -S assets/translations -f keys -O lib/commons/resources  -o locale_keys.g.dart