import 'package:lumi/features/in_app/explore/bloc/search_bloc.dart';
import 'package:lumi/features/in_app/explore/repository/demo_location_repository.dart';
import 'package:lumi/features/in_app/explore/repository/ws_search_repository.dart';
import 'package:lumi/features/in_app/explore/service/ws_client.dart';
import 'package:lumi/features/in_app/saved_bloc/saved_places_bloc.dart';

final wsClient = WsClient();
final searchRepo = SearchWsRepository(wsClient);
final demoLocationRepository = DemoLocationRepository();
final searchBloc = SearchBloc(searchRepo, demoLocationRepository);
final savedPlacesBloc = SavedPlacesBloc();
