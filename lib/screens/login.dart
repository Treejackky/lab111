import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _controller;
  bool _rememberMe = false;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadRememberedInfo();
  }

  Future<void> _loadRememberedInfo() async {
    String? remember = await storage.read(key: 'remember');
    String? rememberedEmail = await storage.read(key: 'email');
    String? rememberedPassword = await storage.read(key: 'password');
    print("ssssssssssssssssssssssssssssssssssssssss");
    print(remember);
    if (remember == "true") {
      _emailController.text = rememberedEmail.toString();
      _passwordController.text = rememberedPassword.toString();

      setState(() {
        _rememberMe = true;
      });
    }
  }

  void _rememberInfo() async {
    if (_rememberMe) {
      await storage.write(key: 'email', value: _emailController.text);
      await storage.write(key: 'password', value: _passwordController.text);
    } else {
      await storage.delete(key: 'email');
      await storage.delete(key: 'password');
    }
  }

  void _loginAsGuest() async {
    widget.data['fn'] = 'login';
    widget.data['body'] = {
      'email': 'guest',
      'password': 'guest',
    };
    await Navigator.pushNamed(
      context,
      '/api',
    );
    widget.data['fn'] = 'get';
    widget.data['body'] = {};
    await Navigator.pushNamed(
      context,
      '/api',
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
    print("Login as Guest");
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _rememberInfo();
      widget.data['fn'] = 'login';
      widget.data['body'] = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };
      await Navigator.pushNamed(
        context,
        '/api',
      );
      widget.data['fn'] = 'get';
      widget.data['body'] = {};
      await Navigator.pushNamed(
        context,
        '/api',
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _LogoImage(),
              const SizedBox(height: 20),
              _Email(_emailController),
              const SizedBox(height: 20),
              _Password(_passwordController),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text("Remember me"),
                value: _rememberMe,
                onChanged: (newValue) {
                  setState(() {
                    _rememberMe = newValue!;
                    storage.write(
                        key: 'remember', value: _rememberMe.toString());
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  onPressed: _loginAsGuest,
                  child: const Text('Guest'),
                ),
              ),
              const SizedBox(height: 5),
              _buildSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _LogoImage() {
    return Image.asset(
      'assets/iconwealthi.png',
      height: 175,
      width: 300,
    );
  }

  Widget _Email(TextEditingController emailController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 320,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _Password(TextEditingController passwordController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 320,
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have your own account yet?",
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(width: 5),
          const Text(
            'Sign up',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Login'),
//           centerTitle: true,
//         ),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Center(
//               child: Text('Wealthi Real Estate'),
//             ),
//             const Text('email'),
//             const Text('password'),
//             IconButton(
//               icon: const Icon(Icons.star),
//               color: Colors.green[500],
//               hoverColor: Colors.black,
//               onPressed: () async {
//                 widget.data['fn'] = 'login';
//                 widget.data['body'] = {
//                   "email": "adisak.2457@gmail.com",
//                   "password": "111111"
//                   // "email": "s6304062636316@email.kmutnb.ac.th",
//                   // "password": "123456"
//                 };
//                 print(widget.data);

//                 // ignore: unused_local_variable
//                 var response = await Navigator.pushNamed(
//                   context,
//                   '/api',
//                 );

//                 widget.data['fn'] = 'get';
//                 widget.data['body'] = {};
//                 response = await Navigator.pushNamed(
//                   context,
//                   '/api',
//                 );
//                 print(widget.data);

//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   '/home',
//                   (route) => false,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
