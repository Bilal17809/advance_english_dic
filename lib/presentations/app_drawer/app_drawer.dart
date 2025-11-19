import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../core/theme/app_colors.dart';
import '../ai_dictionary/view/ai_dictionary_page.dart';
import '../ai_translator/view/ai_translator_page.dart';
import '../conversations/view/conversation_page.dart';
import '../favrt/view/favrt_page.dart';
import '../home/contrl/home_contrl.dart';
import '../remove_ads_contrl/remove_ads_contrl.dart';
import '../subscription/subscription_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController=Get.put(HomeController());
    final RemoveAds removeAds=Get.put(RemoveAds());

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            child: Row(
              children: [
                Image.asset("assets/app_icon.png",height:65,width:65,),
                const SizedBox(width: 12),
                Flexible(
                  child: const Text(
                    'Advance Dictionary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Image.asset("assets/book-2.png",height:30,width: 30,),
            title:  Text('AI Dictionary',style:context.textTheme.titleSmall,),
            onTap: () {
              Get.to(AiDictionaryPage());
            },
          ),
          ListTile(
            leading:  Image.asset("assets/translate.png",height:30,width: 30,),
            title:  Text('Speak and Translate',style:context.textTheme.titleSmall,),
            onTap: () {
              Get.to(AiTranslatorPage());
            },
          ),
          ListTile(
            leading:  Image.asset("assets/statistics.png",height:30,width:30,),
            title:  Text('Conversations',style:context.textTheme.titleSmall,),
            onTap: () {
              Get.to(ConversationPage());
            },
          ),

          Divider(color: greyBorderColor,),
          ListTile(
            leading: Image.asset("assets/privacy.png",
              height:30,width: 30,color: skyTextColor,),
            title: const Text('Privacy Policy'),
            onTap: () {
              homeController.openPrivacyPolicy();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:  Image.asset("assets/rating.png",
              height:30,width: 30,color: skyTextColor,),
            title: const Text('Rate Us'),
            onTap: () {
              homeController.launchStoreReview();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:  Image.asset("assets/more_app.png",
              height:30,width:30,color: skyTextColor,),
            title: const Text('More Apps'),
            onTap: () {
              homeController.openMoreApps();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:Image.asset("assets/sub1.png",
                height:32,
                width:32,
              color: skyTextColor,
            ),
            title: removeAds.isSubscribedGet.value ?
            Text('Ads Free Version!', style:context.textTheme.labelMedium):
            Text('Remove Ads', style: context.textTheme.labelMedium),
            onTap: () {
              Get.to(Subscriptions());
            },
          ),
          ListTile(
            leading:  Icon(Icons.star_border,size: 30,color: skyTextColor,),
            title: const Text('Favorite'),
            onTap: () {
              Get.to(FavrtPage());
            },
          ),
        ],
      ),
    );
  }
}
