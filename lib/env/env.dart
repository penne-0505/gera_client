import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GERA_CLIENT_CS_ENGINE_ID', obfuscate: true)
  static String engineId = _Env.engineId;

  @EnviedField(varName: 'GERA_CLIENT_CS_API_KEY', obfuscate: true)
  static String apiKey = _Env.apiKey;

  @EnviedField(varName: 'GERA_CLIENT_CONFIG_PATH', obfuscate: true)
  static String cfgPath = _Env.cfgPath;

  @EnviedField(varName: 'GERA_CLIENT_DOWNLOAD_PATH', obfuscate: true)
  static String downloadPath = _Env.downloadPath;
}
