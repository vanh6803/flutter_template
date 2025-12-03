# Base Dialog Usage

Hướng dẫn sử dụng `BaseDialog<T>` trong Flutter.  
`BaseDialog` giúp bạn tạo dialog **tái sử dụng**, hỗ trợ **blur**, **transition tuỳ biến**, và **kết quả type-safe**.

---

## 🚀 Cách hoạt động

- Kế thừa `BaseDialog<T>` → định nghĩa UI trong `build(context)`.
- Gọi `show()` để hiển thị, trả về `Future<T?>`.
- Gọi `close(context, result)` để đóng và trả kết quả.
- Hỗ trợ:
  - Blur barrier (`barrierBlurSigma`).
  - Transition tuỳ biến (`transitionBuilder`).
  - Hooks vòng đời: `onCompleted`, `onPopped`.

---

## ⚙️ Các tham số chính

| Thuộc tính              | Kiểu                 | Mặc định          | Mô tả |
|--------------------------|----------------------|------------------|-------|
| `barrierDismissible`    | `bool`              | `true`           | Cho phép chạm ra ngoài để đóng |
| `barrierColor`          | `Color`             | `0x80000000`     | Màu nền khi hiển thị dialog |
| `barrierBlurSigma`      | `double?`           | `null`           | Nếu > 0 → bật blur nền |
| `useRootNavigator`      | `bool`              | `true`           | Dùng root navigator hay không |
| `transitionDuration`    | `Duration`          | 200ms            | Thời gian hiệu ứng mở |
| `reverseTransitionDuration` | `Duration`      | 150ms            | Thời gian hiệu ứng đóng |
| `onCompleted`           | `VoidCallback?`     | `null`           | Gọi sau khi dialog đóng |
| `onPopped`              | `(didPop, result)`  | `null`           | Gọi ngay khi dialog bị pop |

---

## 📝 Ví dụ sử dụng

### 1. Dialog thông báo

```dart
class InfoDialog extends BaseDialog<void> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Thông báo'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => close(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Gọi
await InfoDialog().show(context: context);
```

---

### 2. Dialog xác nhận (trả kết quả `bool`)

```dart
class ConfirmDialog extends BaseDialog<bool> {
  final String title;
  ConfirmDialog(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            Row(
              children: [
                TextButton(onPressed: () => close(context, false), child: const Text('Huỷ')),
                TextButton(onPressed: () => close(context, true), child: const Text('OK')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Gọi
final ok = await ConfirmDialog('Xoá mục này?').show(context: context);
if (ok == true) {
  // xử lý xoá
}
```

---

### 3. Dialog nhập dữ liệu (trả `custom object`)

```dart
class InputDialog extends BaseDialog<String> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _controller),
            ElevatedButton(
              onPressed: () => close(context, _controller.text),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}

// Gọi
final input = await InputDialog().show(context: context);
print('User nhập: $input');
```

---

## 🎨 Tuỳ biến transition

```dart
@override
Widget transitionBuilder(BuildContext c, Animation<double> a1, Animation<double> a2, Widget child) {
  final curved = CurvedAnimation(parent: a1, curve: Curves.easeOutCubic);
  return SlideTransition(
    position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(curved),
    child: FadeTransition(opacity: curved, child: child),
  );
}
```

---

## 💡 Lưu ý

- Không gọi `show()` trong `build()`.
- Dùng `close(context, result)` thay vì `Navigator.pop`.
- Với dialog loading → set `barrierDismissible = false`.
- Khi bật blur → nên dùng `barrierBlurSigma` khoảng `8–16` để mượt.
- Có thể dùng `navigatorKey` thay vì context:
  ```dart
  await InfoDialog().show(navigatorKey: NavigationManager.instance.navigatorKey);
  ```

---

## ✅ Checklist khi tạo dialog mới

- [ ] Kế thừa `BaseDialog<T>` đúng kiểu dữ liệu mong muốn.
- [ ] UI bọc `Material(color: Colors.transparent)` và `Center`.
- [ ] Dùng `close(context, result)` để pop.
- [ ] Xem xét `barrierDismissible` có phù hợp case không.
- [ ] Transition tuỳ biến đồng bộ với style app.

---

## 📌 Kết luận

`BaseDialog<T>` chuẩn hoá việc tạo dialog trong dự án Flutter:
- An toàn (type-safe, chống double-show).
- Dễ tái sử dụng (config, blur, transition).
- Dễ test & maintain.  
