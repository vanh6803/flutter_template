# README — Snippets “BaseStatefulWidget + BaseState” cho VS Code & Android Studio/IntelliJ

Tài liệu này hướng dẫn team cấu hình **Snippets** để tạo nhanh khung màn hình Flutter theo kiến trúc **BaseStatefulWidget + BaseState** (kèm lifecycle rõ ràng) và cách sử dụng trong dự án MVVM (Provider/GetIt).

---

## 0) Mục tiêu

* Rút gọn boilerplate: chỉ cần gõ `baseview` → sinh ra **Widget + State** kế thừa `BaseState`, có sẵn `onInitSync`, `onReady`, `keepAlive`, v.v.
* Chuẩn hoá vòng đời UI cho team: code cần context viết ở `onReady`, code init thuần ở `onInitSync`.
* Có biến thể **Ticker** (`baseviewt`) dành cho màn hình cần `AnimationController`.

> **Không cần cài plugin**: VS Code dùng **User Snippets** (built-in). Android Studio/IntelliJ dùng **Live Templates** (built-in).

---

## 1) Chuẩn bị: Base lớp nền (copy vào project)

> Nếu bạn đã có sẵn Base tương tự, có thể bỏ qua phần này.

**`base_state.dart`**

```dart
import 'package:flutter/material.dart';

/// Base widget: để type-safety và thống nhất cách tạo State
abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});
}

/// Base state: gom lifecycle + keepAlive + onReady (sau frame đầu)
abstract class BaseState<T extends BaseStatefulWidget> extends State<T>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<T> {
  // ====== Config có thể override ======
  @protected
  bool get keepAlive => false; // giữ state khi trong Tab/PageView/List

  @protected
  bool get usePostFrameOnReady => true; // gọi onReady sau frame đầu

  @protected
  Widget? get placeholderWhilePreparing => null; // null => render UI ngay

  // ====== Hooks cho team ======
  @protected
  void onInitSync() {}                     // chạy trong initState (không cần context)
  @protected
  void onReady() {}                        // chạy sau frame đầu (có context)
  @protected
  void onDispose() {}                      // chạy trước dispose

  // App lifecycle
  @protected
  void onAppLifecycleStateChanged(AppLifecycleState state) {}
  @protected
  void onResume() {}
  @protected
  void onPause() {}
  @protected
  void onInactive() {}
  @protected
  void onDetached() {}
  @protected
  void onHidden() {}

  // Environment changes
  @protected
  void onMemoryWarning() {}
  @protected
  void onPlatformBrightnessChanged() {}
  @protected
  void onTextScaleFactorChanged() {}
  @protected
  void onLocalesChanged(List<Locale>? locales) {}

  // Debug hot-reload
  @protected
  void onReassemble() {}

  /// Màn hình con phải override hàm này thay vì build()
  @protected
  Widget buildView(BuildContext context);

  // ====== Internal ======
  bool _readyCalled = false;
  bool _firstBuildDone = false;

  // ====== AutomaticKeepAliveClientMixin ======
  @override
  bool get wantKeepAlive => keepAlive;

  @protected
  @mustCallSuper
  void notifyKeepAliveChanged() => updateKeepAlive();

  // ====== Lifecycle wiring ======
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onInitSync();

    if (usePostFrameOnReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_readyCalled) {
          _readyCalled = true;
          onReady();
          if (!_firstBuildDone) setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    onDispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context); // cần cho keepAlive
    if (placeholderWhilePreparing != null && !_readyCalled) {
      return placeholderWhilePreparing!;
    }
    _firstBuildDone = true;
    return buildView(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onAppLifecycleStateChanged(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }

  @override
  void didHaveMemoryPressure() => onMemoryWarning();

  @override
  void didChangePlatformBrightness() => onPlatformBrightnessChanged();

  @override
  void didChangeTextScaleFactor() => onTextScaleFactorChanged();

  @override
  void didChangeLocales(List<Locale>? locales) => onLocalesChanged(locales);

  @override
  void reassemble() {
    super.reassemble();
    onReassemble();
  }
}

/// Biến thể có Ticker nếu cần AnimationController
abstract class BaseStateWithTicker<T extends BaseStatefulWidget>
    extends BaseState<T> with SingleTickerProviderStateMixin<T> {}
```

