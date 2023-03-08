import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:unicom_healthcare/entities/medication.dart';
import 'package:unicom_healthcare/screens/medication_details_screen.dart';
import 'package:unicom_healthcare/themes/healthcare/colors.dart';
import 'package:unicom_healthcare/utilities/api_fhir.dart';
import 'package:unicom_healthcare/utilities/locale_utils.dart';
import 'package:unicom_healthcare/widgets/accordions.dart';
import 'package:unicom_healthcare/widgets/accordions_tile.dart';
import 'package:unicom_healthcare/widgets/radio_buttons.dart';
import 'package:unicom_healthcare/widgets/buttons/primary_button.dart';

class SubstitutionListScreen extends StatefulWidget {
  static String route = '/substitution_list';
  const SubstitutionListScreen({Key? key}) : super(key: key);

  @override
  State<SubstitutionListScreen> createState() => _SubstitutionListScreenState();
}

class _SubstitutionListScreenState extends State<SubstitutionListScreen> {
  Timer? _timer;
  String searchInput = '';
  late TextEditingController controller;

  late Medication _medication;
  late List<Medication> _substitutions;
  late List<Medication> _filteredSubstitutions;

  late Map<String, Set<String>> filtersValues = {
    "administrableDoseForm": <String>{},
    "unitOfPresentation": <String>{},
    "routesOfAdministration": <String>{},
    "referenceStrength": <String>{},
  };

  late Map<String, dynamic> filters = {
    "administrableDoseForm": null,
    "unitOfPresentation": null,
    "routesOfAdministration": null,
    "referenceStrength": null,
  };

  late Map<String, String> filtersNames;

  bool substitutionInfoFetched = false;
  BuildContext? filterContext;
  List<ExpansionPanel> accordionItems = [];

  @override
  void didChangeDependencies() {
    Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (arguments.isEmpty) {
      return super.didChangeDependencies();
    }

    if (arguments['medication'] != null) _medication = arguments['medication'] as Medication;
    if (arguments['substitutions'] != null) {
      _substitutions = arguments['substitutions'] as List<Medication>;
      _fetchSubstitutionsInfo();
      applyFilters();
    }
    _initState();

    super.didChangeDependencies();
  }

  void _fetchSubstitutionsInfo() async {
    ApiFhir.getSubstitutionsMedications(medications: _substitutions).then((substitutions) {
      setState(() {
        _substitutions = substitutions;
        substitutionInfoFetched = true;
        if (filterContext != null){
          Navigator.pop(filterContext!);
          filterContext = null;
          showFiltersDialog(context);
        }
      });
    });
  }

  void _initState() {
    controller = TextEditingController(text: searchInput);
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    retrieveFiltersValues();
  }

  @override
  void dispose() {
    if(_timer != null) _timer!.cancel();
    super.dispose();
  }

  void removeFilters(){
    filters = {
      "administrableDoseForm": null,
      "unitOfPresentation": null,
      "routesOfAdministration": null,
      "referenceStrength": null,
    };
  }

  void resetFiltersValues(){
    filtersValues = {
      "administrableDoseForm": <String>{},
      "unitOfPresentation": <String>{},
      "routesOfAdministration": <String>{},
      "referenceStrength": <String>{},
    };
  }

  void applyFilters(){
    _filteredSubstitutions = _substitutions.where((Medication element) {
      bool res = true;
      if(searchInput.isNotEmpty && searchInput != '') {
        res &=
          element.name.toLowerCase().contains(searchInput.toLowerCase())
          || element.substanceName.toLowerCase().contains(searchInput.toLowerCase())
          || element.moietyName.toLowerCase().contains(searchInput.toLowerCase());
      }
      if(filters['administrableDoseForm'] != null) res &= filters['administrableDoseForm'] == element.administrableDoseForm;
      if(filters['unitOfPresentation'] != null) res &= filters['unitOfPresentation'] == element.productUnitOfPresentation;
      if(filters['routesOfAdministration'] != null) res &= filters['routesOfAdministration'] == element.routesOfAdministration;
      if(filters['referenceStrength'] != null) res &= filters['referenceStrength'] == element.referenceStrength;

      return res;
    }).toList();

  }

  void retrieveFiltersValues(){
    resetFiltersValues();
    for(Medication m in _substitutions){
      filtersValues['administrableDoseForm']!.add(m.administrableDoseForm);
      filtersValues['unitOfPresentation']!.add(m.productUnitOfPresentation);
      filtersValues['routesOfAdministration']!.add(m.routesOfAdministration);
      filtersValues['referenceStrength']!.add(m.referenceStrength);
    }
  }

  void generateFilterNames(){
    filtersNames = {
      "administrableDoseForm": LocaleUtils.translate(context).commons_AdministrableDoseForm,
      "unitOfPresentation": LocaleUtils.translate(context).commons_ProductUnitOfPresentation,
      "routesOfAdministration": LocaleUtils.translate(context).commons_RoutesOfAdministration,
      "referenceStrength": LocaleUtils.translate(context).commons_ReferenceStrength,
    };
  }

