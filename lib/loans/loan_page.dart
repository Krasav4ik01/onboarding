import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onboarding/loans/loan_bloc.dart';

import '../widgets/app_bar_wirh_logo_widget.dart';
import '../widgets/frame_to_input_text/theme_helper.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPage();
}

class _LoanPage extends State<LoanPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoanBloc(),
      child: LoanView(),
    );
  }
}

class LoanView extends StatefulWidget{
  @override
  State<LoanView> createState() => _LoanViewState();
}

class _LoanViewState extends State<LoanView> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoanBloc>();
    return Scaffold(


      body: Stack(
        children: [
          Positioned(
            top: 0.h,
            left: 0.h,
            width: 360.w,
            height: 400.h,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1D1E23),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: const Center(
                child: AppBarWithLogoWidget(text: ""),
              ),
            ),
          ),
          Positioned(
            top: 200.h,
            left: 25.h,
            width: 315.w,
            height: 400.h,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black87,
                        offset: Offset(0, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.fromLTRB(30, 20, 30, 20).r,
                          child: TextFormField(
                            decoration: ThemeHelper()
                                .textInputDecoration('Email', 'Enter your email'),
                            controller: emailController,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 20).r,
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'Password', 'Enter your password'),
                            controller: passwordController,
                          ),
                        ),
                        BlocListener<LoanBloc, LoanState>(
                          listener: (BuildContext context, state) {
                            final myState = state as InitialLoanState;
                            final navigatorFunction = myState.navigatorFunction;
                            if (navigatorFunction != null) {
                              navigatorFunction();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0).r,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.black87,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40.h, vertical: 20.h),
                                  textStyle: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                // handle button press
                                print('Hello!');
                                bloc.add(TryLoanAction(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  context: context,
                                ));
                              },
                              child: const Text('Log in'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}