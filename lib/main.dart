import 'package:flutter/material.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

void main() {
  runApp(MyApp());
}

// OAuth2 client setup
class MyOAuthClient extends OAuth2Client {
  MyOAuthClient()
      : super(
          authorizeUrl:
              "https://apisecurity-ahabeuhfaqc6h7e0.centralus-01.azurewebsites.net/api/users/o/authorize/", 
          tokenUrl:
              "https://apisecurity-ahabeuhfaqc6h7e0.centralus-01.azurewebsites.net/api/token/", 
          redirectUri: "https://apisecurity-ahabeuhfaqc6h7e0.centralus-01.azurewebsites.net/api/users/oauth/callback/",
          customUriScheme: "",
        );
}

// Config: Leave clientId and clientSecret blank
const String clientId = '';
const String clientSecret = '';

final oauthHelper = OAuth2Helper(
  MyOAuthClient(),
  clientId: clientId,
  clientSecret: clientSecret,
  scopes: ['read', 'write'],
  //enablePKCE: true,
  //grantType: OAuth2Helper.AUTHORIZATION_CODE_PKCE,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OAuth2 Optional Demo',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  void login(BuildContext context) async {
    if (clientId.isEmpty || clientSecret.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OAuth not configured')),
      );
      return;
    }

    var token = await oauthHelper.getToken();

    if (token != null && token.accessToken != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Successful: ${token.accessToken}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOAuthConfigured = clientId.isNotEmpty && clientSecret.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text('Login With OAuth 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: isOAuthConfigured ? () => login(context) : null,
          child: Text('Login',style: TextStyle(color: Colors.blueAccent),),
        ),
      ),
    );
  }
}
