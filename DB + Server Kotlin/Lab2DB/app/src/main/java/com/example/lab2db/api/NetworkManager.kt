package com.example.lab2db.api

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkInfo
import android.util.Log
import okhttp3.Response
import okhttp3.WebSocket
import okhttp3.WebSocketListener
import okio.ByteString
import javax.inject.Inject


class NetworkManager @Inject constructor(
    appContext: Context
){

    companion object {
        fun isOnline(context: Context): Boolean {
            //         val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val connMgr =
                context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
            val networkInfo: NetworkInfo? = connMgr.activeNetworkInfo
            return networkInfo?.isConnected == true
        }
    }
}

/**
 * class TaxiWebSocket(private val broadcastTaxi: MutableLiveData<Taxi>) : WebSocketListener() {
override fun onMessage(webSocket: WebSocket, text: String) {
val taxi = TaxiRemoteApi.gson.fromJson(text, Taxi::class.java)
broadcastTaxi.postValue(taxi)
}
}
 */

//class WebSocket() : WebSocketListener() {
//    override fun onMessage(webSocket: WebSocket, text: String) {
//        val taxi = TaxiRemoteApi.gson.fromJson(text, Taxi::class.java)
//        broadcastTaxi.postValue(taxi)
//    }
//}

public class EchoWebSocketListener : WebSocketListener() {
    override fun onOpen(webSocket: WebSocket, response: Response) {
        webSocket.send("Hello, it's Amy's server !")

    }

    override fun onMessage(webSocket: WebSocket, text: String) {
        Log.d("Socket", "Receiving : $text")
    }

//    override fun onMessage(webSocket: WebSocket?, bytes: ByteString) {
//        output("Receiving bytes : " + bytes.hex())
//    }

//    override fun onClosing(webSocket: WebSocket, code: Int, reason: String) {
//        webSocket.close(NORMAL_CLOSURE_STATUS, null)
//        output("Closing : $code / $reason")
//    }

    override fun onFailure(webSocket: WebSocket, t: Throwable, response: Response?) {
        Log.d("Socket", "Error : " + t.message)
    }

    companion object {
        private const val NORMAL_CLOSURE_STATUS = 1000
    }
}