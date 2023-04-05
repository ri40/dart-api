import 'package:supabase/supabase.dart';
import '../../../Routers/.env/.ConstFile.dart.dart';

class AuthSupBase {
  static final supabase = SupabaseClient(ConstFile.url, ConstFile.key);
// "Rim1@1Thegarage"
  // --------------signup-------------
  static creatAccount({required String email, required String password}) async {
    try {
      AuthResponse newUser =
          await supabase.auth.signUp(email: email, password: password);

      Map<String, dynamic> castomJson = {
        "id": newUser.user?.id,
        "userEmail": newUser.user?.email,
        "last_sign": newUser.user?.lastSignInAt,
      };
      return castomJson;
    } on AuthException catch (error) {
      throw FormatException(error.message);
    }
  }

  // --------------verify-------------
  static verify({required String token, required String email}) async {
    AuthResponse newUser = await supabase.auth
        .verifyOTP(email: email, token: token, type: OtpType.signup);

    Map<String, dynamic> tokenJson = {
      "id": newUser.user?.id,
      "userEmail": newUser.user?.email,
      "last_sign": newUser.user?.lastSignInAt,
      "token": newUser.session?.accessToken
    };
    return tokenJson;
  }
  // --------------login-------------

  static loginUser({required String email, required String password}) async {
    try {
      AuthResponse newUser = await supabase.auth
          .signInWithPassword(email: email, password: password);

      Map<String, dynamic> castomJson = {
        "id": newUser.user?.id,
        "userEmail": newUser.user?.email,
        "last_sign": newUser.user?.lastSignInAt,
      };
      return castomJson;
    } on AuthException catch (error) {
      throw FormatException(error.message);
    }
  }
}
