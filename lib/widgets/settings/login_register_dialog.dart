import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

Future<String> fetchCaptchaId() async {
  final resp = await http.get(Uri.parse('http://localhost:22333/captcha'));
  if (resp.statusCode == 200) {
    return json.decode(resp.body)['captcha_id'];
  }
  throw Exception('获取验证码ID失败');
}

class LoginRegisterDialog extends StatefulWidget {
  final bool isLogin;
  const LoginRegisterDialog({super.key, required this.isLogin});

  @override
  State<LoginRegisterDialog> createState() => _LoginRegisterDialogState();
}

class _LoginRegisterDialogState extends State<LoginRegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String captcha = '';
  String captchaId = '';
  String errorMsg = '';
  bool loading = false;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _refreshCaptcha();
  }

  void _refreshCaptcha() async {
    try {
      final id = await fetchCaptchaId();
      setState(() {
        captchaId = id;
      });
    } catch (e) {
      setState(() {
        errorMsg = '验证码获取失败';
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { loading = true; errorMsg = ''; });
    _formKey.currentState!.save();
    final url = widget.isLogin ? 'http://localhost:22333/login' : 'http://localhost:22333/register';
    final resp = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'captcha_id': captchaId,
        'captcha': captcha,
      }),
    );
    setState(() { loading = false; });
    // 使用全局logger输出API返回内容
    Get.find<Logger>().i('API返回: ${resp.body}');
    if (resp.statusCode == 200) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        errorMsg = json.decode(resp.body)['error'] ?? '未知错误';
      });
      _refreshCaptcha();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isLogin ? '登录' : '注册'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: '用户名'),
              onSaved: (v) => username = v ?? '',
              validator: (v) => v == null || v.isEmpty ? '请输入用户名' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: '密码'),
              obscureText: true,
              onSaved: (v) => password = v ?? '',
              validator: (v) => v == null || v.isEmpty ? '请输入密码' : null,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: '验证码'),
                    onSaved: (v) => captcha = v ?? '',
                    validator: (v) => v == null || v.isEmpty ? '请输入验证码' : null,
                  ),
                ),
                const SizedBox(width: 8),
                if (captchaId.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GestureDetector(
                      onTap: _refreshCaptcha,
                      child: Image.network(
                        'http://localhost:22333/captcha/$captchaId',
                        width: 80,
                        height: 32,
                        errorBuilder: (c, e, s) => const Icon(Icons.error),
                      ),
                    ),
                  ),
              ],
            ),
            if (errorMsg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(errorMsg, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: loading ? null : _submit,
          child: Text(widget.isLogin ? '登录' : '注册'),
        ),
      ],
    );
  }
}
