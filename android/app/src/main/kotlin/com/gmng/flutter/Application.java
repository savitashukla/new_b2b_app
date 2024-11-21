package com.gmng.flutter;

import com.clevertap.android.sdk.ActivityLifecycleCallback;

import io.flutter.app.FlutterApplication;

class MyApplication extends FlutterApplication {
    @java.lang.Override
    public void onCreate() {
        ActivityLifecycleCallback.register(this); //<--- Add this before super.onCreate()
        super.onCreate();
    }
}