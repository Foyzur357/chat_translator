import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_translator/components/default_container.dart';
import 'package:chat_translator/components/default_navbar.dart';
import 'package:chat_translator/models/search_result.dart';
import 'package:chat_translator/providers/search_provider.dart';
import 'package:chat_translator/router/routes.dart';
import 'package:chat_translator/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:selection_dialogs/country_selector_dialog.dart';
import 'package:selection_dialogs/gender_selector_dialog.dart';
import 'package:selection_dialogs/language_selector_dialog.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchProvider searchProvider = Provider.of<SearchProvider>(context);
    Map<String, dynamic> searchParameters = searchProvider.searchParameters;
    List<SearchResultObject> searchResults = searchProvider.searchResultList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // shadowColor: Colors.grey.withOpacity(0.2),
        title: const Text(
          "Search",
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              if (!searchProvider.showSearchResults) {
                return;
              }
              searchProvider.showSearchOptions = !searchProvider.showSearchOptions;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                searchProvider.showSearchOptions ? Icons.expand_less : Icons.expand_more,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            searchProvider.showSearchOptions ? _buildSearchOptions(context, searchProvider, searchParameters) : Container(),
            searchProvider.showSearchOptions ? SizedBox(height: 10.h) : Container(),
            searchProvider.showSearchResults ? _buildSearchResults(searchResults) : Container(),
          ],
        ),
      ),
      bottomNavigationBar: DefaultNavBar(
        initialActiveIndex: 1,
      ),
    );
  }

  Expanded _buildSearchResults(List<SearchResultObject> searchResults) {
    return Expanded(
      child: DefaultContainer(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: searchResults.length,
          // prototypeItem: ListTile(
          //   title: Text(items.first),
          // ),
          itemBuilder: (context, index) {
            return DefaultContainer(
              onTap: () {
                Navigator.pushNamed(context, Routes.getOthersProfileScreenRoute(searchResults[index].userId));
              },
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.primaryColor,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: "https://picsum.photos/200",
                        fit: BoxFit.cover,
                        width: 48,
                        height: 48,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        searchResults[index].name,
                        style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Text(
                              "Native: ${searchResults[index].nativeLanguage}",
                              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Text(
                              "Learning: ${searchResults[index].learningLanguage}",
                              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  DefaultContainer _buildSearchOptions(BuildContext context, SearchProvider searchProvider, Map<String, dynamic> searchParameters) {
    return DefaultContainer(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          DefaultContainer(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return GenderSelector(
                    onTap: (gender) {
                      searchProvider.searchParameters = {
                        "gender": gender,
                      };
                    },
                  );
                },
              );
            },
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Gender :"),
                Text(searchParameters["gender"] != "" ? searchParameters["gender"] : "Select Gender"),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          DefaultContainer(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LanguageSelector(
                    onTap: (language) {
                      searchProvider.searchParameters = {
                        "native_lang": language.name,
                      };
                    },
                  );
                },
              );
            },
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Native :"),
                Text(searchParameters["native_lang"] != "" ? searchParameters["native_lang"] : "Select Language"),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          DefaultContainer(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LanguageSelector(
                    onTap: (language) {
                      searchProvider.searchParameters = {
                        "learning_lang": language.name,
                      };
                    },
                  );
                },
              );
            },
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Learning :"),
                Text(searchParameters["learning_lang"] != "" ? searchParameters["learning_lang"] : "Select Language"),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          DefaultContainer(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CountrySelector(
                    onTap: (country) {
                      searchProvider.searchParameters = {
                        "country": country.name,
                      };
                    },
                  );
                },
              );
            },
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Country :"),
                Text(searchParameters["country"] != "" ? searchParameters["country"] : "Select Country"),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultContainer(
                onTap: () {
                  searchProvider.searchParameters = {
                    "gender": "",
                    "native_lang": "",
                    "learning_lang": "",
                    "country": "",
                  };
                  searchProvider.optionsSelected = false;
                },
                padding: EdgeInsets.all(10),
                child: Text(
                  "Clear",
                  style: TextStyle(color: searchProvider.optionsSelected ? AppColors.errorColor : Colors.grey),
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              DefaultContainer(
                onTap: () {
                  if (!searchProvider.optionsSelected) {
                    final snackBar = SnackBar(
                      backgroundColor: AppColors.errorColor,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Select search options",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 16.h,
                          )
                        ],
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  searchProvider.showSearchOptions = false;
                  searchProvider.showSearchResults = true;
                  searchProvider.performSearch();
                },
                padding: EdgeInsets.all(10),
                child: Text(
                  "Search",
                  style: TextStyle(color: searchProvider.optionsSelected ? AppColors.primaryColor : Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
