import '../../../core/constants/app_avatars.dart';
import '../../../domain/entities/user.dart';

class UsersLocal {
  static User sajad =
      const User(id: 1, name: 'Sajad', profilePicture: AppAvatars.firstAvatar);
  static User kristen = const User(
      id: 2, name: 'Kristen', profilePicture: AppAvatars.secondAvatar);
}
