import 'package:flutter/material.dart';
import 'package:second_flutter_app/constants/app_gradients.dart';
import 'package:second_flutter_app/models/company.dart';

class Companies {
  final List<Company> companies = <Company>[
    Company(
        name: 'stratpoint',
        description: 'Fast forward to the future',
        descriptionGradient: AppGradients.stratpointGradient,
        nameGradient: AppGradients.stratpointGradient,
        splitNameGradient: true),
    Company(name: 'Google', description: 'Search on', nameGradient: AppGradients.googleGradient, descriptionGradient: AppGradients.defaultWhite),
    Company(
        name: 'SAMSUNG',
        description: 'TURN ON TOMORROW',
        nameGradient: LinearGradient(colors: <Color>[Colors.white, Colors.white]),
        descriptionGradient: AppGradients.samsungGradient),
    Company(name: 'Apple', description: 'Think different', nameGradient: AppGradients.appleGradient, descriptionGradient: AppGradients.defaultWhite),
    Company(name: 'Tencent', description: 'Spark more', nameGradient: AppGradients.tencentGradient, descriptionGradient: AppGradients.defaultWhite),
    Company(
        name: 'Microsoft',
        description: 'Be what\'s Next',
        nameGradient: AppGradients.defaultWhite,
        descriptionGradient: AppGradients.microsoftGradient)
  ];
}
