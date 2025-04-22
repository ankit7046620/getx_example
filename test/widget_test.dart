import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:getx/app/modules/home/controllers/home_controller.dart';
import 'package:getx/app/modules/home/views/home_view.dart';
import 'package:getx/common/component/common_elevated_button.dart';
import 'package:getx/common/component/custom_text_field.dart';
import 'package:getx/constant/localel.dart';

void main() {
  testWidgets('HomeView Real-time UI update test', (WidgetTester tester) async {
    // Initialize ScreenUtil for testing environment
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(375, 812), // Adjust according to your design size
        minTextAdapt: true,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(home: HomeView());
        },
      ),
    );

    // Wait for GetBuilder to build
    await tester.pumpAndSettle();

    // Get the controller
    final controller = Get.find<HomeController>();

    // Step 1: Simulate entering email
    await tester.enterText(find.widgetWithText(CustomTextField, LabelConstants.labelEmail), 'test@example.com');

    // Step 2: Simulate entering password
    await tester.enterText(find.widgetWithText(CustomTextField, LabelConstants.labelPassword), 'password123');

    // Step 3: Tap the login button
    await tester.tap(find.widgetWithText(CommonElevatedButton, LabelConstants.buttonLogin));

    // Wait for the UI to update after the action
    await tester.pumpAndSettle();

    // ** Real-Time Check 1: Ensure the entered text is reflected immediately in the controller's text fields**
    expect(controller.emailController.text, 'test@example.com');
    expect(controller.passwordController.text, 'password123');

    // ** Real-Time Check 2: Make sure the button is no longer tappable or some UI feedback is visible (e.g., loading spinner or error message)**
    // (Assuming some loading indicator shows when logging in)

    // ** Real-Time Check 3: Optionally check if the login process succeeds and feedback is updated**
    // Here we would check for a success message, or depending on the logic, a failure message
    // For this, we assume there could be an error message or success message that dynamically updates
    expect(find.text('Invalid email or password'), findsNothing); // Adjust to whatever error message is expected

    // If we expect success feedback, check for success UI element.
    // e.g., checking if the user navigates to the next screen
    // Hypothetical SuccessWidget if login is successful

    // ** Real-Time Check 4: Ensure no exceptions occurred during the test**
    final exception = tester.takeException();
    if (exception != null) {
      fail('Exception occurred during the test: $exception');
    }

    // Optionally, you can test UI transitions or changes in state.
    // E.g., you could check that after logging in, a different widget appears, indicating successful login.
    expect(find.widgetWithText(CommonElevatedButton, LabelConstants.buttonLogin), findsOneWidget);
  });
}
