import 'package:angel_websocket/server.dart';

/// A simple filter that can be used to filter WebSocket events
/// and only broadcast them to authenticated users.
onlyBroadcastToAuthenticatedUsers(_, WebSocketContext socket) =>
    socket.request.properties.containsKey('user');
