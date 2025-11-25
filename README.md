# Jolly Podcast

A modern, feature-rich podcast application built with Flutter that provides users with access to trending episodes, handpicked content, curated playlists, and personalized podcast management.

## 📱 Features

- **Authentication**: Full authentication flow with login and signup
- **Discover Tab**: Browse trending episodes, editor's picks, new releases, latest episodes, and handpicked podcasts
- **Categories**: Explore podcasts by categories
- **Library**: Manage your favorites, recently played episodes, playlists, and followed podcasts
- **Playlists**: View and manage your personal playlists
- **Podcast Player**: Full-featured audio player with playback controls
- **Beautiful UI**: Modern, dark-themed interface with smooth animations and gradients

## 🚀 Steps to Run the Project

### Prerequisites

- **Flutter SDK**: Version 3.10.0 or higher
- **Dart SDK**: Comes bundled with Flutter
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Device/Emulator**: iOS Simulator, Android Emulator, or physical device

### Installation Steps

1. **Clone the repository** (if applicable):
   ```bash
   cd /Users/user/Documents/jolly_podcast
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**:
   ```bash
   flutter doctor
   ```
   Ensure all required dependencies are installed.

4. **Run the app**:

   **For Android/iOS emulator:**
   ```bash
   flutter run
   ```

   **For Web:**
   ```bash
   flutter run -d chrome
   ```

   **For specific device:**
   ```bash
   flutter devices  # List available devices
   flutter run -d <device-id>
   ```

5. **Build for production** (optional):
   
   **Android APK:**
   ```bash
   flutter build apk --release
   ```

   **iOS:**
   ```bash
   flutter build ios --release
   ```

### Configuration

The app connects to the Jolly Podcast API at `https://api.jollypodcast.net`. The API requires authentication using a Bearer token. Ensure you have valid credentials to log in.

**API Base URL**: The base URL is configured in `lib/services/api_client.dart`

## 🏗️ Architecture & State Management

### Chosen State Management Approach: **Provider + ChangeNotifier**

The application uses **Provider** with the **ChangeNotifier** pattern for state management. This approach was chosen for several reasons:

#### Why Provider?

1. **Simplicity**: Provider is straightforward and easy to understand, making the codebase maintainable
2. **Flutter Recommended**: Officially recommended by the Flutter team
3. **Performance**: Efficient rebuild mechanism - only rebuilds widgets that listen to specific changes
4. **Scalability**: Works well for small to medium-sized applications
5. **Minimal Boilerplate**: Less code compared to alternatives like BLoC or Redux

#### Architecture Pattern

```
┌─────────────────┐
│   UI Layer      │  StatefulWidgets with Provider/ListenableBuilder
│  (Views)        │
└────────┬────────┘
         │ Uses
         ▼
┌─────────────────┐
│  Controllers    │  ChangeNotifier classes (state management)
│  (State)        │  - EpisodesController
└────────┬────────┘  - CategoriesController
         │ Calls     - PlaylistsController
         ▼           - AuthProvider
┌─────────────────┐
│  Services       │  API communication layer
│  (Data)         │  - EpisodesService
└────────┬────────┘  - CategoriesService
         │ Uses      - PlaylistsService
         ▼           - AuthService
┌─────────────────┐
│  Models         │  Data models (from JSON)
│  (Entities)     │  - Episode, Podcast, Playlist, Category, User
└─────────────────┘
```

### State Management Flow

1. **UI Layer** initializes controllers and listens for changes using `ListenableBuilder`
2. **Controllers** manage state (loading, loaded, error, empty) and expose data/methods to UI
3. **Services** handle API calls, authentication, and data transformation
4. **Models** represent data structures with `fromJson` and `toJson` methods

### Example: Playlists Flow

```dart
LibraryTab (UI)
    ↓ initializes
PlaylistsController
    ↓ calls fetchPlaylists()
PlaylistsService.getPlaylists()
    ↓ retrieves token
StorageService.getToken()
    ↓ makes authenticated request
ApiClient.get('/api/playlists')
    ↓ parses response
PaginatedPlaylistResponse.fromJson()
    ↓ updates state
PlaylistsController.notifyListeners()
    ↓ rebuilds UI
LibraryTab (displays updated data)
```

## 📋 Assumptions Made

### API Assumptions

1. **Response Structure**: The API follows a consistent nested response structure:
   ```json
   {
     "message": "Success message",
     "data": {
       "message": "Inner message",
       "data": { /* actual data */ }
     }
   }
   ```

2. **Authentication**: 
   - Bearer token authentication is used for all protected endpoints
   - Tokens are stored locally using SharedPreferences
   - Token remains valid for the session duration

3. **Pagination**: All list endpoints support pagination with `page` and `per_page` parameters

