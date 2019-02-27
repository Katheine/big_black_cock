package com.example.succ

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.support.v4.app.NotificationCompat

class AlarmReceiver: BroadcastReceiver() {

    override fun onReceive(ctx: Context, intent: Intent) {
        val notifMan = ctx.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notifMan.createNotificationChannel(
                NotificationChannel("anal", "anal", NotificationManager.IMPORTANCE_HIGH)
            )
        }
        val name = intent.getStringExtra("name")
        notifMan.notify(0x69, NotificationCompat.Builder(ctx, "anal")
                .setDefaults(NotificationCompat.DEFAULT_ALL)
                .setContentTitle("ПОЛЕЙ ЦВЕТОЧИК")
                .setContentText("ПОЛЕЙ ЦВИТОЧИК: $name")
                .setSmallIcon(R.drawable.ic_launcher_foreground)
            .build()
        )
    }

}