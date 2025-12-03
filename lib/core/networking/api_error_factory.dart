import 'package:flutter/material.dart';
import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/core/networking/local_status_codes.dart';


class ApiErrorFactory {
  static ApiErrorModel get defaultError => ApiErrorModel(
    message: "Something went wrong",
    icon: Icons.error,
    statusCode: LocalStatusCodes.defaultError,
  );
}
