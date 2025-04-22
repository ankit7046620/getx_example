import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getx/common/import/common_getx.dart';
import 'package:getx/common/import/common_import.dart';
import 'package:getx/common/import/common_tg_utils.dart';
import 'package:getx/constant/app_const.dart';
import 'package:getx/manager/service_manger.dart';
import 'package:getx/request/login_request.dart';
import 'package:getx/response/login_response.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:techgrains/com/techgrains/service/request/tg_post_request.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool validateForm(GlobalKey<FormState> formKey) {
    final isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: (Platform.isAndroid) ? AppConstant.googleSignInClientIdAndroid : AppConstant.googleSignInClientIdIOS);

  //
  callLoginApi() async {
    EasyLoading.show(status: 'loading...');
    try {
      TGPostRequest request = LoginRequest(username: emailController.text, password: passwordController.text, deviceId: "ed", firebaseToken: "fwf");
      await ServiceManager.getInstance().login(
        request: request,
        onSuccess: (response) => onSuccessLogin(response),
        onError: (error) {},
        callAPIAgain: () {
          return TGLog.d("callAPIAgain");
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      update();
      TGLog.d("callLoginApi catch: $e");
    }
  }

  onSuccessLogin(LoginResponse response) async {
    EasyLoading.dismiss();
    update();
    TGLog.d("_onSuccessLogin:");
  }

  Future<bool> signInWithGoogle(context) async {
    EasyLoading.show(status: 'Signing in...');
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        EasyLoading.dismiss();
        return false;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      TGLog.d("Token is: ${googleAuth.idToken}");
      EasyLoading.dismiss();

      TGLog.d("GoogleSignIn...Token > ${googleAuth.idToken}");
      return true;
      //ADD YOUR API CALL HERE
    } catch (err) {
      EasyLoading.dismiss();
      TGLog.d("GoogleSignIn...Error > $err");
      return false;
    }
  }

  _gotoUserInfoScreen() {
    AppFunction.goToAndReplace(Routes.USER);
  }
}
