import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    requestTrackingPermission();
  }
  Future<void> requestTrackingPermission() async {
    final trackingStatus = await AppTrackingTransparency.requestTrackingAuthorization();
    // Handle different tracking statuses
    switch (trackingStatus) {
      case TrackingStatus.notDetermined:
        print('User has not yet decided');
        break;
      case TrackingStatus.denied:
        print('User denied tracking');
        break;
      case TrackingStatus.authorized:
        print('User granted tracking permission');
        break;
      case TrackingStatus.restricted:
        print('Tracking restricted');
        break;
      default:
        print('Unknown tracking status');
    }
  }

  Future<void> openPrivacyPolicy() async {
    const String privacyPolicyUrl =
        "https://asadarmantech.blogspot.com";
    if (await canLaunchUrl(Uri.parse(privacyPolicyUrl))) {
      await launchUrl(Uri.parse(privacyPolicyUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $privacyPolicyUrl';
    }
  }

  Future<void> openMoreApps() async {
    final String moreAppsUrl = Platform.isIOS?
    'https://apps.apple.com/us/developer/muhammad-asad-arman/id1487950157?see-all=i-phonei-pad-apps'
        :'';
    if (await canLaunchUrl(Uri.parse(moreAppsUrl))) {
      await launchUrl(Uri.parse(moreAppsUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $moreAppsUrl';
    }
  }
  void launchStoreReview() async {
    final url = Platform.isIOS
        ? 'https://apps.apple.com/us/app/advance-english-dictionary/1492444796'
        : '';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
