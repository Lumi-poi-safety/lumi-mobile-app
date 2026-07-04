# Lumi

### Safety-Aware POI Recommendation Prototype

Lumi is a mobile research prototype that integrates urban safety considerations into point-of-interest (POI) recommendations.

Unlike traditional recommendation systems that prioritize popularity or proximity, Lumi incorporates:

- Historical crime data
- Environmental indicators (e.g., street lighting)
- User-defined visit context
- Adjustable cautiousness levels
- LLM-generated safety explanations

The system demonstrates how safety can function as a dynamic, context-aware parameter in urban decision support.

---

## Features

- Free-text POI search
- Per-visit context selection
- Adjustable safety sensitivity
- Map-based visualization
- Human-readable safety explanations
- Save and share locations

---

## 🏗 Architecture

**Frontend**

- Flutter (Android & iOS)
- RxDart-based reactive state management
- BLoC architecture pattern

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.x or higher)
- Running backend server
- Configured LLM API key (backend side)

### Installation

```bash
git clone https://github.com/miri-red/lumi.git
cd lumi
flutter pub get
```

### Google Maps Key and Websocket URL

- In android/app/src/main/AndroidManifest.xml fill in your key under "com.google.android.geo.API_KEY"
- In ios/Runner/AppDelegate.swift fill in your key under GMSServices.provideAPIKey
- In lib/features/in_app/explore/service/ws_client.dart add your websocket URL
