package com.example.succ

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class NotificationPlugin(val ctx: Context): MethodChannel.MethodCallHandler {

    override fun onMethodCall(mc: MethodCall, res: MethodChannel.Result) {
        when(mc.method) {
            "set_notification" -> {
                try {
                    val alarmMan = ctx.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                    val time = mc.argument<Long>("time") ?: (mc.argument<Int>("time")!!.toLong())
                    val intent = Intent(ctx, AlarmReceiver::class.java)
                    intent.putExtra("name", mc.argument<String>("name"))
                    alarmMan.set(
                        AlarmManager.RTC_WAKEUP,
                        time,
                        PendingIntent.getBroadcast(ctx, 0, intent, 0)
                    )
                    res.success(null)
                } catch (e: Exception) {
                    res.error("error", "ошыбко", e)
                }
            }
            "cancel_notification" -> {
                res.success(null)
            }
            else -> res.notImplemented()
        }
    }

    companion object {
        @JvmStatic
        fun register(registrar: PluginRegistry.Registrar) {
            val inst = NotificationPlugin(registrar.context())
            val methodChannel = MethodChannel(registrar.messenger(), "notification_plugin")
            methodChannel.setMethodCallHandler(inst)
        }
    }

}