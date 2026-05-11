# GTM - Immersive Glasses Try-On

A high-fidelity Flutter application demonstrating an immersive 3D glasses try-on experience using a true 360° panorama viewer and dynamic 3D model manipulation.

## 📦 Download & Try
You can download the production-ready APK directly to your Android device:

👉 **[Download GTM Release APK (v1.0.0 for arm64-v8a)](./gtm-arm64-v1.0.0.apk)**

*Note: This optimized version (82MB) is under the 100MB limit for GitHub. If you need other architectures, please run the build command below.*

---

## 🌟 Features

- **360° Immersive Environment**: Experience glasses in various realistic settings (Autumn Park, Chinese Garden, Modern Bathroom, Shanghai Bund) using high-resolution 8K equirectangular maps.
- **6 Premium Eyewear Styles**:
  - **Impressionist**: Cyan/Teal aesthetic in a lush Chinese Garden.
  - **Cyber**: Neon Green theme in a vibrant landscape.
  - **Vintage**: Amber/Gold theme in an Autumn Park.
  - **Sunset**, **Ocean**, and **Midnight** classics.
- **Dynamic 3D Models**: Real-time rendering of sunglasses using `model_viewer_plus` with custom JavaScript-driven material manipulation.
- **Material Detection Logic**: Intelligent script that distinguishes between glass lenses and frames to apply specific colors, metallic factors, and transparency.
- **Stable Viewing Experience**: Optimized for mobile with stable panoramic viewing (auto-rotation disabled for precision).

## 🚀 Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **3D Rendering**: Google Model Viewer (via `model_viewer_plus`)
- **Panoramic Viewing**: `panorama_viewer`
- **Environment Maps**: 8K Tonemapped JPEGs from Polyhaven (bundled locally).

## 🛠️ Getting Started (Development)

### Prerequisites
- Flutter SDK
- Android Studio / VS Code

### Installation
1. Clone and install:
   ```bash
   git clone <repository-url>
   cd gtm
   flutter pub get
   ```
2. Run the app:
   ```bash
   flutter run
   ```

## 📦 Manual Build
To generate a new release APK manually:
```bash
flutter build apk --release
```
The resulting APK will be at `build/app/outputs/flutter-apk/app-release.apk`.
