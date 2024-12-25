import 'package:store_app/globals_variables.dart';
import 'package:store_app/models/user.dart';
import 'package:store_app/services/http_response_service.dart';
import 'package:http/http.dart' as http;

class AuthController {
  Future<void> signUpUsers({
    required context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      User user = User(
        id: "",
        name: name,
        email: email,
        state: "",
        city: "",
        locality: "",
        password: password,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/signup/'),
        body: user
            .toJson(), // converting the user object to json for the request body
        headers: <String, String>{
          //set the headers for the request body
          'Content-Type':
              'application/json; charset=UTF-8', // specify the context type to json
        },
      );

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Account has been Created');
          });
    } catch (e) {
      context.addError(e.toString());
    }
  }
}
