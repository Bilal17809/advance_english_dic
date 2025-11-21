import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/adds/binner_adds.dart';
import '/adds/instertial_adds.dart';
import '/adds/native_adss.dart';
import '/adds/open_screen.dart';
import '/core/common_widgets/animated_card.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/icon_buttons.dart';
import '/core/constant/constant.dart';
import '/core/theme/app_styles.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../contrl/conversation_contrl.dart';

class ConversationPage extends StatefulWidget {
  @override
  State<ConversationPage> createState() => _ConversationPageState();
}
class _ConversationPageState extends State<ConversationPage> {
  final List<String> categories = [
    'Communication',
    'Eating',
    'Emotions',
    'Fashion',
    'Friendship',
    'Health',
    'Housing',
    'Life',
    'Memory',
    'Money',
    'Shopping',
    'Time',
    'Traveling',
    'Vacation',
    'Weather',
    'Work'
  ];
  final Map<String, String> categoryImages = {
    'Communication': 'assets/conversation.png',
    'Eating': 'assets/healthy-food.png',
    'Emotions': 'assets/feedback.png',
    'Fashion': 'assets/fashion.png',
    'Friendship': 'assets/friendship.png',
    'Health': 'assets/healthy-food.png',
    'Housing': 'assets/house.png',
    'Life': 'assets/life.png',
    'Memory': 'assets/memory.png',
    'Money': 'assets/money.png',
    'Shopping': 'assets/shop.png',
    'Time': 'assets/work_time.png',
    'Traveling': 'assets/clock.png',
    'Vacation': 'assets/abroad.png',
    'Weather': 'assets/cloud.png',
    'Work': 'assets/dictionary.png',
  };


  final controller = Get.put(ConversationController());
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

  @override
  void initState() {
    super.initState();
    controller.fetchAllConversations();
    if (!removeAds.isSubscribedGet.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        interstitialAdController.checkAndShowAd();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      "Conversations",
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
              decoration: roundedDecoration.copyWith(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: GridView.builder(
                  itemCount: categoryImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // two columns
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final imagePath = categoryImages[category] ?? 'assets/categories/default.png';
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ConversationDetailPage(category: category));
                        },
                        child: Card(
                          color: Colors.blue[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                imagePath,
                                height: 55,
                                width: 55,
                              ),
                              SizedBox(height: 8),
                              Text(
                                category,
                                style: context.textTheme.labelMedium?.copyWith(
                                  color: Colors.white
                                )
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final interstitial = Get.find<InterstitialAdController>();
        return interstitial.isAdReady.value
            ? const SizedBox()
            :  BannerAdWidget();
      }),
    );
  }
}





class ConversationDetailPage extends StatefulWidget {
  final String category;

  const ConversationDetailPage({required this.category});

