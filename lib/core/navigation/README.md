# 🧭 Navigation System

[![Flutter](https://img.shields.io/badge/Flutter-02569B?
[![Dart](https://img.shields.io/badge/Dart-0175C2?
[![License](https://img.shields.io/badge/License-MIT-green.svg?

> [🇻🇳 Tiếng Việt](./README_VI.md) | 🇬🇧 English

---

## ⚡ Quick Start

```dart
// 1. Setup in main.dart
MaterialApp(
  navigatorKey: NavigationManager.instance.navigatorKey,
  home: HomeScreen(),
)

// 2. Navigate anywhere
NavigationManager.instance.navigateTo(
  ProfileScreen(),
  transition: TransitionType.slideRight,
);

// 3. Handle results
final result = await NavigationManager.instance.navigateTo<String>(
  EditScreen(),
);
```

---

## 📋 Table of Contents

- [⚡ Quick Start](#-quick-start)
- [🎯 Introduction](#-introduction)
- [🏗️ Architecture](#️-architecture)
- [📁 Files Structure](#-files-structure)
- [🚀 Navigation Methods](#-navigation-methods)
- [🎨 Transition Types](#-transition-types)
- [💡 Usage Examples](#-usage-examples)
- [✅ Best Practices](#-best-practices)
- [🎓 Advanced Tips](#-advanced-tips)
- [🐛 Troubleshooting](#-troubleshooting)
- [📚 References](#-references)

---

## 🎯 Introduction

### 🚀 **Powerful & Flexible Navigation System**

A comprehensive navigation solution for Flutter applications featuring **beautiful animations**, **type safety**, and **intuitive APIs**.

---

### ✨ Key Features

| Feature                  | Description                                    |
| ------------------------ | ---------------------------------------------- |
| 🎨 **20+ Transitions**   | Rich animation library with custom transitions |
| 📱 **Platform Aware**    | Native iOS Cupertino-                          |
| 🔄 **Stack Control**     | Full navigation stack manipulation             |
| 🎭 **Customizable**      | Adjustable animation duration & easing         |
| 💡 **Developer Frily**   | Simple, intuitive API design                   |
| 📦 **Type Safe**         | Generic support for return values              |
| 🏗️ **Singleton Pattern** | Single source of truth for navigation          |

---

## 🏗️ Architecture

```
graph TD
    A[NavigationManager<br/>Singleton] --> B[RouteBuilder]
    A --> C[TransitionType<br/>Enum]

    B --> D[PageRouteBuilder]
    B --> E[Custom Transitions]

    C --> F[20+ Animation Types]
    C --> G[Platform Specific]




```

### 🏛️ System Components

```
🎯 NavigationManager (Singleton)
├── 🔑 navigatorKey: GlobalKey<NavigatorState>
├── 🚀 Navigation Methods (8 core methods)
├── 🔄 Stack Management
└── 📊 State Monitoring

🎨 RouteBuilder
├── 🏗️ Route Construction
├── 🎬 Animation Logic
└── ⚙️ Transition Configuration

📋 TransitionType (Enum)
├── ➡️ Slide Transitions (8 types)
├── 🔄 Basic Transitions (3 types)
├── ↻ Rotation Transitions (2 types)
├── 🔗 Combined Transitions (3 types)
├── 🔍 Zoom Transitions (3 types)
└── 🍎 Platform Specific (1 type)
```

---

## 📁 Files Structure

```
lib/core/navigation/
├── navigation_manager.dart    # Main navigation controller
├── route_builder.dart         # Route & transition builder
├── transition_type.dart       # Transition types enum
├── README.md                  # Documentation (English)
└── README_VI.md              # Documentation (Vietnamese)
```

### 1. `navigation_manager.dart` (183 lines)

Core navigation controller with methods for screen transitions and stack management.

### 2. `route_builder.dart` (202 lines)

Builds routes with custom transitions and handles animation logic.

### 3. `transition_type.dart` (107 lines)

Enum defining all available transition types with documentation.

---

## 🚀 Navigation Methods

### 📱 **How Navigation Works - Visual Guide**

```
╔══════════════════════════════════════════════════════════════╗
║                      NAVIGATION STACK                              ║
║                                                                      ║
║  BOTTOM → [Home] → [List] → [Detail] → [Edit] ← TOP (current)   ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════╝
```

#### 🎯 **Method Effects on Stack**

| Method                     | Visual Effect                                 | Use Case             |
| -------------------------- | --------------------------------------------- | -------------------- |
| `navigateTo(New)`          | `[Home] → [List] → [Detail] → [Edit] → [New]` | Forward navigation   |
| `navigateAndReplace(New)`  | `[Home] → [List] → [Detail] → [New]`          | Replace current      |
| `navigateAndClearAll(New)` | `[New]`                                       | Fresh start (logout) |
| `goBack()`                 | `[Home] → [List] → [Detail]`                  | Go back one step     |
| `popToRoot()`              | `[Home]`                                      | Go to home           |

### 📊 Method Comparison

| Method                     | Stack Change               | Use Case              | Returns Result | Removes Previous   |
| -------------------------- | -------------------------- | --------------------- | -------------- | ------------------ |
| `navigateTo()`             | ➕ Adds new screen         | Standard navigation   | ✅ Yes         | ❌ No              |
| `navigateAndReplace()`     | 🔄 Replaces current        | Update current screen | ❌ No          | ✅ Current only    |
| `navigateAndClearAll()`    | 🗑️ Clears all              | Login, app reset      | ❌ No          | ✅ All screens     |
| `navigateAndRemoveUntil()` | 🎯 Removes until condition | Workflow completion   | ❌ No          | ✅ Until condition |
| `goBack()`                 | ➖ Removes current         | Go back               | ✅ Yes         | ✅ Current only    |
| `popUntil()`               | ➖ Removes until condition | Quick navigation      | ❌ No          | ✅ Until condition |
| `popToRoot()`              | 🏠 Removes to root         | Home navigation       | ❌ No          | ✅ All except root |
| `canPop()`                 | 👁️ Check only              | UI state              | ❌ No          | ❌ No              |

> 💡 **Quick Reference**: Choose based on your navigation goal and whether you need to return data.

---

### 1. `navigateTo()` - Navigate to new screen

**➕ Push a new screen onto the stack while keeping the previous screen**

#### 🔄 Stack Flow

```
BEFORE: [Home] → [List] → [Detail] ← Current Screen
                           navigateTo(EditScreen)
AFTER:  [Home] → [List] → [Detail] → [Edit] ← Current Screen
```

#### 📋 What happens

- ➕ **Adds new screen** to the top of stack
- ✅ **Keeps all previous screens** intact
- 🔙 **Back button works** - can return to previous screen
- 📊 **Perfect for**: Standard forward navigation

#### 🎯 Use when

- Opening **detail screen** from list
- Going to **settings page**
- **Editing profile** or data
- Any **forward navigation** that needs back option

**Code Example:**

```dart
// Basic navigation
NavigationManager.instance.navigateTo(ProfileScreen());

// With transition
NavigationManager.instance.navigateTo(
  ProfileScreen(),
  transition: TransitionType.slideUp,
  duration: const Duration(milliseconds: 400),
);

// With result
final result = await NavigationManager.instance.navigateTo<String>(
  EditScreen(),
);
print(result); // "saved" or null
```

---

### 2. `navigateAndReplace()` - Replace current screen

**🔄 Replace the current screen with a new one, removing the old screen from stack**

#### 🔄 Stack Flow

```
BEFORE: [Home] → [List] → [Detail] ← Current Screen (will be removed)
                           navigateAndReplace(SettingsScreen)
AFTER:  [Home] → [List] → [Settings] ← Current Screen (Detail removed)
```

#### 📋 What happens

- 🔄 **Replaces current screen** with new one
- ✅ **Keeps previous screens** (can still go back to List)
- ❌ **Removes current screen** (Detail screen is gone)
- ⚠️ **Cannot go back** to the replaced screen

#### 🎯 Use when

- **Login → Home** after successful authentication
- **Splash → Main** app screen transition
- **Update current screen** content completely
- **Error screen → Retry** scenarios

**Code Example:**

```dart
// Replace screen
NavigationManager.instance.navigateAndReplace(DashboardScreen());

// Use case: After login
NavigationManager.instance.navigateAndReplace(
  HomeScreen(),
  transition: TransitionType.fade,
);
```

---

### 3. `navigateAndClearAll()` - Clear all and navigate

**🗑️ Remove all screens from stack and navigate to a new screen**

#### 🔄 Stack Flow

```
BEFORE: [Home] → [List] → [Detail] → [Edit] → [Settings] ← Complex navigation history
      navigateAndClearAll(LoginScreen)
AFTER:  [Login] ← Only screen left, fresh start
```

#### 📋 What happens

- 🗑️ **Clears entire navigation stack** (removes all screens)
- 🔄 **Starts fresh** with only the new screen
- ❌ **Cannot go back** (no previous screens exist)
- 🔒 **Perfect for**: Authentication boundaries

#### 🎯 Use when

- **User logout** - clear all navigation history
- **Session expired** - force login flow
- **App reset/refresh** - clean slate
- **Deep linking** from external sources

#### 📋 Behavior

**Code Example:**

```dart
// Logout scenario
NavigationManager.instance.navigateAndClearAll(
  LoginScreen(),
  transition: TransitionType.fade,
);

// Reset app
NavigationManager.instance.navigateAndClearAll(
  WelcomeScreen(),
);
```

---

### 4. `navigateAndRemoveUntil()` - Navigate and remove until condition

**🎯 Navigate to new screen and remove screens until condition is met**

#### 🔄 Stack Flow

```
BEFORE: [Home] → [List] → [Detail] → [Edit] → [Settings] ← Current
                           navigateAndRemoveUntil(Checkout, isCheckout)
AFTER:  [Home] → [List] → [Checkout] ← Current (removed Detail, Edit, Settings)
```

#### 📋 What happens

- 🎯 **Navigates to new screen** and removes screens until condition
- ✅ **Keeps screens** that match the condition
- ❌ **Removes screens** after the matching screen
- 📊 **Perfect for**: Workflow completion

#### 🎯 Use when

- **Payment completion** - remove checkout flow
- **Order success** - back to product list
- **Workflow finished** - clean up intermediate screens

**Code Example:**

### 5. `goBack()` - Go back to previous screen

**⬅️ Pop current screen and return to previous screen**

#### 🔄 Stack Flow

```
BEFORE: [Home] → [List] → [Detail] → [Edit] ← Current
                           goBack()
AFTER:  [Home] → [List] → [Detail] ← Current (Edit removed)
```

#### 📋 What happens

- ➖ **Removes current screen** from stack
- 🔙 **Returns to previous screen**
- 💾 **Can return data** to previous screen
- ✅ **Most common navigation action**

#### 🎯 Use when

- **Cancel/Save** actions in forms
- **Back button** functionality
- **Modal/dialog** dismissal
- **Result communication** between screens

**Code Example:**

### 6. `popUntil()` - Pop until condition

**🔄 Pop screens until condition is met**

#### 🔄 Stack Flow

```
BEFORE: [Home] → [List] → [Detail] → [Edit] → [Settings] ← Current
                           popUntil(isList)
AFTER:  [Home] → [List] ← Current (removed Detail, Edit, Settings)
```

#### 📋 What happens

- ➖ **Removes screens** until condition is met
- ✅ **Stops at first screen** that matches condition
- 🔙 **Returns to specific screen** in history
- 📍 **Useful for**: Quick navigation to known screens

#### 🎯 Use when

- **Cancel workflow** - back to main screen
- **Quick home** - jump to specific screen
- **Error recovery** - back to safe screen

**Code Example:**

### 7. `popToRoot()` - Pop to root screen

**🏠 Pop all screens and return to root (first) screen**

#### 🔄 Stack Flow

```
BEFORE: [Home] → [List] → [Detail] → [Edit] → [Settings] ← Current
                 popToRoot()
AFTER:  [Home] ← Current (removed all others)
```

#### 📋 What happens

- 🏠 **Removes all screens** except root
- 🔙 **Returns to first screen** in navigation stack
- ❌ **Clears navigation history**
- ⚡ **Quick navigation** shortcut

#### 🎯 Use when

- **Cancel complex workflow** - back to home
- **Emergency exit** - quick return to safety
- **Reset navigation** - clean navigation state

**Code Example:**

### 8. `canPop()` - Check if can go back

**👁️ Check if there are screens to pop (can go back)**

#### 🔄 Stack Flow

```
Stack: [Home] → [List] → [Detail] ← Current
canPop() = true (can go back to List)

Stack: [Home] ← Current (root screen)
canPop() = false (cannot go back)
```

#### 📋 Scenarios

| Scenario             | Stack State | canPop()   | Action           |
| -------------------- | ----------- | ---------- | ---------------- |
| **Multiple screens** | `A → B → C` | ✅ `true`  | Show back button |
| **Single screen**    | `A` (root)  | ❌ `false` | Show exit dialog |

#### 🎯 Use when

- **Back button visibility** logic
- **Exit confirmation** dialogs
- **Navigation UI** state management
- **Swipe-to-go-back** gestures

**Code Example:**

## 🎨 Transition Types

### Slide Transitions

| Type               | Visual      | Use Case               |
| ------------------ | ----------- | ---------------------- |
| `slideRight`       | `[■] → [□]` | Standard navigation    |
| `slideLeft`        | `[■] ← [□]` | Back animation         |
| `slideUp`          | `[■] ↑ [□]` | Bottom sheet, Modal    |
| `slideDown`        | `[■] ↓ [□]` | Dropdown, Notification |
| `slideTopLeft`     | `[■] ↖ [□]` | Creative effect        |
| `slideTopRight`    | `[■] ↗ [□]` | Creative effect        |
| `slideBottomLeft`  | `[■] ↙ [□]` | Creative effect        |
| `slideBottomRight` | `[■] ↘ [□]` | Creative effect        |

```dart
NavigationManager.instance.navigateTo(
  ModalScreen(),
  transition: TransitionType.slideUp,
);
```

---

### Basic Transitions

| Type    | Visual      | Description   | Use Case           |
| ------- | ----------- | ------------- | ------------------ |
| `fade`  | `[■] ○ [□]` | Fade in/out   | Elegant transition |
| `scale` | `[■] ◉ [□]` | Scale up/down | Focus attention    |
| `size`  | `[■] ▭ [□]` | Size change   | Expand/collapse    |

```dart
NavigationManager.instance.navigateTo(
  GalleryScreen(),
  transition: TransitionType.fade,
  duration: const Duration(milliseconds: 500),
);
```

---

### Rotation Transitions

| Type        | Visual      | Description          | Use Case  |
| ----------- | ----------- | -------------------- | --------- |
| `rotation`  | `[■] ↻ [□]` | 360° rotation + fade | Loading   |
| `rotationY` | `[■] ⟲ [□]` | 3D Y-axis flip       | Card flip |

```dart
NavigationManager.instance.navigateTo(
  CardDetailScreen(),
  transition: TransitionType.rotationY,
  duration: const Duration(milliseconds: 600),
);
```

---

### Combined Transitions

| Type             | Visual       | Description    | Use Case         |
| ---------------- | ------------ | -------------- | ---------------- |
| `slideAndFade`   | `[■] ↑○ [□]` | Slide + Fade   | Material Design  |
| `scaleAndFade`   | `[■] ◉○ [□]` | Scale + Fade   | Premium feel     |
| `slideAndRotate` | `[■] →↻ [□]` | Slide + Rotate | Dynamic, Playful |

```dart
NavigationManager.instance.navigateTo(
  ProductDetailScreen(),
  transition: TransitionType.slideAndFade,
);
```

---

### Zoom Transitions

| Type      | Visual        | Description      | Use Case       |
| --------- | ------------- | ---------------- | -------------- |
| `zoom`    | `[■] ◎ [□]`   | Zoom 0% → 100%   | Popup, Modal   |
| `zoomIn`  | `[■] ◉→○ [□]` | Zoom 150% → 100% | Image viewer   |
| `zoomOut` | `[■] ○→◉ [□]` | Zoom 50% → 100%  | Reveal content |

```dart
NavigationManager.instance.navigateTo(
  ImageViewerScreen(imageUrl),
  transition: TransitionType.zoomIn,
  duration: const Duration(milliseconds: 400),
);
```

---

### Platform Specific

| Type        | Description | Visual |
| ----------- | ----------- | ------ |
| `cupertino` | iOS native  |

```dart
NavigationManager.instance.navigateTo(
  SettingsScreen(),
  transition: TransitionType.cupertino,
);
```

---

## 💡 Usage Examples

### 🔐 Example 1: Authentication Flow

```
stateDiagram-v2
    [*] --> SplashScreen
    SplashScreen --> LoginScreen: First time
    SplashScreen --> HomeScreen: Auto-login

    LoginScreen --> LoadingScreen: Login tapped
    LoadingScreen --> HomeScreen: Success
    LoadingScreen --> LoginScreen: Failed

    HomeScreen --> ProfileScreen: Profile tapped
    ProfileScreen --> LoginScreen: Logout

    LoginScreen --> [*]: App closed

    note right of SplashScreen : navigateAndReplace()
    note right of LoginScreen : navigateAndClearAll()
    note right of HomeScreen : navigateTo()
    note right of ProfileScreen : navigateAndClearAll()
```

**Navigation Logic:**

```dart
// 1. App Start → Splash
@override
Widget build(BuildContext context) {
  return MaterialApp(
    navigatorKey: NavigationManager.instance.navigatorKey,
    home: SplashScreen(),
  );
}

// 2. Splash → Login/Home
class SplashScreen exts StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState exts State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    bool isLoggedIn = await checkLoginStatus();

    if (isLoggedIn) {
      NavigationManager.instance.navigateAndReplace(HomeScreen());
    } else {
      NavigationManager.instance.navigateAndReplace(LoginScreen());
    }
  }
}

// 3. Login → Home
class LoginScreen exts StatelessWidget {
  void _login() async {
    // Show loading
    NavigationManager.instance.navigateTo(LoadingScreen());

    bool success = await performLogin();
    if (success) {
      NavigationManager.instance.navigateAndClearAll(HomeScreen());
    } else {
      NavigationManager.instance.goBack();
      showErrorDialog();
    }
  }
}

// 4. Logout
void logout() {
  clearUserSession();
  NavigationManager.instance.navigateAndClearAll(LoginScreen());
}
```

---

### 🛒 Example 2: E-commerce Flow

```
stateDiagram-v2
    [*] --> ProductList
    ProductList --> ProductDetail: Product tapped
    ProductDetail --> CartScreen: Add to cart
    ProductDetail --> ProductList: Back

    CartScreen --> CheckoutScreen: Checkout
    CartScreen --> ProductList: Continue shopping

    CheckoutScreen --> PaymentScreen: Proceed
    CheckoutScreen --> CartScreen: Back

    PaymentScreen --> SuccessScreen: Payment success
    PaymentScreen --> PaymentScreen: Payment failed

    SuccessScreen --> ProductList: Continue shopping

    ProductList --> [*]: Exit app

    note right of ProductList : navigateTo()
    note right of CartScreen : navigateTo()
    note right of CheckoutScreen : navigateTo()
    note right of PaymentScreen : navigateTo()
    note right of SuccessScreen : navigateAndRemoveUntil()
```

**Navigation Logic:**

```dart
// 1. Product List → Product Detail
class ProductListScreen exts StatelessWidget {
  void _openProduct(Product product) {
NavigationManager.instance.navigateTo(
      ProductDetailScreen(product: product),
  transition: TransitionType.zoomIn,
);
  }
}

// 2. Product Detail → Add to Cart
class ProductDetailScreen exts StatelessWidget {
  void _addToCart() async {
    await addProductToCart();
NavigationManager.instance.navigateTo(
  CartScreen(),
  transition: TransitionType.slideUp,
);
  }
}

// 3. Cart → Checkout Flow
class CartScreen exts StatelessWidget {
  void _checkout() {
NavigationManager.instance.navigateTo(
  CheckoutScreen(),
  transition: TransitionType.slideRight,
);
  }
}

// 4. Checkout → Payment
class CheckoutScreen exts StatelessWidget {
  void _proceedToPayment() {
NavigationManager.instance.navigateTo(
  PaymentScreen(),
  transition: TransitionType.slideRight,
);
  }
}

// 5. Payment Success → Back to Products (remove checkout flow)
class PaymentSuccessScreen exts StatelessWidget {
  void _continueShopping() {
NavigationManager.instance.navigateAndRemoveUntil(
      ProductListScreen(),
  (route) => route.settings.name == '/products',
  transition: TransitionType.scaleAndFade,
);
  }
}
```

---

### 🔧 Example 3: Advanced Result Handling

**📋 Pattern for complex result communication between screens**

```
sequenceDiagram
    participant A as Screen A
    participant B as Screen B
    participant Nav as NavigationManager

    A->>Nav: navigateTo&lt;Result&gt;(B)
    Nav->>B: Push Screen B
    B->>B: User interacts
    B->>Nav: goBack&lt;Result&gt;(result)
    Nav->>A: Return to A with result
    A->>A: Handle result
```

```dart
// Define result types for type safety
enum EditResult { saved, cancelled, deleted }

// Screen A - Caller
class ProfileScreen exts StatelessWidget {
  void _editProfile() async {
final result = await NavigationManager.instance.navigateTo<EditResult>(
      EditProfileScreen(),
      transition: TransitionType.slideUp,
);

    // Handle the result
switch (result) {
  case EditResult.saved:
        _refreshProfile();
        _showSnackBar('Profile updated!');
    break;
  case EditResult.deleted:
        _deleteAccount();
        NavigationManager.instance.navigateAndClearAll(LoginScreen());
    break;
  case EditResult.cancelled:
  case null:
        // User cancelled, do nothing
    break;
    }
  }
}

// Screen B - Callee
class EditProfileScreen exts StatelessWidget {
  void _saveProfile() {
    // Save logic here...
  NavigationManager.instance.goBack<EditResult>(EditResult.saved);
  }

  void _deleteProfile() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => NavigationManager.instance.goBack(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              NavigationManager.instance.goBack();
              // Navigate back to login after dialog closes
              Future.delayed(Duration(milliseconds: 200), () {
                NavigationManager.instance.goBack<EditResult>(EditResult.deleted);
              });
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ Best Practices

### 🎨 Transition Guidelines

| Screen Type             | Recommed Transition | Duration | Use Case              |
| ----------------------- | ------------------- | -------- | --------------------- |
| **Standard Navigation** | `slideRight`        | 300ms    | List → Detail         |
| **Modals/Dialogs**      | `slideUp`           | 250ms    | Bottom sheets, popups |
| **Image viewers**       | `zoomIn`            | 400ms    | Gallery, photos       |
| **Authentication**      | `fade`              | 300ms    | Login, logout         |
| **Loading states**      | `scale`             | 200ms    | Quick feedback        |
| **Errors**              | `slideDown`         | 350ms    | Notifications         |

### ⚡ Performance Tips

> ⚠️ **Warning**: Avoid complex transitions on low- devices
>
> 💡 **Tip**: Cache transition durations in constants for consistency

```dart
class NavigationConstants {
  static const quickTransition = Duration(milliseconds: 200);
  static const normalTransition = Duration(milliseconds: 300);
  static const slowTransition = Duration(milliseconds: 500);
}
```

### 🛡️ Navigation Safety

> ⚠️ **Critical**: Always check `canPop()` before calling `goBack()`

```dart
// ❌ Dangerous - may crash
NavigationManager.instance.goBack();

// ✅ Safe - check first
if (NavigationManager.instance.canPop()) {
  NavigationManager.instance.goBack();
} else {
  // Handle root screen case
  showExitDialog();
}
```

### 🔒 Type Safety Best Practices

> 💡 **Pro Tip**: Use enums for complex result types

```dart
// Define result types
enum NavigationResult {
  success,
  cancelled,
  error,
}

// Use with generics
final result = await NavigationManager.instance.navigateTo<NavigationResult>(
  EditScreen(),
);

// Type-safe handling
switch (result) {
  case NavigationResult.success:
    refreshData();
    break;
  case NavigationResult.error:
    showError();
    break;
  default:
    break;
}
```

### 🧹 Stack Management Guidelines

```
flowchart TD
    A[Navigation Decision] --> B{What do you want?}
    B -->|Clear history| C[navigateAndClearAll]
    B -->|Remove some screens| D[navigateAndRemoveUntil]
    B -->|Replace current| E[navigateAndReplace]
    B -->|Add new screen| F[navigateTo]

    C --> G[Perfect for logout/auth]
    D --> H[Perfect for workflow completion]
    E --> I[Perfect for screen updates]
    F --> J[Perfect for forward navigation]
```

| Scenario              | Method                     | When to Use                            |
| --------------------- | -------------------------- | -------------------------------------- |
| **User logs out**     | `navigateAndClearAll()`    | Clear all history, fresh start         |
| **Payment completed** | `navigateAndRemoveUntil()` | Remove checkout flow, back to products |
| **Screen refresh**    | `navigateAndReplace()`     | Update current screen content          |
| **View details**      | `navigateTo()`             | Standard forward navigation            |

5. **Navigation Stack Management**
   - Use `navigateAndClearAll()` for logout flows
   - Use `navigateAndRemoveUntil()` for workflow completions
   - Use `popToRoot()` for quick navigation to home

---

## 🎓 Advanced Tips

### Tip 1: Custom Transition Duration Per Screen Type

```dart
class NavigationHelper {
  static const quickDuration = Duration(milliseconds: 200);
  static const normalDuration = Duration(milliseconds: 300);
  static const slowDuration = Duration(milliseconds: 500);

  static void navigateToModal(Widget screen) {
    NavigationManager.instance.navigateTo(
      screen,
      transition: TransitionType.slideUp,
      duration: quickDuration,
    );
  }

  static void navigateToDetail(Widget screen) {
    NavigationManager.instance.navigateTo(
      screen,
      transition: TransitionType.zoomIn,
      duration: normalDuration,
    );
  }
}
```

### Tip 2: Named Routes Alternative

```dart
// You can add route names for debugging
class RouteNames {
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
}

// Use with navigateAndRemoveUntil
NavigationManager.instance.navigateAndRemoveUntil(
  SuccessScreen(),
  (route) => route.settings.name == RouteNames.home,
);
```

---

## 🐛 Troubleshooting

### 🔍 **Navigation Issue Decision Tree**

```
flowchart TD
    A[Navigation Issue] --> B{What problem?}
    B -->|Screen not showing| C[Check navigatorKey]
    B -->|Back button broken| D[Check canPop]
    B -->|Animation laggy| E[Check performance]
    B -->|Result not returned| F[Check generics]

    C --> C1[MaterialApp setup]
    D --> D1[canPop check]
    E --> E1[Duration & transition]
    F --> F1[Generic types]

    C1 --> G[✅ Fixed]
    D1 --> G
    E1 --> G
    F1 --> G
```

---

### 🚨 Issue 1: "Navigator operation requested with a context that does not include a Navigator"

**❌ Error:** `Navigator operation requested with a context that does not include a Navigator`

**🔍 Root Cause:** NavigationManager.navigatorKey not connected to MaterialApp

#### ✅ Solution

```dart
// 🔧 main.dart - Connect navigatorKey
void main() {
  runApp(MyApp());
}

class MyApp exts StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 🗝️ CRITICAL: Connect the navigator key
  navigatorKey: NavigationManager.instance.navigatorKey,
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
```

> ⚠️ **Important**: This is the most common setup mistake. Always verify navigatorKey is connected!

---

### 🔙 Issue 2: Back button not working

**❌ Symptoms:**

- Back button doesn't respond
- `goBack()` crashes the app
- App freezes on back gesture

#### ✅ Solution

```dart
// 🛡️ Safe back navigation pattern
class SafeBackButton exts StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: NavigationManager.instance.canPop()
        ? () => NavigationManager.instance.goBack()
        : null, // Disabled when can't pop
    );
  }
}

// 🔄 Alternative: With exit confirmation
void handleBackPress() {
if (NavigationManager.instance.canPop()) {
  NavigationManager.instance.goBack();
  } else {
    // Show exit dialog for root screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App?'),
        content: Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // Exit app
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }
}
```

---

### 🎬 Issue 3: Transition animation not smooth

**❌ Symptoms:**

- Jerky animations
- Transitions feel laggy
- Performance drops during navigation

#### ✅ Solutions (in order of preference)

```dart
// 🎯 Solution 1: Optimize duration and transition
NavigationManager.instance.navigateTo(
  HeavyScreen(),
  transition: TransitionType.fade, // Simpler than complex transitions
  duration: const Duration(milliseconds: 200), // Faster
);

// 🎯 Solution 2: Use constants for consistency
class NavigationConstants {
  static const quickTransition = Duration(milliseconds: 150);
  static const fastTransition = Duration(milliseconds: 250);
  static const normalTransition = Duration(milliseconds: 300);
  static const slowTransition = Duration(milliseconds: 450);
}

// 🎯 Solution 3: Preload heavy screens
class _HomeScreenState exts State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Preload heavy screen in background
    Future.delayed(Duration.zero, () {
      NavigationManager.instance.navigateTo(
        HeavyDetailScreen(),
        transition: TransitionType.fade,
      );
      // Immediately go back to cache the screen
      NavigationManager.instance.goBack();
    });
  }
}
```

#### 🚀 Performance Checklist

- [ ] Use `TransitionType.fade` for heavy screens
- [ ] Keep duration under 400ms
- [ ] Avoid complex transitions on low- devices
- [ ] Preload screens when possible
- [ ] Use `const` constructors in widgets

---

## 🤝 Contributing

### 🌟 **How to Contribute**

We welcome contributions! Here's how you can help improve the Navigation System:

#### 🐛 Found a Bug?

1. **Check existing issues** in the repository
2. **Create a new issue** with:
   - Clear title describing the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Device/OS information

#### 💡 Have a Feature Request?

1. **Open a feature request** issue
2. **Describe the use case** and why it would be valuable
3. **Include mockups** if applicable

#### 🛠️ Want to Contribute Code?

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Write tests** for new functionality
4. **Ensure all tests pass**
5. **Submit a pull request** with:
   - Clear description of changes
   - Reference to related issues
   - Screenshots for UI changes

#### 📝 Documentation Improvements

- Fix typos or unclear explanations
- Add more examples or use cases
- Improve diagrams or visual aids
- Translate to other languages

---

## 📋 Version History

| Version | Date       | Changes                                                        |
| ------- | ---------- | -------------------------------------------------------------- |
| v1.0.0  | 2025-01-01 | Initial release with 8 navigation methods and 20+ transitions  |
| v1.1.0  | 2025-01-15 | Added platform-specific transitions, performance optimizations |
| v1.2.0  | 2025-02-01 | Enhanced type safety, improved error handling                  |

---

## 📚 References & Resources

### 📖 Official Documentation

- [Flutter Navigation Documentation](https://docs.flutter.dev/cookbook/navigation)
- [Material Design Motion Guidelines](https://material.io/design/motion)
- [iOS Human Interface Guidelines - Navigation](https://developer.apple.com/design/human-interface-guidelines/navigation)

### 🎨 Design Inspiration

- [Flutter Navigation Patterns](https://flutter.dev/docs/development/ui/navigation)
- [Material Design Transitions](https://material.io/design/motion/the-motion-system.html)
- [iOS Transition Patterns](https://developer.apple.com/design/human-interface-guidelines/ios/app-architecture/navigation/)

### 🛠️ Related Packages

- [Flutter Navigator 2.0](https://flutter.dev/docs/development/ui/navigation#nav2)
- [Go Router](https://pub.dev/packages/go_router) - Alternative routing solution
- [Auto Route](https://pub.dev/packages/auto_route) - Code generation approach

---

## ⚖️ License

This Navigation System is released under the **MIT License**.

```text
MIT License

Copyright (c) 2025 Flutter Template Project

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🎉 Happy Coding!

**Built with ❤️ for the Flutter community**

---

_Last updated: January 2025_
