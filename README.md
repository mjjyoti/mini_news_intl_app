# mini_news_intl_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

mini_news_intl_app/
├── pubspec.yaml
├── README.md
├── analysis_options.yaml
├── .gitignore
└── lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   └── api_client.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   └── date_utils.dart
│   └── widgets/
│       ├── empty_state.dart
│       ├── error_display.dart
│       └── loading_widget.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_local_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       └── screens/
│   │           └── login_screen.dart          ← SCREEN 1
│   ├── news/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── news_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── article_model.dart
│   │   │   └── repositories/
│   │   │       └── news_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── article.dart
│   │   │   └── repositories/
│   │   │       └── news_repository.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── news_provider.dart
│   │       │   └── search_provider.dart
│   │       ├── screens/
│   │       │   ├── news_feed_screen.dart     ← SCREEN 2
│   │       │   ├── search_screen.dart        ← SCREEN 3
│   │       │   └── article_detail_screen.dart← SCREEN 4
│   │       └── widgets/
│   │           ├── article_card.dart
│   │           └── category_chips.dart
│   └── favorites/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── favorites_local_datasource.dart
│       │   └── repositories/
│       │       └── favorites_repository_impl.dart
│       ├── domain/
│       │   └── repositories/
│       │       └── favorites_repository.dart
│       └── presentation/
│           ├── providers/
│           │   └── favorites_provider.dart
│           └── screens/
│               └── favorites_screen.dart     ← SCREEN 5
└── shared/
    └── providers/
        └── providers.dart