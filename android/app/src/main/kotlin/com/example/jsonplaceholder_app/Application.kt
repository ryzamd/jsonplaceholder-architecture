package com.example.jsonplaceholder_app

import android.app.Application
import android.os.StrictMode

class Application : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Enable strict mode for development builds only
        if (isDebugBuild()) {
            StrictMode.setThreadPolicy(
                StrictMode.ThreadPolicy.Builder()
                    .detectAll()
                    .penaltyLog()
                    .build()
            )
            
            StrictMode.setVmPolicy(
                StrictMode.VmPolicy.Builder()
                    .detectLeakedSqlLiteObjects()
                    .detectLeakedClosableObjects()
                    .penaltyLog()
                    .build()
            )
        }
    }
    
    private fun isDebugBuild(): Boolean {
        return try {
            val packageInfo = packageManager.getPackageInfo(packageName, 0)
            (packageInfo.applicationInfo?.flags ?: 0) and android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE != 0
        } catch (e: Exception) {
            false
        }
    }
}