  @override
  Widget build(BuildContext context) {
    generateFilterNames();
    applyFilters();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleUtils.translate(context).substitutionListScreen_Appbar_Title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: buildHeader(context),
          ),
          buildSearchAndFilters(context),
          Divider(
            height: 20,
            thickness: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          // Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: buildSubstitutionList(context),
          // ),
          ...buildSubstitutionList(context),
        ],
      ),
    );
  }

  Widget buildSearchAndFilters(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      child: Row(
        children: [
          Expanded(child: buildInputWithTimer(context)),
          TextButton(
            onPressed: () => showFiltersDialog(context),
            child: Container(
              margin: const EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Theme.of(context).colorScheme.outline),
                shape: BoxShape.circle
              ),
              child: Icon(Icons.filter_list, color: Theme.of(context).colorScheme.outline),
            )
          )
        ],
      ),
    );
  }

  List<Widget> buildSubstitutionList(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
        child: Html(
            data: LocaleUtils.translate(context).substitutionListScreen_ResultsFound(_filteredSubstitutions.length),
            style: {"body": Style(fontSize: FontSize.medium)}
        ),
      ),
      Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(height: 1, color: dividerColor),
            ),
            itemCount: _filteredSubstitutions.length,
            itemBuilder: (context, index) {
              Medication medication = _filteredSubstitutions[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Image.asset("assets/images/placeholders/generic_drug.png", height: 35, width: 35, fit: BoxFit.fitHeight,),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    medication.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, MedicationDetailsScreen.route, arguments: {
                      'medication': _filteredSubstitutions[index],
                      'substitutionOf': _medication,
                    });
                  },
                ),
              );
            },
          ),
      ),
      )
    ];
  }

  Widget buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Text(
              LocaleUtils.translate(context).substitutionListScreen_Header_Text,
              style: Theme.of(context)!.textTheme.bodyMedium,
            )
        ),
        Text(
          _medication.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget buildInputWithTimer(BuildContext context){
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.outline),
    );

    return TextField(
      controller: controller,
      onChanged: (value) {
        searchInput = value;
        if(_timer != null && _timer!.isActive) { return; }
        else {
          _timer = Timer(const Duration(seconds: 1), () {
            setState(() {});
          });
        }
      },
      decoration: InputDecoration(
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        hintText: LocaleUtils.translate(context).substitutionListScreen_Search_Placeholder,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
    );
  }

  Widget buildBackdropFilter(BuildContext context, Widget content){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        scrollable: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  LocaleUtils.translate(context) .substitutionFilterDialog_Title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(
                width: 60,
                child: InkWell(
                    onTap: () {
                      removeFilters();
                      Navigator.of(context).pop();
                      filterContext = null;
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.clear, color: Theme.of(context).colorScheme.onSurface),
                    )
                ),
              ),
            ],
          ),
        ),

        content: content,
      ),
    );
  }
  void showFiltersDialog(BuildContext context){
    removeFilters();
    resetFiltersValues();
    retrieveFiltersValues();

    double padding = 20;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        filterContext = context;
        return !substitutionInfoFetched
          ? buildBackdropFilter(context,
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator()),
            ))
          : buildBackdropFilter(context,
              SizedBox(
                width: MediaQuery.of(context).size.width - padding*2,
                height: MediaQuery.of(context).size.height - padding*10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildAccordionsTile(context),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: PrimaryButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: Text(LocaleUtils.translate(context).button_save),
                      ),
                    )
                  ],
                )
            ),
        );
      }
    );
  }

  Widget buildAccordionItemTitle(String filterName, bool isExpanded){
    if (isExpanded){
      return Container(
        color: Colors.cyan[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                filtersNames[filterName]!,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            filtersNames[filterName]!,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
  AccordionItem buildFiltersAccordionItem(BuildContext context, String filterKey) {
    return AccordionItem(
        headerBuilder: (context, isExpanded){
          return buildAccordionItemTitle(filterKey, isExpanded);
        },
        body: buildFilterRadioButtons(context, filterKey),
        //closedBackgroundColor: Colors.cyan[100]
      );
  }

  Widget buildFilterRadioButtons(BuildContext context, String filterKey) {
    return Container(
      color: Colors.white,
      child: RadioButtons(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        radioButtonItems: {
          for (var filterValue in filtersValues[filterKey]!)
            filterValue : Text(
              filterValue,
              style: Theme.of(context).textTheme.bodyLarge,
            )
        } as LinkedHashMap<String, Widget>,
        selected: null,
        onChanged: (value) {
          filters[filterKey] = value;
        },
      ),
    );
  }
  
  Widget buildAccordionsTile(BuildContext context){
    return AccordionsTile(
      allowMultipleOpen: false,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 1,
        color: dividerColor,
      ),
      accordionItems: {
        for (var filterKey in filtersNames.keys!)
          filterKey : AccordionTileItem(
            title: Text(
              filtersNames[filterKey]!,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            backgroundColor: Colors.cyan[100],
            textColor: Colors.black,
            children: [buildFilterRadioButtons(context, filterKey)],

          )
      } as LinkedHashMap<String, AccordionTileItem>,
      selected: filtersNames.keys.first,
    );
  }
}
