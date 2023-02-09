package com.example.lab2db.di

import android.app.Application
import androidx.room.Room
import com.example.lab2db.api.ApiInterface
import com.example.lab2db.api.EchoWebSocketListener
import com.example.lab2db.books.data.repository.BookRepositoryImpl
import com.example.lab2db.books.data.source.local.dao.BookDatabase
import com.example.lab2db.books.domain.repository.BookRepository
import com.example.lab2db.utils.DATABASE_NAME
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.WebSocket
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object AppModule {

    @Provides
    @Singleton
    fun provideBookDatabase(app: Application) = Room.databaseBuilder(
        app,
        BookDatabase::class.java,
        DATABASE_NAME
    ).fallbackToDestructiveMigration().
    build()

    @Provides
    @Singleton
    fun provideRepository(db: BookDatabase, api: ApiInterface): BookRepository{
        return BookRepositoryImpl(db.bookDao, api)
    }

    @Provides
    @Singleton
    fun provideApiInterface(retrofit: Retrofit): ApiInterface =
        retrofit.create(ApiInterface::class.java)

    @Provides
    @Singleton // we want only one instance of the dependency (it is used by the whole app)
    fun provideRetrofit(): Retrofit {

        val logging = HttpLoggingInterceptor()
        logging.level = HttpLoggingInterceptor.Level.BODY
        val client = OkHttpClient.Builder().addInterceptor(logging).build()

        val request = Request.Builder()
            .url("http://10.0.2.2:5000/")
            .build()

        return Retrofit.Builder()
            .baseUrl("http://10.0.2.2:5000/") // 10.0.2.2 - ip of the development host
            .client(client)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
    }

    @Provides
    fun provideGson(): Gson = GsonBuilder().create()

    @Provides
    fun provideWebSocket() : WebSocket {
        val logging = HttpLoggingInterceptor()
        logging.level = HttpLoggingInterceptor.Level.BODY
        val client = OkHttpClient.Builder().addInterceptor(logging).build()

        val request = Request.Builder()
            .url("http://10.0.2.2:5000/")
            .build()

        val listener = EchoWebSocketListener();
        val ws: WebSocket = client.newWebSocket(request, listener);

        return ws;

        /*
        Request request = new Request.Builder().url("ws://echo.websocket.org").build();
    EchoWebSocketListener listener = new EchoWebSocketListener();
    WebSocket ws = client.newWebSocket(request, listener);
         */
    }




}