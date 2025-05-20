# StockMarket Pro - Flutter App

A real-time stock market tracking application built with Flutter and Finnhub.io API. Features live price updates, detailed stock information, and market news.

## Features

- Real-time stock price updates via WebSocket
- User authentication with Firebase (Email/Password and Google Sign-in)
- Watchlist functionality with persistent storage
- Detailed stock information and charts
- Company profiles and news
- Market overview with sector performance
- Dark/Light theme support

## Prerequisites

- Flutter SDK
- Firebase account
- Finnhub.io API key
- Android Studio / Xcode for mobile deployment

## Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/yourusername/stockmarket-pro-flutter.git
cd stockmarket-pro-flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Enable Authentication (Email/Password and Google Sign-in)
   - Download and add configuration files:
     - Android: `google-services.json` to `android/app/`
     - iOS: `GoogleService-Info.plist` to `ios/Runner/`

4. Configure Finnhub API:
   - Get your API key from [Finnhub.io](https://finnhub.io/)
   - Update `lib/constants/api_constants.dart` with your API key

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── constants/       # API and app constants
├── models/         # Data models
├── providers/      # State management
├── screens/        # UI screens
├── services/       # API services
├── utils/          # Utilities and themes
└── widgets/        # Reusable widgets
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.