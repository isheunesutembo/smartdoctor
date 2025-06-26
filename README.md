# 📱 Smart Dr - Pneumonia Detection Mobile App

A Flutter mobile application that uses AI-powered image analysis to detect pneumonia from chest X-ray images. The app provides an intuitive interface for capturing or selecting X-ray images and displays diagnostic results with confidence scores.

## 🌟 Features

- **📸 Image Capture**: Take photos directly from camera or select from gallery
- **🤖 AI-Powered Analysis**: Real-time pneumonia detection using machine learning
- **📊 Confidence Scoring**: Visual confidence indicators with percentage scores
- **🎨 Modern UI**: Clean, medical-themed interface with smooth animations
- **⚡ Real-time Results**: Instant analysis and diagnosis display
- **🔄 Loading States**: Professional loading indicators during analysis
- **❌ Error Handling**: Comprehensive error management and user feedback
- **📱 Cross-Platform**: Works on both Android and iOS devices

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **HTTP Client**: http package
- **Image Handling**: image_picker package
- **State Management**: StatefulWidget
- **UI Components**: Material Design

## 📋 Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android device/emulator or iOS device/simulator
- Running FastAPI backend server

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/smart-dr-mobile.git
cd smart-dr-mobile
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Backend URL

Update the API endpoint in `lib/home_screen.dart`:

```dart
Uri.parse('http://YOUR_BACKEND_URL:3000/predict')
```

**For Development:**
- Android Emulator: `http://10.0.2.2:3000/predict`
- iOS Simulator: `http://localhost:3000/predict`
- Physical Device: `http://YOUR_COMPUTER_IP:3000/predict`

### 4. Run the Application

```bash
flutter run
```

## 📦 Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  image_picker: ^1.0.4
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🏗️ Project Structure

```
lib/
├── main.dart              # App entry point
├── home_screen.dart       # Main screen with camera and analysis
├── models/
│   └── prediction.dart    # Data models for API responses
├── services/
│   └── api_service.dart   # API communication service
├── widgets/
│   ├── image_picker_widget.dart
│   ├── result_display.dart
│   └── loading_indicator.dart
└── utils/
    └── constants.dart     # App constants and configurations
```

## 📱 App Screens & Features

### Home Screen
- **Image Selection**: Choose between camera capture or gallery selection
- **Preview**: Display selected image with option to reselect
- **Analysis Button**: Trigger pneumonia detection analysis
- **Results Display**: Show prediction results with confidence scores

### Key Components

#### Image Picker
```dart
// Camera capture
final XFile? image = await _picker.pickImage(
  source: ImageSource.camera,
  imageQuality: 80,
);

// Gallery selection
final XFile? image = await _picker.pickImage(
  source: ImageSource.gallery,
  imageQuality: 80,
);
```

#### API Integration
```dart
var request = http.MultipartRequest(
  'POST',
  Uri.parse('http://10.0.2.2:3000/predict'),
);

request.files.add(
  await http.MultipartFile.fromPath('file', selectedImage!.path),
);
```

## 🎨 UI/UX Design

### Color Scheme
- **Primary**: Blue tones for medical trust
- **Success**: Green for normal results
- **Warning**: Red for pneumonia detection
- **Neutral**: Grey shades for UI elements

### Visual Elements
- **Gradient Backgrounds**: Professional medical appearance
- **Progress Indicators**: Visual confidence representation
- **Icon Integration**: Medical and camera icons
- **Card Layouts**: Clean information presentation

## 🔧 Configuration

### Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to capture X-ray images for analysis</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select X-ray images</string>
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📊 API Response Format

The app expects the following JSON response from the backend:

```json
{
  "prediction": "PNEUMONIA" | "NORMAL",
  "scoreconfidence": 87.45
}
```

## 🔒 Permissions

### Android
- Camera access for capturing X-ray images
- Storage access for saving/reading images
- Internet access for API communication

### iOS
- Camera usage permission
- Photo library access permission
- Network permissions (automatic)

## 🚢 Deployment

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🐛 Troubleshooting

### Common Issues

**1. Network Connection Errors**
- Ensure backend server is running
- Check IP address configuration
- Verify firewall settings

**2. Image Picker Not Working**
- Check camera/storage permissions
- Ensure device has camera capability
- Verify iOS/Android configuration

**3. API Timeout**
- Increase timeout duration in HTTP client
- Check server response time
- Verify image file size

### Debug Mode
```bash
flutter run --debug
flutter logs
```

## 📈 Performance

- **Image Compression**: 80% quality for faster uploads
- **Async Operations**: Non-blocking UI during API calls
- **Memory Management**: Proper image disposal
- **Loading States**: User feedback during processing

## ⚠️ Important Notes

- **Medical Disclaimer**: This app is for educational purposes only
- **Not for Clinical Use**: Always consult healthcare professionals
- **Data Privacy**: Handle medical images securely
- **Backend Dependency**: Requires running FastAPI server

## 🔐 Security Considerations

- Implement proper authentication for production
- Use HTTPS for API communication
- Validate image files before upload
- Implement rate limiting
- Secure storage of sensitive data

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/smart-dr-mobile/issues)
- **Email**: support@smartdr.com
- **Documentation**: Check the [Wiki](https://github.com/yourusername/smart-dr-mobile/wiki)

## 🔄 Version History

- **v1.0.0** - Initial release with basic pneumonia detection
- **v1.1.0** - Added confidence scoring and improved UI
- **v1.2.0** - Enhanced error handling and loading states

## 🚀 Future Enhancements

- [ ] Multi-language support
- [ ] Offline mode with local model
- [ ] History of previous analyses
- [ ] Export results as PDF reports
- [ ] Integration with health records
- [ ] Dark mode support
- [ ] Advanced image filters
- [ ] Batch image processing

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Medical imaging community for research support
- Contributors and beta testers

---

**⚠️ Medical Disclaimer**: Smart Dr is designed for educational and research purposes only. It is not intended to replace professional medical advice, diagnosis, or treatment. Always consult qualified healthcare providers for medical concerns.
