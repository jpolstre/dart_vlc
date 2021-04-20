import 'package:dart_vlc/src/channel.dart';
import 'package:dart_vlc/src/mediaSource/media.dart';

/// Internally used class to avoid direct creation of the object of a [Broadcast] class.
class _Broadcast extends Broadcast {}

/// Used to declare a [Broadcast] configuration.
///
/// An example configuration for a [Broadcast] can be as follows.
///
/// ```dart
/// new BroadcastConfiguration(
///   access: 'http',
///   mux: 'mpeg1',
///   dst: '127.0.0.1:8080',
///   vcodec: 'mp1v',
///   vb: 1024,
///   acodec: 'mpga',
///   ab: 128,
/// );
/// ```
class BroadcastConfiguration {
  /// Type of access for [Broadcast] e.g. `http`.
  final String access;

  /// MUX e.g. `mpeg1`.
  final String mux;

  /// Destination e.g. `127.0.0.1:8080`.
  final String dst;

  /// Video codec for transcoding the broadcast e.g. `mp1v`.
  final String vcodec;

  /// Video bitrate for transcoding the broadcast.
  final int vb;

  /// Audio codec for transcoding the broadcast e.g. `mpga`.
  final String acodec;

  /// Audio bitrate for transcoding the broadcast.
  final int ab;

  const BroadcastConfiguration({
    required this.access,
    required this.mux,
    required this.dst,
    required this.vcodec,
    required this.vb,
    required this.acodec,
    required this.ab,
  });

  Map<String, dynamic> toMap() => {
        'access': this.access,
        'mux': this.mux,
        'dst': this.dst,
        'vcodec': this.vcodec,
        'vb': this.vb,
        'acodec': this.acodec,
        'ab': this.ab,
      };
}

/// Creates new [Broadcast] for a [Media].
///
/// Example creation can be as follows.
///
/// ```dart
/// Broadcast broadcast = await Broadcast.create(
///   id: 0,
///   media: await Media.file(new File('C:/music.ogg')),
///   configuration: new BroadcastConfiguration(
///     access: 'http',
///     mux: 'mpeg1',
///     dst: '127.0.0.1:8080',
///     vcodec: 'mp1v',
///     vb: 1024,
///     acodec: 'mpga',
///     ab: 128,
///   ),
/// );
///
/// broadcast.start();
/// ```
///
/// Call [Broadcast.dispose] for releasing the resources.
///
abstract class Broadcast {
  /// ID for this broadcast.
  late int id;

  /// Broadcasting [Media].
  late Media media;

  /// Configuration of this broadcast.
  late BroadcastConfiguration configuration;

  /// Creates a new [Broadcast] instance.
  static Future<Broadcast> create(
      {required int id,
      required Media media,
      required BroadcastConfiguration configuration}) async {
    Broadcast broadcast = new _Broadcast();
    broadcast.id = id;
    broadcast.media = media;
    broadcast.configuration = configuration;
    await channel.invokeMethod(
      'Broadcast.create',
      {
        'id': id,
        'media': media.toMap(),
        'configuration': configuration.toMap(),
      },
    );
    return broadcast;
  }

  /// Starts broadcasting the [Media].
  Future<void> start() async {
    await channel.invokeMethod(
      'Broadcast.start',
      {
        'id': id,
      },
    );
  }

  /// Disposes this instance of [Broadcast].
  Future<void> dispose() async {
    await channel.invokeMethod(
      'Broadcast.dispose',
      {
        'id': id,
      },
    );
  }
}
