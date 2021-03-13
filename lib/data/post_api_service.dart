import 'package:chopper/chopper.dart';

part 'post_api_service.chopper.dart';

@ChopperApi(baseUrl: "/v4")
abstract class PostApiService extends ChopperService {
  @Get(path: "/launches/past")
  Future<Response> getPastLaunches();

  @Get(path: "/rockets/{id}")
  Future<Response> getRocket(@Path() String id);

  @Get(path: "/launchpads/{id}")
  Future<Response> getLaunchpad(@Path() String id);

  @Get(path: "/payloads/{id}")
  Future<Response> getPayload(@Path() String id);

  static PostApiService create() {
    final client = ChopperClient(
        baseUrl: "https://api.spacexdata.com",
        services: [_$PostApiService()],
        converter: JsonConverter());
    return _$PostApiService(client);
  }
}
