import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qr_scanner/shared/reusable_card.dart';
import 'package:qr_scanner/shared/round_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String scannedData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Results
            ReusableCard(
              colour: Color(0xFF1D1E33),
              cardChild: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Results",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFF8D8E98),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          scannedData == "" ? "No scan results" : scannedData,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        RoundIconButton(
                          icon: Icons.arrow_forward,
                          onPressed: () async {
                            List<String> url_Split = scannedData.split(".");
                            print(url_Split[url_Split.length - 1]);
                            if (url_Split[url_Split.length - 1] == "com" ||
                                url_Split[url_Split.length - 1] == "org" ||
                                url_Split[url_Split.length - 1] == "net") {
                              if (await canLaunch(scannedData)) {
                                await launch(scannedData);
                              } else {
                                final snackBar = SnackBar(
                                  content:
                                      Text('Scanned QR Data is not a link!'),
                                );

                                // Find the Scaffold in the widget tree and use
                                // it to show a SnackBar.
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Button to scan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlatButton(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Scan Now!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () async {
                  var qrData = await BarcodeScanner.scan();

                  // set the scannedData variable to the result
                  setState(() {
                    scannedData = qrData.rawContent.toString();
                  });
                },
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