---

## 2) VS Code — cài đặt User Snippets

### 2.1. Mở file snippets cho Dart

* **Command Palette** → gõ: `Preferences: Configure User Snippets`
* Chọn **`dart.json`** (tạo mới nếu chưa có)

### 2.2. Thêm 2 snippets: `baseview` và `baseviewt`

> Dán **toàn bộ JSON** dưới đây vào `dart.json`:

```json
{
  "BaseStatefulWidget + BaseState": {
    "prefix": "baseview",
    "body": [
      "class ${1:MyPage} extends BaseStatefulWidget {",
      "  const ${1:MyPage}({super.key});",
      "  @override",
      "  State<${1:MyPage}> createState() => _${1:MyPage}State();",
      "}",
      "",
      "class _${1:MyPage}State extends BaseState<${1:MyPage}> {",
      "  @override",
      "  bool get keepAlive => ${2:true};",
      "",
      "  @override",
      "  void onInitSync() {",
      "    // TODO: init không cần context (controller/di/stream...)",
      "  }",
      "",
      "  @override",
      "  void onReady() {",
      "    // TODO: logic cần context sau frame đầu (SnackBar/Dialog/Provider.read...)",
      "  }",
      "",
      "  @override",
      "  Widget buildView(BuildContext context) {",
      "    return const Scaffold(",
      "      body: Center(child: Text('${1:MyPage}')),",
      "    );",
      "  }",
      "}"
    ],
    "description": "Generate BaseStatefulWidget + BaseState skeleton (with keepAlive/onInitSync/onReady)"
  },
  "BaseStatefulWidget + BaseStateWithTicker": {
    "prefix": "baseviewt",
    "body": [
      "class ${1:MyAnimatedPage} extends BaseStatefulWidget {",
      "  const ${1:MyAnimatedPage}({super.key});",
      "  @override",
      "  State<${1:MyAnimatedPage}> createState() => _${1:MyAnimatedPage}State();",
      "}",
      "",
      "class _${1:MyAnimatedPage}State extends BaseStateWithTicker<${1:MyAnimatedPage}> {",
      "  late final AnimationController _ctrl =",
      "      AnimationController(vsync: this, duration: const Duration(milliseconds: 300));",
      "",
      "  @override",
      "  void onDispose() {",
      "    _ctrl.dispose();",
      "    super.onDispose();",
      "  }",
      "",
      "  @override",
      "  Widget buildView(BuildContext context) {",
      "    return const Scaffold(",
      "      body: Center(child: Text('${1:MyAnimatedPage}')),",
      "    );",
      "  }",
      "}"
    ],
    "description": "Generate BaseStatefulWidget + BaseStateWithTicker skeleton (AnimationController-ready)"
  }
}
```

### 2.3. Cách dùng

* Trong file `.dart`, gõ `baseview` → **Tab** → sửa tên lớp & nội dung.
* Nếu cần animation: gõ `baseviewt`.

> **Tip**: Bật **Settings Sync** để chia sẻ `dart.json` cho cả team.

---

## 3) Android Studio / IntelliJ — cài đặt Live Templates

### 3.1. Tạo Live Template

* **macOS**: *Preferences… → Editor → Live Templates*
* **Windows/Linux**: *File → Settings… → Editor → Live Templates*
* Chọn một group (hoặc tạo group “Flutter”), nhấn **+ → Live Template**
* **Abbreviation**: `baseview`
* **Description**: “BaseStatefulWidget + BaseState skeleton”
* **Template text**: dán nội dung dưới đây
* Nhấn **Define…** → tick **Dart**
* **Apply → OK**

**Template text — `baseview`**

```
class $NAME$ extends BaseStatefulWidget {
  const $NAME$({super.key});

  @override
  State<$NAME$> createState() => _$NAME$State();
}

class _$NAME$State extends BaseState<$NAME$> {
  @override
  bool get keepAlive => true;

  @override
  void onInitSync() {
    // TODO: init không cần context (controller/di/stream...)
  }

  @override
  void onReady() {
    // TODO: logic cần context sau frame đầu (SnackBar/Dialog/Provider.read...)
  }

  @override
  Widget buildView(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('$NAME$')),
    );
  }
}
```

