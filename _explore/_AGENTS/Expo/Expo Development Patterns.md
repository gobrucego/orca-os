---
title: "Expo Development Patterns"
source: "https://developertoolkit.ai/en/cookbook/mobile-development/expo/"
author:
  - "[[Wondel.ai]]"
published: 2025-10-19
created: 2025-11-20
description: "Rapid mobile development with Expo and AI-powered coding assistance"
tags:
  - "clippings"
---
[Skip to content](https://developertoolkit.ai/en/cookbook/mobile-development/expo/#_top)

Supercharge your Expo development workflow with Cursor and Claude Code. These patterns cover the managed workflow, EAS Build, Expo Router, and the unique advantages of building React Native apps with Expo’s comprehensive toolkit.

- [Cursor](https://developertoolkit.ai/en/cookbook/mobile-development/expo/#tab-panel-1023)
- [Claude Code](https://developertoolkit.ai/en/cookbook/mobile-development/expo/#tab-panel-1024)

```typescript
// Cursor prompt for app structure:
"Set up Expo Router with:
- Modal routes
- Dynamic routes with [id]
- Protected routes with auth check
- Deep linking configuration"

// Generated structure:
app/
  (tabs)/
    _layout.tsx
    index.tsx
    profile.tsx
    settings.tsx
  (auth)/
    login.tsx
    register.tsx
  post/
    [id].tsx
  modal.tsx
  _layout.tsx
```

- [Tab Navigation](https://developertoolkit.ai/en/cookbook/mobile-development/expo/#tab-panel-1025)
- [Stack Navigation](https://developertoolkit.ai/en/cookbook/mobile-development/expo/#tab-panel-1026)

```tsx
// Cursor Agent prompt:
"Create tab layout with:
- Custom tab bar component
- Icon animations
- Badge notifications
- Platform-specific styling"
```

```tsx
// Comprehensive styling prompt:
"Configure NativeWind with:
1. Tailwind config for mobile
2. Custom theme colors
3. Dark mode support
4. Platform-specific classes
5. Responsive breakpoints"
```

Styled Components

```tsx
// Prompt: "Create styled button with:
// - Multiple variants
// - Press animations
// - Loading states
// - NativeWind classes"
```

Theme System

```tsx
// Prompt: "Implement theme with:
// - Color schemes
// - Typography scale
// - Spacing system
// - Component variants"
```

```tsx
// Camera implementation prompt:
"Implement camera feature using Expo Camera with:
- Photo and video capture
- Camera switching
- Flash control
- Media library saving
- Permissions handling
- Error states"
```

1. **Setup**: “Configure expo-location with permissions”
2. **Tracking**: “Implement real-time location tracking”
3. **Geofencing**: “Add region monitoring”
4. **Background**: “Set up background location tasks”

```tsx
// Notification setup prompt:
"Configure push notifications with:
- Expo Notifications setup
- FCM/APNs configuration
- Local notifications
- Notification handlers
- Deep linking from notifications
- Analytics tracking"
```

```tsx
// State management prompt:
"Set up Zustand for Expo app with:
- Persistent storage using SecureStore
- Authentication state
- App settings
- Offline data queue
- DevTools integration"
```

```tsx
// API state management:
"Configure React Query with:
- Expo SQLite persistence
- Offline support
- Background refetch
- Optimistic updates
- Error boundaries"
```

- [Development Build](https://developertoolkit.ai/en/cookbook/mobile-development/expo/#tab-panel-1027)
- [Production Build](https://developertoolkit.ai/en/cookbook/mobile-development/expo/#tab-panel-1028)

```json
// Cursor prompt: "Configure EAS Build for development with:
// - iOS simulator build
// - Android emulator build
// - Development client
// - Environment variables"
```

```yaml
// CI/CD setup prompt:
"Create GitHub Actions workflow for:
- Automated EAS builds
- Preview builds on PR
- Production deployment
- OTA update triggers
- Version management"
```

```tsx
// Test generation prompt:
"Write tests for Expo components using:
- Jest and React Native Testing Library
- Expo modules mocking
- Gesture testing
- Snapshot tests"
```

1. **Setup**: “Configure Maestro for Expo app”
2. **Write Flows**: “Create E2E test for onboarding”
3. **CI Integration**: “Add Maestro tests to EAS Build”

Performance Patterns

AI can implement:

- Asset optimization
- Bundle size reduction
- Splash screen optimization
- Memory management
- FlatList optimizations

```tsx
// Analytics setup prompt:
"Implement analytics with:
- Expo Analytics
- Custom event tracking
- Performance monitoring
- Crash reporting
- User properties"
```

```tsx
// Complete auth prompt:
"Implement authentication using:
- Expo AuthSession
- Secure token storage
- Biometric authentication
- Session management"
```

```tsx
// File handling prompt:
"Create file management system with:
- Document picker
- Image picker with editing
- File upload with progress
- Download management
- Cache control"
```

1. **Local Database**: “Set up Expo SQLite with schema”
2. **Sync Logic**: “Implement data synchronization”
3. **Conflict Resolution**: “Handle merge conflicts”
4. **Queue Management**: “Create offline action queue”

```tsx
// Advanced routing prompt:
"Implement dynamic routing with:
- Catch-all routes
- Optional parameters
- Route groups
- Layout routes
- API routes"
```

```tsx
// Auth guard implementation:
"Create route protection with:
- Authentication checks
- Role-based access
- Redirect logic
- Loading states
- Deep link preservation"
```

```tsx
// Module creation prompt:
"Create custom Expo module for:
- Native functionality not in SDK
- iOS and Android implementation
- TypeScript definitions
- Example app
- Documentation"
```

```tsx
// Debugging setup:
"Configure debugging environment with:
- React DevTools
- Expo Dev Tools
- Performance monitor
- Network inspector
- Redux DevTools"
```

Comprehensive Error Strategy

Implement with AI:

- Error boundaries
- Sentry integration
- User feedback forms
- Recovery mechanisms
- Debug information collection

```typescript
// Structure prompts like:
"Create [feature] for Expo using:
- SDK version: [version]
- Platforms: [iOS/Android/Web]
- Key requirements: [list]
- Expo modules needed: [list]
- Include error handling and loading states"
```

SDK Compatibility

Always mention SDK version and required Expo modules

Managed vs Bare

Specify workflow type for accurate implementations

Platform Differences

Request platform-specific handling when needed

Performance

Ask for Expo-optimized solutions

```tsx
// Web compatibility prompt:
"Add web support to Expo app with:
- Responsive design
- SEO optimization
- PWA configuration
- Platform-specific components
```

```tsx
// Monorepo configuration:
"Set up Expo in monorepo with:
- Multiple apps
- Common components
- Build configuration
- Workspace setup"
```

1. **Analyze**: “Scan existing RN project for compatibility”
2. **Plan**: “Create migration strategy”
3. **Migrate**: “Convert to Expo managed workflow”
4. **Test**: “Verify all features work”
- Explore [React Native patterns](https://developertoolkit.ai/en/cookbook/mobile-development/react-native) for bare workflow
- Learn [Backend integration](https://developertoolkit.ai/en/cookbook/backend-recipes) for API development
- Master [Testing strategies](https://developertoolkit.ai/en/cookbook/testing-patterns) for quality assurance