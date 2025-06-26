import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String responseMessage = '';
  String prediction = '';
  double confidenceScore = 0.0;
  bool isLoading = false;
  bool hasError = false;
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
          // Clear previous results when new image is selected
          prediction = '';
          confidenceScore = 0.0;
          hasError = false;
          responseMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        responseMessage = 'Error picking image: $e';
      });
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
          // Clear previous results when new image is selected
          prediction = '';
          confidenceScore = 0.0;
          hasError = false;
          responseMessage = '';
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        responseMessage = 'Error taking photo: $e';
      });
    }
  }

  Future<void> makePostRequest() async {
    if (selectedImage == null) {
      setState(() {
        hasError = true;
        responseMessage = 'Please select an image first';
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasError = false;
      responseMessage = '';
      prediction = '';
      confidenceScore = 0.0;
    });

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:3000/predict'), // Replace with your actual endpoint
      );

      // Add headers
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // This should match your API's expected field name
          selectedImage!.path,
        ),
      );

      // Add other fields if needed
      request.fields['format'] = 'json';

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      setState(() {
        isLoading = false;
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Success - parse the prediction response
          final data = jsonDecode(response.body);
          prediction = data['prediction'] ?? 'Unknown';
          confidenceScore = (data['scoreconfidence'] ?? 0.0).toDouble();
          responseMessage = 'Prediction completed successfully';
        } else {
          // Error
          hasError = true;
          responseMessage = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        responseMessage = 'Network error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Dr',style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image selection section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  if (selectedImage != null)
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            selectedImage!,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Selected Image',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  if (selectedImage == null)
                    Column(
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No image selected',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: Icon(Icons.photo_library),
                        label: Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade700,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: takePhoto,
                        icon: Icon(Icons.camera_alt),
                        label: Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade700,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (isLoading || selectedImage == null) ? null : makePostRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('Analyzing...'),
                      ],
                    )
                  : Text('Get Prediction'),
            ),
            SizedBox(height: 20),
            if (prediction.isNotEmpty && !hasError)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.blue.shade300, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: Colors.blue.shade700,
                          size: 24,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Diagnosis Result',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Prediction:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: prediction == 'PNEUMONIA' ? Colors.red.shade100 : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: prediction == 'PNEUMONIA' ? Colors.red.shade300 : Colors.green.shade300,
                            ),
                          ),
                          child: Text(
                            prediction,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: prediction == 'PNEUMONIA' ? Colors.red.shade700 : Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Confidence:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          '${confidenceScore.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: confidenceScore / 100,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        confidenceScore >= 70 ? Colors.green : 
                        confidenceScore >= 50 ? Colors.orange : Colors.red,
                      ),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            if (hasError && responseMessage.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: hasError ? Colors.red.shade50 : Colors.green.shade50,
                  border: Border.all(
                    color: hasError ? Colors.red : Colors.green,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          hasError ? Icons.error : Icons.check_circle,
                          color: hasError ? Colors.red : Colors.green,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          hasError ? 'Error' : 'Success',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hasError ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      responseMessage,
                      style: TextStyle(
                        color: hasError ? Colors.red.shade700 : Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}