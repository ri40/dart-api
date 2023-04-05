import 'dart:io';
import 'package:content_length_validator/content_length_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_rate_limiter/shelf_rate_limiter.dart';
import 'package:shelf_router/shelf_router.dart';

import 'Routers/Base-Routers/Bass-Router.dart';

void main() async {
  withHotreload(
    () => createServer(),
    onReloaded: () => print('Reload!'),
    onHotReloadNotAvailable: () => print('No hot-reload :('),
    onHotReloadAvailable: () => print('Yay! Hot-reload :)'),
    onHotReloadLog: (log) => print('Reload Log: ${log.message}'),
    logLevel: Level.INFO,
  );
}

Future<HttpServer> createServer() async {
  final host = InternetAddress.anyIPv4;
  final int port = int.parse(Platform.environment['post'] ?? '8080');

  final app = Router();
  app.mount('/', BassRouter().router);
  app.get('/', ((Request req) {
    return Response.ok("Api is running");
  }));
  app.get('/<name|.*>', ((Request req) {
    return Response.ok("check yuor path url");
  }));
  final memoryStorage = MemStorage();
  final rateLimiter = ShelfRateLimiter(
      storage: memoryStorage, duration: Duration(seconds: 60), maxRequests: 10);

  final pipeline = Pipeline()
      .addMiddleware(helmet())
      .addMiddleware(logRequests())
      .addMiddleware(rateLimiter.rateLimiter())
      .addMiddleware(
        maxContentLengthValidator(
          maxContentLength: 100,
        ),
      )
      .addMiddleware((innerHandler) => (Request req) {
            print('here is Middleware');
            // print(req.headersAll);
            print(req.handlerPath);
            print(req.method);
            print(req.protocolVersion);
            print(req.requestedUri);
            print(req.url);
            print(req.context);

            return innerHandler(req);
          })
      .addHandler(app);

  final server = await serve(pipeline, host, port);
  print("server is runing at http://${server.address.host}:${server.port}");
  return server;
}
