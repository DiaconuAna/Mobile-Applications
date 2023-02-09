package com.example.lab2db.api

import android.graphics.Movie
import com.example.lab2db.books.domain.model.Book
import kotlinx.coroutines.flow.Flow
import retrofit2.Call
import retrofit2.Response
import retrofit2.http.*


interface ApiInterface {

    // both suspended meaning they can be executed on a
    // background thread
    @Headers("Accept-Encoding: identity")
    @GET("/books")
//    fun getAllBooks(): Call<List<Book>>
    suspend fun getAllBooks(): Response<List<Book>>
//    suspend fun getAllBooks(): List<Book>

    @Headers("Content-Type: application/json")
    @POST("/books")
    suspend fun addBook(
        @Body book: Book
    ): Response<Book>

    @DELETE("/books/{id}")
    suspend fun deleteBook(@Path("id") id: Int): Response<Book>

    @PUT("/books")
    suspend fun updateBook(@Body book: Book): Response<Book>

}