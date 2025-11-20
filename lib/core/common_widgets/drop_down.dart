import 'package:electricity_app/core/common_widgets/textform_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_flags/country_flags.dart';
import '../../example/contrl.dart';
import '../constant/constant.dart';
import '../theme/app_styles.dart';
import 'bg_circular.dart';
import 'country_flag.dart';
import 'icon_buttons.dart';


class LanguagesSelection extends StatelessWidget {
  final bool isFirst;

  const LanguagesSelection({super.key, this.isFirst = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ConversationController>();
    final TextEditingController searchController = TextEditingController();
    final RxString searchQuery = ''.obs;

    final allLanguages = languageCodesC.keys.toList();

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundCircles(),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackIconButton(),
                  ),
                  Center(
                    child: Text(
                      "Select Language",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(top:90, left: kBodyHp, right: kBodyHp),
            child: Container(
              decoration: roundedDecoration,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    decoration: roundedDecoration,
                    padding: const EdgeInsets.all(10),
                    child: CustomTextFormField(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search Country',
                      controller: searchController,
                      textAlign: TextAlign.start,
                        onChanged: (value) => searchQuery.value = value.toLowerCase()
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                  Row(
                    children: [
                      Text("Selected Language",
                          style:context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w400,
                            fontSize: 17
                          )
                      ),
                    ],
                  ),
                  Obx(() {
                    final selected = isFirst
                        ? controller.selectedLanguageC1.value
                        : controller.selectedLanguageC2.value;

                    if (selected.isEmpty) return SizedBox.shrink();

                    final code = languageFlags[selected] ?? 'US';

                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CountryFlag.fromCountryCode(code, height: 20, width: 30),
                              SizedBox(width: 10),
                              Text(
                                selected,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Radio<String>(
                            value: selected,
                            groupValue: selected,
                            onChanged: null,
                            fillColor: MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.blue;
                                }
                                return Colors.grey;
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Divider(color: Colors.grey.shade300,),
                  Expanded(
                    child: Obx(() {
                      final filteredLanguages = allLanguages
                          .where((lang) => lang.toLowerCase().contains(searchQuery.value))
                          .toList();

                      return ListView.builder(
                        itemCount: filteredLanguages.length,
                        itemBuilder: (context, index) {
                          final lang = filteredLanguages[index];
                          final code = languageFlags[lang] ?? 'US';

                          return ListTile(
                            leading: CountryFlag.fromCountryCode(code, height: 20, width: 30),
                            title: Text(lang),
                            onTap: () async {
                              if (isFirst) {
                                controller.selectedLanguageC1.value = lang;
                                await controller.saveSelectedCountry('selectedCountry1', lang);
                              } else {
                                controller.selectedLanguageC2.value = lang;
                                await controller.saveSelectedCountry('selectedCountry2', lang);
                              }
                              Get.back();
                            },

                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

