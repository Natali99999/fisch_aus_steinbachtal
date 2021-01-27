import 'package:animations/animations.dart';
import 'package:fisch_aus_steinbachtal/helper/base.dart';
import 'package:fisch_aus_steinbachtal/screens/pdf_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Durch die Nutzung dieser App stimmen Sie unseren\n",
          style: Theme.of(context).textTheme.bodyText1,
          children: [
            TextSpan(
              text: "Nutzungsbedingungen ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showModal(
                    context: context,
                    configuration: FadeScaleTransitionConfiguration(),
                    builder: (context) {
                      return MarkdownPage(
                          storageFilename: Base.agbStorageFilename);

                      /* PolicyDialog(
                        mdFileName: 'terms_and_conditions.md',
                      );*/
                    },
                  );
                },
            ),
            TextSpan(text: "und "),
            TextSpan(
              text: "Datenschutz zu! ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return MarkdownPage(
                          storageFilename: Base.datenschutzStorageFilename);

                     /* PolicyDialog(
                        mdFileName: 'privacy_policy.md',
                      );*/
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
