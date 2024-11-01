package com.example.mycall

import android.Manifest
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.telecom.TelecomManager
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    @RequiresApi(Build.VERSION_CODES.M)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Check if the app is the default dialer
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !isDefaultDialer()) {
            promptSetDefaultDialer()
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun promptSetDefaultDialer() {
        val telecomManager = getSystemService(TELECOM_SERVICE) as TelecomManager
        if (!isDefaultDialer()) {
            // Prompt the user to set this app as the default dialer
            val intent = Intent(TelecomManager.ACTION_CHANGE_DEFAULT_DIALER).apply {
                putExtra(TelecomManager.EXTRA_CHANGE_DEFAULT_DIALER_PACKAGE_NAME, packageName)
            }
            try {
                startActivity(intent)
            } catch (e: ActivityNotFoundException) {
                Log.e("MainActivity", "Default dialer change intent failed: ${e.localizedMessage}")
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun isDefaultDialer(): Boolean {
        val telecomManager = getSystemService(TELECOM_SERVICE) as TelecomManager
        return telecomManager.defaultDialerPackage == packageName
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channelHandler = ChannelHandler(this, this, flutterEngine)
        channelHandler.setMethodCallHandler()
    }
}

class ChannelHandler(
    private val context: Context,
    private val activity: Activity,
    flutterEngine: FlutterEngine
) {
    private val methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "channel-name")

    @RequiresApi(Build.VERSION_CODES.M)
    fun setMethodCallHandler() {
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getNetworkStatus" -> {
                    val networkStatus = getNetworkStatus()
                    result.success(networkStatus)
                }
                "makePhoneCall" -> {
                    val phoneNumber = call.argument<String>("phoneNumber")
                    if (phoneNumber != null) {
                        makePhoneCall(phoneNumber, result)
                    } else {
                        result.error("INVALID_NUMBER", "Phone number is null", null)
                    }
                }
                "startCall" -> {
                    val phoneNumber = call.argument<String>("phoneNumber")
                    if (phoneNumber != null) {
                        startCall(phoneNumber, result)
                    } else {
                        result.error("INVALID_NUMBER", "Phone number is null", null)
                    }
                }
                "endCall" -> {
                    endCall(result)
                }
                else -> result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun getNetworkStatus(): String {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val network = connectivityManager.activeNetwork
        val capabilities = connectivityManager.getNetworkCapabilities(network)
        return when {
            capabilities == null -> "No connection"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "Connected to Wi-Fi"
            capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "Connected to Cellular"
            else -> "Unknown connection"
        }
    }

    private fun makePhoneCall(phoneNumber: String, result: MethodChannel.Result) {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(activity, arrayOf(Manifest.permission.CALL_PHONE), 1)
            result.error("PERMISSION_DENIED", "Phone call permission not granted", null)
            return
        }

        val intent = Intent(Intent.ACTION_CALL, Uri.parse("tel:$phoneNumber"))
        try {
            context.startActivity(intent)
            result.success("Calling $phoneNumber")
        } catch (e: ActivityNotFoundException) {
            result.error("ACTIVITY_NOT_FOUND", "No Activity found to handle Intent", null)
        }
    }

    private fun startCall(phoneNumber: String, result: MethodChannel.Result) {
        // Check if the CALL_PHONE permission is granted
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
            // Request the permission if not granted
            ActivityCompat.requestPermissions(activity, arrayOf(Manifest.permission.CALL_PHONE), 1)
            result.error("PERMISSION_DENIED", "Call permission not granted", null)
            Log.d("ChannelHandler", "Error Starting call to $phoneNumber")
            return
        }

        // Prepare the call intent
        val callIntent = Intent(Intent.ACTION_CALL, Uri.parse("tel:$phoneNumber"))
        try {
            // Attempt to start the call
            context.startActivity(callIntent)
            Log.d("ChannelHandler", "Starting call to $phoneNumber")
            result.success("Call started to $phoneNumber")
        } catch (e: SecurityException) {
            // Handle SecurityException specifically for permission issues
            result.error("SECURITY_EXCEPTION", "Permission denied for CALL_PHONE", e.localizedMessage)
            Log.e("ChannelHandler", "SecurityException: ${e.localizedMessage}")
        } catch (e: ActivityNotFoundException) {
            // Handle case where no application can handle the call intent
            result.error("ACTIVITY_NOT_FOUND", "No application can handle the call", e.localizedMessage)
            Log.e("ChannelHandler", "ActivityNotFoundException: ${e.localizedMessage}")
        } catch (e: Exception) {
            // Catch all other exceptions
            result.error("CALL_FAILED", "Failed to start call", e.localizedMessage)
            Log.e("ChannelHandler", "Exception: ${e.localizedMessage}")
            e.printStackTrace()
        }
    }

    private fun endCall(result: MethodChannel.Result) {
        // Since ending calls programmatically may be restricted, we'll log the action.
        Log.d("ChannelHandler", "Ending call is requested.")
        result.success("Call ended (simulated)")
    }
}
