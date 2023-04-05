import 'package:supabase/supabase.dart';
import '../../.env/.ConstFile.dart.dart';

class SupbaseDataBase {
  static final supabase = SupabaseClient(ConstFile.url, ConstFile.key);

  static addNewUser({required Map<String, dynamic> userMap}) async {
    try {
      await supabase.from('user').insert(userMap);
    } on FormatException catch (e) {
      throw FormatException(e.message);
    }
  }
}
