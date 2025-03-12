# Architecture Changes

## Overview

This project has been refactored to use Clean Architecture principles and the BLoC pattern for state management using flutter_bloc 9.1.0. The changes improve code organization, testability, and maintainability.

## Clean Architecture Implementation

The app is now organized into three main layers:

### 1. Domain Layer

The domain layer contains the core business logic and rules of the application, independent of any external frameworks or implementations.

- **Entities**: Core business objects (GroupEntity, LightEntity, etc.)
- **Repositories**: Interfaces defining data operations
- **Use Cases**: Business logic operations (GetGroups, CreateGroup, etc.)

### 2. Data Layer

The data layer implements the repositories defined in the domain layer and handles data sources.

- **Models**: Data objects that map to entities
- **Repositories**: Implementations of domain repositories
- **Data Sources**: API clients and local storage

### 3. Presentation Layer

The presentation layer handles UI and user interactions.

- **BLoCs**: State management using the BLoC pattern
- **Pages**: Screen UI components
- **Widgets**: Reusable UI components

## BLoC Pattern Implementation

The app now uses flutter_bloc for state management:

- **Events**: User actions and triggers
- **States**: UI states representing different conditions
- **BLoCs**: Business logic components that process events and emit states

## Key Benefits

1. **Separation of Concerns**: Each layer has a distinct responsibility
2. **Testability**: Business logic is isolated and easier to test
3. **Maintainability**: Code is more organized and easier to understand
4. **Scalability**: New features can be added without affecting existing code
5. **Dependency Inversion**: High-level modules don't depend on low-level modules

## Folder Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   └── network/
│       └── network_info.dart
├── data/
│   ├── datasources/
│   │   └── remote_data_source.dart
│   ├── models/
│   │   ├── group_model.dart
│   │   ├── group_state_model.dart
│   │   └── light_model.dart
│   └── repositories/
│       ├── group_repository_impl.dart
│       └── light_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── group_entity.dart
│   │   ├── group_state_entity.dart
│   │   └── light_entity.dart
│   ├── repositories/
│   │   ├── group_repository.dart
│   │   └── light_repository.dart
│   └── usecases/
│       ├── group/
│       │   ├── create_group.dart
│       │   ├── delete_group.dart
│       │   ├── get_group_by_id.dart
│       │   ├── get_groups.dart
│       │   ├── set_group_color.dart
│       │   ├── set_white_intensity.dart
│       │   ├── toggle_group_power.dart
│       │   └── update_group.dart
│       └── light/
│           ├── get_lights.dart
│           └── manage_group_members.dart
├── presentation/
│   ├── bloc/
│   │   ├── group/
│   │   │   ├── group_bloc.dart
│   │   │   ├── group_event.dart
│   │   │   └── group_state.dart
│   │   ├── group_details/
│   │   │   ├── group_details_bloc.dart
│   │   │   ├── group_details_event.dart
│   │   │   └── group_details_state.dart
│   │   ├── group_management/
│   │   │   ├── group_management_bloc.dart
│   │   │   ├── group_management_event.dart
│   │   │   └── group_management_state.dart
│   │   ├── home/
│   │   │   ├── home_bloc.dart
│   │   │   ├── home_event.dart
│   │   │   └── home_state.dart
│   │   ├── light/
│   │   │   ├── light_bloc.dart
│   │   │   ├── light_event.dart
│   │   │   └── light_state.dart
│   │   └── theme/
│   │       ├── theme_bloc.dart
│   │       ├── theme_event.dart
│   │       └── theme_state.dart
│   ├── pages/
│   │   ├── group_details_page.dart
│   │   ├── group_management_page.dart
│   │   └── home_page.dart
│   └── widgets/
│       ├── common_app_bar.dart
│       ├── group_card.dart
│       └── theme_switcher.dart
├── theme/
│   └── app_theme.dart
├── injection_container.dart
└── main.dart
```

## Dependency Injection

The app uses GetIt for dependency injection, making it easy to provide dependencies to different parts of the app.

## State Management Flow

1. User interacts with the UI
2. UI dispatches events to BLoC
3. BLoC processes events using use cases
4. Use cases interact with repositories
5. Repositories fetch data from data sources
6. BLoC emits new states based on the results
7. UI rebuilds based on the new state

This architecture ensures a unidirectional data flow, making the app more predictable and easier to debug.