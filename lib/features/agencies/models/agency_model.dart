import 'package:flutter/material.dart';

class AgencyModel {
  final String agencyName;
  final String? agencyOwnerName;
  final String agencyImage;
  final String agencyDefinition;
  final String? agencyOwnerMail;
  final String? agencyCountry;
  final List? agencyHosts;

  AgencyModel(
      {required this.agencyName,
      @required this.agencyOwnerName,
      required this.agencyImage,
      required this.agencyDefinition,
      @required this.agencyOwnerMail,
      @required this.agencyCountry,
      @required this.agencyHosts});
}
