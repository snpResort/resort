import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:resort/constant/app_string.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        color: Colors.white,
        height: _height,
        width: _width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 6),
                Image.asset(kLogoApp, width: _width / 1.5),
                Text(
                  'Liên hệ',
                  style: TextStyle(fontSize: _width / 16),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(CupertinoIcons.map),
                    const SizedBox(width: 10),
                    Text(
                      'Moonlight Resort',
                      style: TextStyle(
                        fontSize: _width / 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '140 Lê Trọng Tấn, Phường Tây Thành, Quận Tân Phú, Thành Phố Hồ Chí Minh',
                  style: TextStyle(
                    fontSize: _width / 17,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => launchUrlString("tel://036 241 7182"),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.phone),
                      const SizedBox(width: 10),
                      Text(
                        '036 241 7182',
                        style: TextStyle(
                          fontSize: _width / 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => launchUrl(emailLaunchUri),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.mail),
                      const SizedBox(width: 10),
                      Text(
                        'moonlightresort@gmail.com',
                        style: TextStyle(
                          fontSize: _width / 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: _width,
                  height: 250,
                  color: Colors.amber,
                  child: WebView(
                    initialUrl: Uri.dataFromString('''
                          <html>
                            <body>
                              <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1093.4684531735024!2d106.6285649782913!3d10.806107889467654!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752be27d8b4f4d%3A0x92dcba2950430867!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBDw7RuZyBuZ2hp4buHcCBUaOG7sWMgcGjhuqltIFRQLkhDTQ!5e0!3m2!1svi!2s!4v1669392420559!5m2!1svi!2s" width="100%" height="500" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                            </body>
                          </html>
                          ''', mimeType: 'text/html').toString(),
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

final Uri emailLaunchUri = Uri(
  scheme: 'mailto',
  path: 'moonlightresort@gmail.com',
  query: encodeQueryParameters(<String, String>{
    'subject': 'Subject mail',
  }),
);
