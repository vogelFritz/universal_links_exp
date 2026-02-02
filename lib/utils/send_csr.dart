import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const String baseUrl = 'https://localhost:8443'; // Change to your server URL
const bool ignoreBadCertificate = true; // For local dev → false in production
const String enrollTokenKey =
    'enroll_token'; // Key for storing token temporarily
const String privateKeyKey = 'device_private_key'; // PEM-encoded private key
const String certificateKey = 'device_certificate'; // PEM-encoded certificate

final x509Subject = <String, String>{
  'CN': 'device-${Uuid().v4().toLowerCase()}',
};

final FlutterSecureStorage _storage = FlutterSecureStorage();

Future<void> sendCSR(String enrollToken) async {
  final url = 'https://192.168.0.29:8443/enroll';
  final caCert = await rootBundle.load('assets/ca/ca-cert.pem');
  final http.Client client = IOClient(
    HttpClient(
      context: SecurityContext.defaultContext,
      // ..setTrustedCertificatesBytes(caCert.buffer.asUint8List()),
    )..badCertificateCallback = (_, _, _) => true,
  );
  final (csr, rsaPrivateKey) = await generateCSR();
  print('about to make request');
  final response = await client.post(
    Uri.parse(url),
    headers: {
      'X-Enroll-Token': enrollToken,
      'Content-Type': 'application/x-pem-file',
    },
    body: csr,
  );
  print('finished request');
  if (response.statusCode != 200) {
    print(response.statusCode);
    print(response.body);
    throw Exception();
  }
  final certPem = response.body;
  if (!certPem.contains('-----BEGIN CERTIFICATE-----')) {
    throw Exception('invalid response: $certPem');
  }
  await _storage.write(key: certificateKey, value: certPem);
  await _storage.write(key: privateKeyKey, value: rsaPrivateKey.toString());
  print(certPem);
  client.close();
}

Future<(String, RSAPrivateKey)> generateCSR() async {
  AsymmetricKeyPair keypair = CryptoUtils.generateRSAKeyPair();
  return (
    X509Utils.generateRsaCsrPem(
      x509Subject,
      keypair.privateKey as RSAPrivateKey,
      keypair.publicKey as RSAPublicKey,
    ),
    (keypair.privateKey as RSAPrivateKey),
  );
}

Future<void> refreshTokenWithCert() async {
  final url = 'https://192.168.0.29:8443/refresh';
  final String cert = (await _storage.read(key: certificateKey))!;
  final String privateKey = (await _storage.read(key: privateKeyKey))!;
  final context = SecurityContext.defaultContext;
  context.useCertificateChainBytes(utf8.encode(cert));
  context.usePrivateKeyBytes(utf8.encode(privateKey));
  final http.Client client = IOClient(
    HttpClient(context: context)..badCertificateCallback = (_, _, _) => true,
  );
  await client.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );
  client.close();
}

Future<void> testEndpoints(String enrollToken) async {
  await sendCSR(enrollToken);
  await refreshTokenWithCert();
}
