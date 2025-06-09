import 'package:random_avatar/random_avatar.dart';

// Function to generate a random avatar using RandomAvatar package
String generateRandomAvatar() {
  // Returns a unique random avatar URL using the current time
  return RandomAvatar(
    DateTime.now().toIso8601String(), // Unique seed for avatar
    height: 90,
    width: 90,
  ).toString();
}
