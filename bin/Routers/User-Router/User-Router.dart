import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRouter {
  Handler get router {
    final app = Router();
    final pipeline = Pipeline()
        .addMiddleware((innerHandler) => (Request req) {
              if (req.url.path == 'profile') {
                return Response.forbidden('sorry you are  try use get');
              }
              return innerHandler(req);
            })
        .addHandler(app);

    // --------------home-------------
    app.get('/home', (Request req) {
      return Response.ok('home');
    });
    // --------------setting-------------
    app.get('/setting', (Request req) {
      return Response.ok('setting');
    });
    // --------------profile-------------
    app.get('/profile', (Request req) {
      return Response.ok('profile');
    });

    return pipeline;
  }
}
