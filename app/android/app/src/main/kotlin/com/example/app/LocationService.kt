package com.example.app

import android.Manifest
import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Geocoder
import android.location.Location
import android.os.IBinder
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import java.util.*

class LocationService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)

        Log.d("LocationService", "Message to start notif received")

        val notif = NotificationCompat.Builder(this, "123093.LocationService")
            .setContentTitle("Looking for nearby places...")
            .setContentText("Scanning the area...")
            .setSmallIcon(R.drawable.common_full_open_on_phone)
            .setOngoing(true)
//            .setSubText("Scanning the area...")
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .build()

        startForeground(1, notif)
        requestLocationUpdates()

        return START_REDELIVER_INTENT
    }

    override fun onBind(intent: Intent?): IBinder? {
        TODO("Not yet implemented")
    }

    private fun requestLocationUpdates() {
        val request = LocationRequest()
        request.setInterval(60000)
        request.setFastestInterval(30000)
        request.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
        val client: FusedLocationProviderClient =
            LocationServices.getFusedLocationProviderClient(this)

        val permission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        )
        if (permission == PackageManager.PERMISSION_GRANTED) { // Request location updates and when an update is
            // received, store the location in Firebase
            client.requestLocationUpdates(request, object : LocationCallback() {
                override fun onLocationResult(locationResult: LocationResult) {
                    val location: Location = locationResult.getLastLocation()
                    val latitude = location.latitude
                    val longitude = location.longitude
                    val geocoder = Geocoder(applicationContext, Locale.getDefault())
                    val addresses = geocoder.getFromLocation(latitude, longitude, 1)
                    Log.d("LocationService", "location update $addresses")

                    val prefs = applicationContext.getSharedPreferences(
                        getString(R.string.shared_prefs_key),
                        Context.MODE_PRIVATE
                    )

                    val url = "https://travelert.herokuapp.com"

                    with(prefs.edit()){
                        putString("placeName", "India Gate")
                        putString("lat", latitude.toString())
                        putString("long", longitude.toString())
                    }

                    triggerAlarm()
                }
            }, null)
        }
    }

    @SuppressLint("UnspecifiedImmutableFlag")
    private fun triggerAlarm() {
        val am: AlarmManager =
            applicationContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val i: Intent = Intent(applicationContext, AlarmReceiver::class.java)
        val pendingIntent: PendingIntent = PendingIntent.getBroadcast(applicationContext, 0, i, 0)
        am.set(AlarmManager.RTC_WAKEUP, System.currentTimeMillis(), pendingIntent)
    }

}