  @override
  _ConversationDetailPageState createState() => _ConversationDetailPageState();
}
class _ConversationDetailPageState extends State<ConversationDetailPage> with
    TickerProviderStateMixin {
  final controller = Get.find<ConversationController>();
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

  List<AnimationController> controllers = [];
  List<Animation<Offset>> slideAnimations = [];
  List<Animation<double>> fadeAnimations = [];

  int visibleCards = 0;

  @override
  void initState() {
    super.initState();
    controller.filterByCategory(widget.category);
    if (!removeAds.isSubscribedGet.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        interstitialAdController.checkAndShowAd();
      });
    }
  }

  void initAnimations(int count) {
    controllers.forEach((c) => c.dispose());
    controllers = List.generate(count, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    slideAnimations = List.generate(count, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controllers[index],
        curve: Curves.easeOut,
      ));
    });

    fadeAnimations = List.generate(count, (index) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: controllers[index],
        curve: Curves.easeIn,
      ));
    });

    visibleCards = 0;
    playAnimationsSequentially(0);
  }

  void playAnimationsSequentially(int index) async {
    if (index >= controllers.length) return;

    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      visibleCards++;
    });

    await controllers[index].forward();

    playAnimationsSequentially(index + 1);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundCircles(),
          Positioned(
            top: 50,
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
                      widget.category,
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
            padding:  EdgeInsets.only(top:90, left: 12, right: 12,),
            child: Container(
              decoration: roundedDecoration.copyWith(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
              ),
              padding: const EdgeInsets.all(8),
              child: Obx(() {
                final list = controller.filteredConversations;

                if (list.isEmpty) {
                  return Center(child: Text("No conversations found for ${widget.category}."));
                }
                if (controllers.length != list.length) {
                  initAnimations(list.length);
                }
                const int adInterval = 5;
                final int originalListCount = list.length;
                final int adCount = (originalListCount / adInterval).floor();
                final int totalItems = originalListCount + adCount;

                return Column(
                  children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: totalItems,
                    itemBuilder: (context, index) {
                      if (index ==2 && !interstitialAdController.isAdReady.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: NativeAdWidget(),
                        );
                      } else {
                        final int listIndex = index - (index ~/ adInterval);
                        final convo = list[listIndex];
                        return FadeTransition(
                          opacity: fadeAnimations[listIndex],
                          child: SlideTransition(
                            position: slideAnimations[listIndex],
                            child: AnimatedForwardCard(
                              title: convo.title ?? 'No Title',
                              onTap: () {
                                Get.to(() => ChatMessagePage(
                                  title: convo.title ?? '',
                                  conversation: convo.conversation ?? '',
                                ));
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: visibleCards,
                    //     itemBuilder: (context, index) {
                    //       final convo = list[index];
                    //
                    //       return FadeTransition(
                    //         opacity: fadeAnimations[index],
                    //         child: SlideTransition(
                    //           position: slideAnimations[index],
                    //           child: AnimatedForwardCard(
                    //             title: convo.title ?? 'No Title',
                    //             onTap: () {
                    //               Get.to(() => ChatMessagePage(
                    //                 title: convo.title ?? '',
                    //                 conversation: convo.conversation ?? '',
                    //               ));
                    //             },
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    SizedBox(height:12,)
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}


class ChatMessagePage extends StatefulWidget {
  final String title;
  final String conversation;

  ChatMessagePage({required this.title, required this.conversation});

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

  @override
  void initState() {
    super.initState();
    if (!removeAds.isSubscribedGet.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        interstitialAdController.checkAndShowAd();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = _splitConversationByTilde(widget.conversation);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundCircles(),
          Positioned(
            top: 50,
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
                      "Conversations",
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
            padding: EdgeInsets.only(top: 90, left: kBodyHp, right: kBodyHp),
            child: Container(
              decoration: roundedDecoration,
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isSenderA = msg['sender'] == 'A';

                  return Align(
                    alignment: isSenderA ? Alignment.centerLeft : Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: isSenderA ? MainAxisAlignment.start : MainAxisAlignment.end,
                      children: [
                        if (isSenderA) ...[
                          _buildImageAvatar('assets/businessman.png'),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: isSenderA ? Colors.grey[300] : Colors.green[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              msg['text'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        if (!isSenderA) ...[
                          const SizedBox(width: 8),
                          _buildImageAvatar('assets/businessman.png'),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final interstitial = Get.find<InterstitialAdController>();
        return interstitial.isAdReady.value
            ? const SizedBox()
            :  BannerAdWidget();
      }),
    );
  }

  List<Map<String, dynamic>> _splitConversationByTilde(String conversation) {
    final parts = conversation.split('~').map((e) => e.trim()).where((e) => e.isNotEmpty);

    List<Map<String, dynamic>> messages = [];
    bool isSenderA = true;

    for (final part in parts) {
      messages.add({
        'text': part,
        'sender': isSenderA ? 'A' : 'B',
      });
      isSenderA = !isSenderA;
    }

    return messages;
  }

  Widget _buildImageAvatar(String imagePath) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage(imagePath),
    );
  }
}


