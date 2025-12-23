# 保留 Flutter 和 Dart 的基本类
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# 保留 MainActivity、Application 等入口类
-keep class com.viontv.yyy.app.MainActivity { *; }
-keep class com.viontv.yyy.app.Application { *; }
-keep class com.google.android.play.core.** { *; }

# 如果你用到 JSON 解析库，比如 Gson
# -keep class com.google.gson.** { *; }
# -keep class androidx.lifecycle.** { *; }


# ------------------------
# 保留 VideoPlayer 插件相关类
# ------------------------
-keep class io.flutter.plugins.video.** { *; }

# ------------------------
# 保留 ExoPlayer 相关类（video_player 底层使用 ExoPlayer）
# ------------------------

# 保留 ExoPlayer 核心类
-keep class com.google.android.exoplayer2.** { *; }
-keep class com.google.android.exoplayer2.source.** { *; }
-keep class com.google.android.exoplayer2.trackselection.** { *; }
-keep class com.google.android.exoplayer2.upstream.** { *; }
-keep class com.google.android.exoplayer2.video.** { *; }
-keep class com.google.android.exoplayer2.audio.** { *; }
-keep class com.google.android.exoplayer2.extractor.** { *; }
-keep class com.google.android.exoplayer2.text.** { *; }
-keep class com.google.android.exoplayer2.metadata.** { *; }

# 保留 ExoPlayer 回调接口和异常类
-keep class com.google.android.exoplayer2.ExoPlayer { *; }
-keep class com.google.android.exoplayer2.Player$* { *; }
-keep class com.google.android.exoplayer2.upstream.** { *; }

# ------------------------
# 保留 VideoPlayer 插件的 JNI 类
# ------------------------

-keep class io.flutter.plugins.video.** { *; }

# ------------------------
# 保留 Flutter 插件相关的类
# ------------------------

-keep class io.flutter.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }

# ------------------------
# 处理其他第三方库的常见混淆规则
# ------------------------

###############################################
# Dio 网络库保留
###############################################
-keep class dio.** { *; }
-dontwarn dio.**

###############################################
# OkHttp & Okio
###############################################
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

-keep class okio.** { *; }
-dontwarn okio.**

###############################################
# JSON 解析 Gson / JSON Serializable 保护
###############################################
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# 关键：保持 json_serializable 自动生成的 _$xxxFromJson 等函数
-keep class *.*$* { *; }

# 保持你的 model（按你的实际包名）
-keep class com.sanpplay.** { *; }


# 保留 Firebase 类（如果你使用 Firebase）
-keep class com.google.firebase.** { *; }

# 保留其他常见库（例如 Flutter 插件的配置）
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.common.** { *; }

# ------------------------
# 防止删除 Debug 信息类
# ------------------------

# 防止 R8 移除调试日志
-dontwarn org.apache.**  
-dontwarn com.squareup.okhttp.**

# ------------------------
# 提供其他可能的应用程序（如 Firebase、Analytics、Admob）支持
# ------------------------

# Firebase SDK 保留规则
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# ------------------------
# 如果需要打包混淆生成 APK，启用这些规则
# ------------------------

# 启用混淆后，保留一切 Flutter 和相关组件
-keep class io.flutter.** { *; }

# ------------------------
# 如果你遇到特定的警告或缺失的类，使用 `-dontwarn` 跳过
# ------------------------

-dontwarn com.google.android.play.core.**  # Play Core SDK 警告
-dontwarn com.google.firebase.**          # Firebase 警告
-dontwarn com.squareup.okhttp3.**         # OkHttp 警告
-dontwarn okhttp3.**                     # OkHttp 警告

