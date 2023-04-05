import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../Auth-Routers/Auth-route.dart';
import '../User-Router/User-Router.dart';

class BassRouter {
  Handler get router {
    final app = Router();
    app.mount('/auth/', AuthRoute().router);
    app.mount('/user/', UserRouter().router);
    return app;
  }
}
  // Handler get router {