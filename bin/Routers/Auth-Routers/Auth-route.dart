import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../Services/supbase/auth/AuthSubBase.dart';
import 'DataBase/supbase_database.dart';

class AuthRoute {
  Handler get router {
    final app = Router();
    // --------------signup-------------
    app.post('/signup', (Request req) async {
      final body = await json.decode(await req.readAsString());
      Map? user = await AuthSupBase.creatAccount(
          email: body["email"], password: body["password"]);
      // if (user?['msg'] != null) {
      //   return Response(403,
      //       body: json.encode(user),
      //       headers: {"Content-Type": "application/json"});
      // }

      Map<String, dynamic> dataUser = {
        "email": user?["email"],
        "id": user?['id'],
        "name": body["name"],
      };
      await SupbaseDataBase.addNewUser(userMap: dataUser);

      return Response(200,
          body: json.encode(user),
          headers: {"Content-Type": "application/json"});
    });
    // --------------verify-------------
    app.post('/verify/<tokan>', (Request req, String token) async {
      final body = await json.decode(await req.readAsString());
      Map? user = await AuthSupBase.verify(email: body["email"], token: token);

      return Response(200,
          body: json.encode(user),
          headers: {"Content-Type": "application/json"});
    });
    // --------------login-------------
    app.post('/login', (Request req) async {
      try {
        final body = await json.decode(await req.readAsString());
        Map user = await AuthSupBase.loginUser(
            email: body["email"], password: body["password"]);

        return Response(200,
            body: json.encode(user),
            headers: {"Content-Type": "application/json"});
      } on FormatException catch (e) {
        return Response(403,
            body: json.encode({"msg": e.message}),
            headers: {"Content-Type": "application/json"});
      }
    });
    // --------------restpassword-------------
    app.post('/res', (Request req) => Response.ok('res'));
    return app;
  }
}
