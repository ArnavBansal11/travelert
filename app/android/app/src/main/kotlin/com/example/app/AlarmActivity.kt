package com.example.app

import android.annotation.SuppressLint
import android.app.KeyguardManager
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import android.util.Log
import android.view.WindowManager
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import com.exmaple.app.OnSwipeTouchListener
import com.google.android.material.floatingactionbutton.FloatingActionButton


class AlarmActivity : AppCompatActivity() {

    private lateinit var swipeButton: FloatingActionButton

    @SuppressLint("ClickableViewAccessibility")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_alarm)

        Log.d("AlarmActivity", mp?.isPlaying.toString())

        if (mp?.isPlaying != true && mp != null) {
            mp?.reset()
            mp?.release()
            mp = null
            val defaultRingtoneUri: Uri =
                RingtoneManager.getActualDefaultRingtoneUri(this, RingtoneManager.TYPE_ALARM)
            mp = MediaPlayer()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                mp?.setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
            } else {
                mp?.setAudioStreamType(AudioManager.STREAM_ALARM)
            }
//            mp = MediaPlayer.create(this, defaultRingtoneUri)
            mp?.setDataSource(this, defaultRingtoneUri)
            mp?.prepare()
            mp?.start()
        }


        val v: Vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        v.cancel()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            v.vibrate(VibrationEffect.createWaveform(longArrayOf(1000, 1000), 0))
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        }

        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                    or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                    or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                    or WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
        )

        val keyGuardManager: KeyguardManager =
            (getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            keyGuardManager.requestDismissKeyguard(this, null)
        }

        val sharedPrefs =
            getSharedPreferences(getString(R.string.shared_prefs_key), Context.MODE_PRIVATE)

        val placeText: TextView = findViewById(R.id.centerName)
        val slotsText: TextView = findViewById(R.id.slotsAvailable)

        placeText.text = sharedPrefs.getString("placeName", "Taj Mahal")
        slotsText.text = "Within 1km of you"
//        slotsText.text = getString(R.string.slotsAvailable, sharedPrefs.getInt("slotsOpen", 2).toString())

        val dismissLayout: ConstraintLayout = findViewById(R.id.dismissLayout)

        dismissLayout.setOnClickListener {
            dismiss()
            finish()
        }

        val openLayout: ConstraintLayout = findViewById(R.id.openLayout)

        openLayout.setOnClickListener {
            dismiss()
            val mainIntent =
                Intent(Intent.ACTION_VIEW, Uri.parse("geo:${
                    sharedPrefs.getString(
                        "lat",
                        "0.0"
                    )
                },${sharedPrefs.getString("long", "0.0")}"))
            startActivity(mainIntent)
            finish()
        }

        swipeButton = findViewById(R.id.swipeButton)

        swipeButton.setOnTouchListener(object : OnSwipeTouchListener(this@AlarmActivity) {
            override fun onSwipeLeft() {
                super.onSwipeLeft()
                dismiss()
                finish()
            }

            override fun onSwipeRight() {
                super.onSwipeRight()
                dismiss()
                val mainIntent = Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse(
                        "geo:${
                            sharedPrefs.getString(
                                "lat",
                                "0.0"
                            )
                        },${sharedPrefs.getString("long", "0.0")}"
                    )
                )
                startActivity(mainIntent)
                finish()
            }

        })

    }

    private fun dismiss() {
        val notifManager: NotificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notifManager.cancel(19002007)

        val v = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        v.cancel()


        mp?.stop()
        mp?.reset()
        mp?.release()
        mp = null
    }
}