> **Cách dùng**: Trong file `.dart`, gõ `baseview` → **Tab** → nhập `$NAME$`.

### 3.2. Biến thể có Ticker (animation)

* Tạo Live Template mới, **Abbreviation**: `baseviewt`, **Template text**:

```
class $NAME$ extends BaseStatefulWidget {
  const $NAME$({super.key});

  @override
  State<$NAME$> createState() => _$NAME$State();
}

class _$NAME$State extends BaseStateWithTicker<$NAME$> {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

  @override
  void onDispose() {
    _ctrl.dispose();
    super.onDispose();
  }

  @override
  Widget buildView(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('$NAME$')),
    );
  }
}
```

### 3.3. (Tuỳ chọn) File Template cho file Dart mới

* **Preferences → Editor → File and Code Templates → Files → +**
* **Name**: `BaseView Dart File` — **Extension**: `dart`
* **Template text**:

  ```
  import 'package:flutter/material.dart';

  class ${NAME} extends BaseStatefulWidget {
    const ${NAME}({super.key});

    @override
    State<${NAME}> createState() => _${NAME}State();
  }

  class _${NAME}State extends BaseState<${NAME}> {
    @override
    bool get keepAlive => true;

    @override
    Widget buildView(BuildContext context) {
      return const Scaffold(
        body: Center(child: Text('${NAME}')),
      );
    }
  }
  ```

> **Khác Live Templates**: File Template dùng khi bạn tạo **file mới**, không có Abbreviation.

### 3.4. Chia sẻ template cho team

* **Export Settings**: *File → Manage IDE Settings → Export Settings…* (chọn “Live Templates”)
* Thành viên khác **Import Settings**: *File → Manage IDE Settings → Import Settings…*

---

## 4) Ví dụ sử dụng với Provider (MVVM)

```dart
class HomePage extends BaseStatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> {
  @override
  bool get keepAlive => true;

  @override
  void onReady() {
    context.read<HomeViewModel>().fetchInitial();
  }

  @override
  Widget buildView(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: vm.items.length,
        itemBuilder: (_, i) => ListTile(title: Text(vm.items[i].title)),
      ),
    );
  }
}
```

---

## 5) Lưu ý & FAQ

* **`onInitSync` vs `onReady`**

    * `onInitSync()`: init không cần `BuildContext`.
    * `onReady()`: logic cần `context` (SnackBar, Dialog, Provider.read, MediaQuery…).

* **KeepAlive động**: Nếu điều kiện `keepAlive` thay đổi theo runtime, gọi `notifyKeepAliveChanged()`.

* **Tránh “nháy” UI trước khi `onReady`**: dùng `placeholderWhilePreparing` để hiển thị Loading tạm.

* **Không nhồi domain logic vào Base**: ViewModel/Service xử lý domain; Base chỉ là glue lifecycle/UI.

---

## 6) Troubleshooting

* Snippet không xuất hiện trong VS Code → kiểm tra:

    * File `dart.json` có format JSON hợp lệ.
    * Thuộc tính `"prefix"` đúng và bạn gõ đúng `prefix`.
    * Ngôn ngữ file là **Dart**.

* Live Template không bung trong Android Studio/IntelliJ:

    * Đã **Define… → tick Dart** chưa?
    * Abbreviation đúng?
    * Con trỏ đang ở **top-level** của file `.dart` (không ở giữa chuỗi/ký hiệu)?
    * Keymap Expand Live Template (mặc định **Tab**) có bị đổi không?

---

## 7) Gợi ý quản trị cho team

* **VS Code Settings Sync** để đồng bộ `dart.json`.
* **Android Studio/IntelliJ**: dùng **Export/Import Settings** cho Live Templates.
* Tạo **repo nội bộ** chứa:

    * `base_state.dart`
    * `snippets/vscode/dart.json`
    * `snippets/jetbrains/live-templates.md` (hướng dẫn import)
    * README này

---

Chúc team code nhanh – sạch – đồng nhất. Nếu bạn muốn, mình có thể đính kèm thêm bản **.zip** chứa mẫu project `base_state.dart` + snippets để import trực tiếp.
