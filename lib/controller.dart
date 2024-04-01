import 'package:api/model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyController extends StatefulWidget {
  @override
  _MyControllerState createState() => _MyControllerState();
}

class _MyControllerState extends State<MyController> {
  late Future<APIFetch> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<APIFetch> fetchData() async {
    final response = await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return APIFetch.fromJson(jsonData);
    } else {
      throw Exception('Failed to load api data: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('My Data Controller',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: FutureBuilder<APIFetch>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final apiFetch = snapshot.data!;
              return ListView.builder(
                itemCount: apiFetch.data!.length,
                itemBuilder: (context, index) {
                  final data = apiFetch.data![index];
                  return ListTile(
                    title: Text(data.name ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Symbol: ${data.symbol ?? ''}'),
                        Text('Rank: ${data.rank ?? ''}'),
                        Text('Rank: ${data.id ?? ''}'),
                        Text('Price (USD): ${data.priceUsd ?? ''}'),
                        Text('Price (BTC): ${data.priceBtc ?? ''}'),
                        Text('Market Cap (USD): ${data.marketCapUsd ?? ''}'),
                        Text('24h Change: ${data.percentChange24h ?? ''}%'),
                        Text('1h Change: ${data.percentChange1h ?? ''}%'),
                        Text('7d Change: ${data.percentChange7d ?? ''}%'),
                        Text('24h Volume: ${data.volume24 ?? ''}'),
                        Text('Circulating Supply: ${data.csupply ?? ''}'),
                        Text('Total Supply: ${data.tsupply ?? ''}'),
                        Text('Max Supply: ${data.msupply ?? ''}'),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
