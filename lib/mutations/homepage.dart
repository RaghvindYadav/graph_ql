import 'package:flutter/material.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../Configuration/conf.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String query = """query lookupCustomerOrder {
  customer {
    first_name
    email
  }
}""";
  bool value = false;

  void changeData() {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return GraphQLProvider(
        client: client,
        child: Scaffold(
            appBar: AppBar(
              title: Text("GraphlQL Client"),
            ),
            floatingActionButton:
                SpeedDial(child: Icon(Icons.widgets), speedDialChildren: [
              SpeedDialChild(
                  child: const Icon(Icons.insert_chart),
                  label: 'Add Data',
                  onPressed: () async {
                    final refresh =
                        await Navigator.pushNamed(context, '/AddData');
                    if (refresh == 'refresh') {
                      print('1');
                      changeData();
                      print('2');
                    }
                  }),
              SpeedDialChild(
                  child: const Icon(Icons.update),
                  label: 'Update Data',
                  onPressed: () async {
                    final refresh =
                        await Navigator.pushNamed(context, '/UpdateData');
                    if (refresh == 'refresh') {
                      changeData();
                    }
                  }),
              SpeedDialChild(
                  child: const Icon(Icons.delete),
                  label: 'Delete Data',
                  onPressed: () async {
                    final refresh =
                        await Navigator.pushNamed(context, '/DeleteData');
                    if (refresh == 'refresh') {
                      changeData();
                    }
                  }),
              SpeedDialChild(
                  child: const Icon(Icons.refresh),
                  label: 'Refresh',
                  onPressed: () async {
                    Navigator.popAndPushNamed(context, '/');
                  }),
            ]),
            body: value
                ? Query(
                    options: QueryOptions(
                      document: gql(
                          query), // this is the query string you just created
                    ),
                    // Just like in apollo refetch() could be used to manually trigger a refetch
                    // while fetchMore() can be used for pagination purpose
                    builder: (QueryResult result,
                        {VoidCallback? refetch, FetchMore? fetchMore}) {
                      // print('result ${result.data}');
                      if (result.hasException) {
                        print('hasException');
                        return Text(result.exception.toString());
                      }

                      if (result.isLoading) {
                        return const Text('Loading');
                      }

                      List? repositories = result.data?['customer'];
                      // print('rep $repositories');

                      if (repositories == null) {
                        return const Text('No repositories');
                      }

                      return ListView.builder(
                        itemCount: repositories.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(repositories[index]['first_name']),
                            subtitle: Text(repositories[index]['email']),
                          );
                        },
                      );
                    },
                  )
                : Query(
                    options: QueryOptions(
                      document: gql(
                          query), // this is the query string you just created
                    ),
                    // Just like in apollo refetch() could be used to manually trigger a refetch
                    // while fetchMore() can be used for pagination purpose
                    builder: (QueryResult result,
                        {VoidCallback? refetch, FetchMore? fetchMore}) {
                      // print('result ${result.data}');
                      if (result.hasException) {
                        print('hasException');
                        return Text(result.exception.toString());
                      }

                      if (result.isLoading) {
                        return const Text('Loading');
                      }

                      List? repositories = result.data?['customer'];
                      // print('rep $repositories');

                      if (repositories == null) {
                        return const Text('No repositories');
                      }

                      return ListView.builder(
                        itemCount: repositories.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(repositories[index]['first_name']),
                            subtitle: Text(repositories[index]['email']),
                          );
                        },
                      );
                    },
                  )));
  }
}
