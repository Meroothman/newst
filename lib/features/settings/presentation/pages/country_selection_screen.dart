import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../cubit/settings_cubit.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  String? selectedCountry;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    final state = context.read<SettingsCubit>().state;
    if (state is SettingsLoaded) {
      selectedCountry = state.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCountries = AppConstants.countries.entries
        .where((entry) =>
            entry.value.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your country'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final entry = filteredCountries[index];
                //final isSelected = selectedCountry == entry.key;

                return ListTile(
                  title: Text(entry.value),
                  trailing: Radio<String>(
                    value: entry.key,
                    groupValue: selectedCountry,
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                      });
                    },
                    activeColor: AppColors.primaryRed,
                  ),
                  onTap: () {
                    setState(() {
                      selectedCountry = entry.key;
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedCountry != null) {
                    context.read<SettingsCubit>().changeCountry(selectedCountry!);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}