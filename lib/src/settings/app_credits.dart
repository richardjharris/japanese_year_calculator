import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:japanese_year_calculator/src/localization/app_localizations_context.dart';
import 'package:url_launcher/url_launcher.dart';

/// Small card that shows the app credits and attribution of era data.
class AppCredits extends StatelessWidget {
  const AppCredits({Key? key}) : super(key: key);

  /// Developer e-mail address.
  static final String email = String.fromCharCodes(
      base64.decode('cmljaGFyZGpoYXJyaXMranljQGdtYWlsLmNvbQ=='));

  /// Permalink URL for the Japanese era list.
  static const String wikipediaSourceUrl =
      "https://ja.wikipedia.org/w/index.php?title=%E5%85%83%E5%8F%B7%E4%B8%80%E8%A6%A7_(%E6%97%A5%E6%9C%AC)&oldid=87512323";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.loc.appCreditsHeader,
                style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 8.0),
            _creditsText(context),
          ],
        ),
      ),
    );
  }

  Widget _creditsText(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge!;
    final smallTextStyle = Theme.of(context).textTheme.bodySmall!;
    final linkColor = Theme.of(context).buttonTheme.colorScheme!.primary;

    TextSpan bodySpan = TextSpan(
      style: textStyle,
      text: context.loc.appCreditsBody(email),
    );
    bodySpan = linkify(bodySpan, email, 'mailto:$email', linkColor);

    TextSpan attributionSpan = TextSpan(
      style: smallTextStyle,
      text: context.loc.appCreditsAttribution(
        context.loc.wikipedia,
        context.loc.ccLicenseName,
      ),
    );
    attributionSpan = linkify(
      attributionSpan,
      context.loc.wikipedia,
      wikipediaSourceUrl,
      linkColor,
    );
    attributionSpan = linkify(
      attributionSpan,
      context.loc.ccLicenseName,
      context.loc.ccLicenseUrl,
      linkColor,
    );

    return Column(
      children: [
        RichText(text: bodySpan),
        const SizedBox(height: 8.0),
        RichText(text: attributionSpan),
      ],
    );
  }
}

/// Replace [linkText] with a clickable link to [url].
///
/// [span] must have a style.
///
/// If [linkText] appears more than once in the span, only the first occurrence
/// will be turned into a link.
TextSpan linkify(TextSpan span, String linkText, String url, Color linkColor) {
  TextSpan returnValue;
  if (span.text != null && span.text!.contains(linkText)) {
    returnValue = TextSpan(
      style: span.style,
      children: [
        TextSpan(
          text: span.text!.substring(0, span.text!.indexOf(linkText)),
          style: span.style,
        ),
        TextSpan(
          text: linkText,
          style: span.style?.copyWith(
            color: linkColor,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch(url);
            },
        ),
        TextSpan(
          text: span.text!.substring(
              span.text!.indexOf(linkText) + linkText.length,
              span.text!.length),
          style: span.style,
        ),
      ],
    );
  } else if (span.children != null) {
    /// Try searching the children
    returnValue = TextSpan(
      style: span.style,
      text: span.text,
      children: span.children!.map((child) {
        if (child is TextSpan) {
          return linkify(child, linkText, url, linkColor);
        } else {
          return child;
        }
      }).toList(),
    );
  } else {
    returnValue = span;
  }

  return returnValue;
}
