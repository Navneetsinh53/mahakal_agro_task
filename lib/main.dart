import 'package:flutter/material.dart';
import 'package:mahakal_agro_task/dataModelContry.dart';
import 'package:mahakal_agro_task/helper.dart';
import 'package:mahakal_agro_task/location_utils.dart';
import 'package:mahakal_agro_task/utils/network_utils.dart';
import 'package:xml/xml.dart' as xml;
import 'package:dio/src/response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahakal Agro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mahakal Agro Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //  List<Country> filteredCountries = [];
  List<String> filteredCountries = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            searchWidget(context),
            ElevatedButton.icon(
                onPressed: fetchedLocation,
                icon: const Icon(Icons.location_pin),
                label: const Text(
                  'Click to fetch location',
                )),
          ],
        ),
      ),
    );
  }

  void fetchedLocation() async {
    
    var position = await LocationUtils().determinePosition();

    await Helper.saveData(Helper().keyLatitude, position.latitude);
    await Helper.saveData(Helper().keyLongitude, position.longitude);

    var latitude = await Helper.getData(Helper().keyLatitude);
    var longitude = await Helper.getData(Helper().keyLongitude);

    var baseURL = 'http://api.geonames.org/';
    var getContryCodeURL =
        '${baseURL}countryCode?lat=$latitude&lng=$longitude&username=medcollapp';
    // print('calling first API  $getContryCodeURL');
    // var response =  await NetworkUtils().getHttp('http://api.geonames.org/countryCode?lat=28.20562353723199&lng=76.8417607456597&username=medcollapp');
    var response = await NetworkUtils()
        .getHttp(getContryCodeURL, (dynamic error) => {showErrorMsg()});

    if (response.statusCode == 200) {
      var getCountryInfo =
          '${baseURL}countryInfo?country=${response.toString().trim()}&username=medcollapp';

      // var response1 =  await NetworkUtils().getHttp('http://api.geonames.org/countryInfo?country=IN&username=medcollapp');
      var response1 = await NetworkUtils()
          .getHttp(getCountryInfo, (dynamic error) => {showErrorMsg()});

      if (response1.statusCode == 200) {
        parseXmlResponse(response1);
      }
    }
  }

  Future<void> parseXmlResponse(Response response1) async {
    final document = xml.XmlDocument.parse(response1.toString());
    final countryElement = document.findAllElements('country').first;

    List<Country> countries = [];
    final country = Country(
      countryCode: countryElement.getElement('countryCode')?.text ?? '',
      countryName: countryElement.getElement('countryName')?.text ?? '',
      isoNumeric: countryElement.getElement('isoNumeric')?.text ?? '',
      isoAlpha3: countryElement.getElement('isoAlpha3')?.text ?? '',
      fipsCode: countryElement.getElement('fipsCode')?.text ?? '',
      continent: countryElement.getElement('continent')?.text ?? '',
      continentName: countryElement.getElement('continentName')?.text ?? '',
      capital: countryElement.getElement('capital')?.text ?? '',
      areaInSqKm: countryElement.getElement('areaInSqKm')?.text ?? '',
      population: countryElement.getElement('population')?.text ?? '',
      currencyCode: countryElement.getElement('currencyCode')?.text ?? '',
      languages: countryElement.getElement('languages')?.text ?? '',
      geonameId: countryElement.getElement('geonameId')?.text ?? '',
      west: countryElement.getElement('west')?.text ?? '',
      north: countryElement.getElement('north')?.text ?? '',
      east: countryElement.getElement('east')?.text ?? '',
      south: countryElement.getElement('south')?.text ?? '',
      postalCodeFormat:
          countryElement.getElement('postalCodeFormat')?.text ?? '',
    );

    setState(() {
      countries.add(country);
    });

//Save Countries into cache
    await Helper().saveCountriesToCache(Helper().KeyCountries, countries);

    // print('Country Code: ${country.countryCode}');
    // print('Country Name: ${country.countryName}');

//fetch Counries from cache
    var countriesStringList =
        await Helper().loadCountriesFromCache(Helper().KeyCountries);
    if (countriesStringList != null) {
      filteredCountries = countriesStringList;
    }
  }

//To Display Snack bar massage  
  showErrorMsg() {
    final snackBar = SnackBar(
      content: const Text('Something Wrong Please Try Again'),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// This Widget is used for Search
  Widget searchWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
          builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
        );
      }, suggestionsBuilder:
              (BuildContext context, SearchController controller) {
        filteredCountries;

        return List<ListTile>.generate(filteredCountries.length, (int index) {
          final String item = '${filteredCountries[index]}';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      }),
    );
  }
}
