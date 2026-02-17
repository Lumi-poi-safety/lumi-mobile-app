import 'package:lumi/features/in_app/models/poi_model.dart';

sealed class SearchState {
  const SearchState();
}

class SearchIdle extends SearchState {
  const SearchIdle();
}

class SearchLoading extends SearchState {
  final String requestId;
  const SearchLoading(this.requestId);
}

class SearchSuccess extends SearchState {
  final String requestId;
  final List<Poi> results;
  const SearchSuccess(this.requestId, this.results);
}

class SearchError extends SearchState {
  final String requestId;
  final String message;
  const SearchError(this.requestId, this.message);
}
