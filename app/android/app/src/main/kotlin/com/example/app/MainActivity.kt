package com.example.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d("LocationService", "Started service")

        createNotificationChannel(this);
        val serviceIntent = Intent(this, LocationService::class.java)

        startService(serviceIntent)
        Log.d("LocationService", "Started service")
    }


    private fun createNotificationChannel(context: Context) {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Travelert"
            val descriptionText = "Notification Channel"
            val importance = NotificationManager.IMPORTANCE_NONE
            val channel = NotificationChannel("123093.LocationService", name, importance).apply {
                description = descriptionText
            }
            // Register the channel with the system
            val notificationManager: NotificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}
