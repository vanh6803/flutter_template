/// Các kiểu hiệu ứng chuyển màn hình
///
/// Ví dụ sử dụng:
/// ```dart
/// // Slide từ dưới lên (như Bottom Sheet)
/// navigateTo(ScreenB(), transition: TransitionType.slideUp);
///
/// // Fade mượt mà (thanh lịch)
/// navigateTo(ScreenC(), transition: TransitionType.fade);
///
/// // Zoom in đẹp mắt (xem ảnh, chi tiết)
/// navigateTo(DetailScreen(), transition: TransitionType.zoomIn);
///
/// // 3D flip (wow effect)
/// navigateTo(CardDetailScreen(), transition: TransitionType.rotationY);
///
/// // iOS style (native feeling)
/// navigateTo(ProfileScreen(), transition: TransitionType.cupertino);
/// ```
enum TransitionType {
  // ===== Slide transitions (Trượt) =====
  /// [→] Slide từ phải qua trái (Android default)
  /// Use: Navigation chuẩn, chuyển trang thông thường
  slideRight,

  /// [←] Slide từ trái qua phải
  /// Use: Back animation, hoặc chuyển về màn trước
  slideLeft,

  /// [↑] Slide từ dưới lên trên
  /// Use: Bottom sheet style, modal, form input
  slideUp,

  /// [↓] Slide từ trên xuống dưới
  /// Use: Dropdown style, notification expansion
  slideDown,

  /// [↖] Slide từ góc trên trái
  /// Use: Unique transition, creative effect
  slideTopLeft,

  /// [↗] Slide từ góc trên phải
  /// Use: Unique transition, creative effect
  slideTopRight,

  /// [↙] Slide từ góc dưới trái
  /// Use: Unique transition, creative effect
  slideBottomLeft,

  /// [↘] Slide từ góc dưới phải
  /// Use: Unique transition, creative effect
  slideBottomRight,

  // ===== Basic transitions (Cơ bản) =====
  /// [○] Hiệu ứng mờ dần (fade in/out)
  /// Use: Smooth transition, elegant, subtle change
  fade,

  /// [◉] Hiệu ứng phóng to/thu nhỏ (scale)
  /// Use: Focus attention, zoom effect
  scale,

  /// [▭] Hiệu ứng thay đổi kích thước
  /// Use: Expand/collapse animation
  size,

  // ===== Rotation transitions (Xoay) =====
  /// [↻] Xoay 360 độ kèm fade
  /// Use: Loading style, refresh, fun effect
  rotation,

  /// [⟲] Xoay theo trục Y (3D flip)
  /// Use: Card flip, reveal content, wow effect
  rotationY,

  // ===== Combined transitions (Kết hợp) =====
  /// [↑○] Slide nhẹ kèm fade (Material Design style)
  /// Use: Modern, smooth, professional transition
  slideAndFade,

  /// [◉○] Scale kèm fade (elegant)
  /// Use: Elegant, premium feel, spotlight
  scaleAndFade,

  /// [→↻] Slide kèm xoay nhẹ
  /// Use: Dynamic, playful, attention-grabbing
  slideAndRotate,

  // ===== Zoom transitions (Phóng to/thu nhỏ) =====
  /// [◎] Zoom từ 0 đến 100%
  /// Use: Pop-up effect, modal dialog
  zoom,

  /// [◉→○] Zoom in từ 150% xuống 100% (kèm fade)
  /// Use: Image viewer, detail focus, dramatic entrance
  zoomIn,

  /// [○→◉] Zoom out từ 50% lên 100% (kèm fade)
  /// Use: Growing effect, reveal, expand to view
  zoomOut,

  // ===== Platform specific =====
  /// [iOS] Hiệu ứng iOS (slide từ phải + shadow)
  /// Use: Native iOS feeling, consistent with platform
  cupertino,
}
