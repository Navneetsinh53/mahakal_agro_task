import 'package:mahakal_agro_task/dataModelContry.dart';
import 'package:shared_preferences/shared_preferences.dart';

///This class is created for using shared preference
class Helper {
// static String valueSharedPreferences = '';

final String keyLatitude = 'latitude';
final String keyLongitude = 'longitude';
final String KeyCountries = 'countries';

// Write DATA
static Future<bool> saveData(key , value) async {
	SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
	return await sharedPreferences.setDouble(key, value);
}

// Read Data
static Future getData(key) async {
	SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
	return sharedPreferences.getDouble(key);
}

Future<void> saveCountriesToCache(Key, List<Country> countries) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final List<String> countriesStringList =
        countries.map((country) => country.toMap().toString()).toList();
    sharedPreferences.setStringList(Key, countriesStringList);
  }

  Future<List<String>?> loadCountriesFromCache(Key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final List<String>? countriesStringList = sharedPreferences.getStringList(Key);
return countriesStringList;

//     List<Country> countries = [];
//  if (countriesStringList != null) {
//         countries = countriesStringList
//             .map((countryString) =>
//                 Country.fromMap(Map<String, dynamic>.from(
//                     Map<String, dynamic>.fromIterable(
//                         countryString.split(',').map((e) => e.trim()),
//                         key: (dynamic k) => k.toString(),
//                         value: (dynamic v) => v.toString()))))
//             .toList();
//     }
//   return countries;

  }

}
