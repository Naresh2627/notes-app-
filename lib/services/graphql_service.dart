import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  late final GraphQLClient _client;

  GraphQLService() {
    final HttpLink httpLink = HttpLink(
      'http://localhost:4000/graphql', // Change port if your express server is different
    );

    _client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<Map<String, dynamic>?> getYoutubeData(String url) async {
    const String getYoutubeDataQuery = r'''
      query GetYoutubeData($url: String!) {
        getYoutubeData(url: $url) {
          title
          description
          thumbnail
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(getYoutubeDataQuery),
      variables: <String, dynamic>{
        'url': url,
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        return null;
      }

      return result.data?['getYoutubeData'];
    } catch (e) {
      print('Failed to fetch YouTube data: $e');
      return null;
    }
  }


}
