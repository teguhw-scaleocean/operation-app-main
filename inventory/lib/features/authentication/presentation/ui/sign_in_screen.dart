import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/shared_libraries/utils/validate_field_helper.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../domains/auth/domain/entity/request/auth_request_entity.dart';
import '../../../../injections/injections.dart';
import '../../../../shared_libraries/common/constants/resource_constants.dart';
import '../../../../shared_libraries/common/state/view_data_state.dart';
import '../../../../shared_libraries/common/theme/theme.dart';
import '../../../../shared_libraries/component/custom_form.dart';
import '../../../../shared_libraries/component/primary_button.dart';
import '../bloc/sign_in_bloc.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  /// User's registered email field [emailController]
  final emailController = TextEditingController();

  /// User's password field [passwordController]
  final passwordController = TextEditingController();

  /// Company name field of the user [serverController]
  final serverController = TextEditingController();

  /// Manage configuration like base_url based on [serverController] value
  final Dio _dio = sl();

  /// Domain name to set the base url
  String _domain = "";

  /// Database name to selected Database
  String _database = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) async {
          /// Status of sign-in state [status]
          final status = state.signInDataState.status;

          if (status.isHasData) {
            Future.delayed(const Duration(seconds: 1), () {
              var successSnackBar = SnackBar(
                  content: Text('Successfully logged in',
                      style: BaseText.whiteText14));
              ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
            }).then((value) async => await Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.home, (route) => false,
                arguments: true));
          } else if (status.isError) {
            Future.delayed(const Duration(seconds: 1), () {
              var successSnackBar = SnackBar(
                  duration: const Duration(seconds: 2),
                  content: Text(
                      state.signInDataState.failure?.errorMessage ??
                          state.signInDataState.message,
                      style: BaseText.whiteText14));
              ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
            });
          }
        },
        builder: (context, state) {
          return SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 83),
                    Image.asset(const AssetConstans().signIn,
                        height: 202, width: 271),
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Server', style: BaseText.blackText12),
                        const SizedBox(height: 5),
                        StatefulBuilder(builder: (context, newSetState) {
                          return SizedBox(
                            child: FocusScope(
                              child: Focus(
                                child: TextFormField(
                                  controller: serverController,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      newSetState(() {
                                        _domain = "https://$value";
                                        _dio.options.baseUrl = _domain;
                                        _database = value;

                                        log(_domain.toString());
                                      });
                                    }
                                  },
                                  onTapOutside: (event) => FocusManager
                                      .instance.primaryFocus!
                                      .unfocus(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) => ValidateFieldHelper()
                                      .validateField(value, false, false),
                                  decoration: InputDecoration(
                                    hintText: 'eg: company.scaleocean.app',
                                    hintStyle: BaseText.greyText12
                                        .copyWith(fontWeight: BaseText.medium),
                                    hintTextDirection: TextDirection.ltr,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    contentPadding: const EdgeInsets.all(12),
                                    hoverColor: ColorName.mainColor,
                                    focusColor: ColorName.mainColor,
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                            color: ColorName.mainColor)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 5),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomFormField(
                      title: 'Email',
                      hintText: 'Masukkan email anda',
                      controller: emailController,
                      isShowTitle: true,
                    ),
                    const SizedBox(height: 16),
                    CustomFormPassword(
                      title: 'Password',
                      hintText: 'Masukan katasandi anda',
                      controller: passwordController,
                      isShowTitle: true,
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 40),
                    BlocBuilder<SignInBloc, SignInState>(
                      builder: (context, state) {
                        final status = state.signInDataState.status;

                        if (status.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: ColorName.mainColor,
                            ),
                          );
                        } else if (status.isHasData) {
                          return const SizedBox();
                        } else {
                          /// Sign in [SignInBloc] with an event.
                          return InkWell(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<SignInBloc>().add(
                                      /// Parsing data email, password, also _database name
                                      /// from each textfield.
                                      /// Then assigning it to an Object AuthRequestEntity.
                                      SignIn(
                                        authRequest: AuthRequestEntity(
                                          jsonrpc: "2.0",
                                          params: ParamsEntity(
                                            login: emailController.text,
                                            password: passwordController.text,
                                            db: _database,
                                          ),
                                        ),
                                      ),
                                    );
                              }
                            },
                            child: PrimaryButton(
                              height: 50,
                              width: double.infinity,
                              title: 'Masuk',
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                          const AssetConstans().signInLogoBottom),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
