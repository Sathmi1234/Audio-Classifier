import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "Upload an audio file";
  bool isLoading = false;
  String? error;

  Future<void> pickAndUploadAudio() async {
    setState(() {
      isLoading = true;
      error = null;
      result = "Processing audio...";
    });

    try {
      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wav'],
        withData: true,
      );

      if (picked == null) {
        setState(() {
          isLoading = false;
          result = "No file selected";
        });
        return;
      }

      Uint8List audioBytes = picked.files.first.bytes!;
      String fileName = picked.files.first.name;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8000/predict'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          audioBytes,
          filename: fileName,
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);

      setState(() {
        result = "Prediction: ${data['prediction']}";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Something went wrong";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-Time Audio Classifier"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.graphic_eq, size: 64, color: Colors.indigo),
              const SizedBox(height: 20),

              Text(
                result,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),

              if (isLoading) ...[
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],

              if (error != null) ...[
                const SizedBox(height: 20),
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: isLoading ? null : pickAndUploadAudio,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload WAV File"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF2F4F8),
    );
  }
}
