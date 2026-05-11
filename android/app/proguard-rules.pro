# Flutter - Keep the entry point
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Sign-In rules
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Keep specific models or classes that might be used by reflection or JNI
-keep class com.designabear.dab_mobile.** { *; }

# Fix R8 "Missing class" errors for Play Core (common in Flutter)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.internal.**