4. **Data Fields**: Playlist objects include standard fields (id, name, description, imageUrl, etc.) based on common podcast API patterns

### Technical Assumptions

1. **Network Connectivity**: Assumes users have active internet connection
2. **Data Availability**: API endpoints are available and return data in expected format
3. **Platform Support**: App is designed primarily for mobile (iOS/Android) but supports web
4. **Null Safety**: All API responses may contain null values, handled with fallback defaults
5. **Image URLs**: Image URLs from the API are publicly accessible and valid

### UI/UX Assumptions

1. **Design Consistency**: Existing design patterns should be maintained (dark theme, specific colors)
2. **User Flow**: Users authenticate before accessing main features
3. **Error Handling**: Network errors are gracefully handled with retry options
4. **Loading States**: Users should always see loading indicators for async operations

## 🔧 What Would Be Improved with More Time

### 1. State Management Enhancements

- **Implement Riverpod**: Migrate from Provider to Riverpod for better scalability and compile-time safety
- **State Persistence**: Save app state to survive app restarts (e.g., current playback position, selected tab)
- **Offline Mode**: Cache data locally to enable offline browsing of previously loaded content

### 2. Testing

- **Unit Tests**: Comprehensive unit tests for services, controllers, and models
- **Widget Tests**: Test UI components and user interactions
- **Integration Tests**: End-to-end testing of critical user flows (login, playlist creation, playback)
- **API Mocking**: Mock API responses for reliable testing

### 3. Performance Optimizations

- **Image Caching**: Implement proper image caching with packages like `cached_network_image`
- **Lazy Loading**: Improve infinite scroll and pagination implementation
- **Memory Management**: Dispose controllers and clean up resources more efficiently
- **Bundle Size**: Optimize app size by removing unused assets and dependencies

### 4. Features

- **Search Functionality**: Global search for podcasts, episodes, and playlists
- **Playlist Management**: Create, edit, delete, and reorder playlists
- **Download Episodes**: Offline playback support
- **Social Features**: Share episodes, follow other users, comments
- **Notifications**: Push notifications for new episodes from followed podcasts
- **Recommendations**: AI-powered podcast recommendations based on listening history
- **Background Playback**: Proper background audio with media controls
- **Sleep Timer**: Auto-pause after specified duration
- **Playback Speed**: Variable playback speed controls

### 5. Code Quality

- **Error Logging**: Integration with services like Sentry or Firebase Crashlytics
- **Analytics**: Track user behavior with Firebase Analytics or Mixpanel
- **CI/CD Pipeline**: Automated testing and deployment
- **Documentation**: Comprehensive inline code documentation and API docs
- **Linting Rules**: Stricter linting rules and code formatting standards
- **Accessibility**: Improve screen reader support and accessibility features

### 6. UI/UX Improvements

- **Animations**: More polished micro-animations and transitions
- **Themes**: Support for light mode and custom theme options
- **Localization**: Multi-language support (i18n)
- **Onboarding**: Interactive tutorial for first-time users
- **Skeleton Loaders**: Better loading states with skeleton screens
- **Error Messages**: More user-friendly error messages with actionable steps

### 7. Security

- **Token Refresh**: Automatic token refresh mechanism
- **Secure Storage**: Use platform-secure storage for sensitive data (e.g., flutter_secure_storage)
- **API Key Management**: Environment-based configuration for API keys
- **SSL Pinning**: Certificate pinning for enhanced security

### 8. Architecture

- **Clean Architecture**: Implement clean architecture with clear separation of concerns
- **Repository Pattern**: Abstract data sources with repository pattern
- **Dependency Injection**: Use GetIt or similar for dependency injection
- **Feature-First**: Reorganize code structure to be feature-based rather than layer-based

## 📝 API Integration Details

### Integrated Endpoints

- `POST /api/login` - User authentication
- `GET /api/episodes/trending` - Trending episodes
- `GET /api/episodes/editor-pick` - Editor's pick episode
- `GET /api/episodes/latest` - Latest episodes
- `GET /api/podcasts/top-jolly` - Top Jolly podcasts
- `GET /api/podcasts/handpicked` - Handpicked podcasts
- `GET /api/categories` - Browse categories
- `GET /api/playlists` - User playlists

## 🛠️ Tech Stack

- **Framework**: Flutter 3.10.0+
- **Language**: Dart
- **State Management**: Provider (ChangeNotifier)
- **HTTP Client**: http package
- **Local Storage**: shared_preferences
- **Audio Playback**: audioplayers

## 📄 License

This project is part of the Jolly Podcast application.

## 👥 Contributing

For contributions, please follow the existing code style and architecture patterns described above.

---

**Built with ❤️ using Flutter**
