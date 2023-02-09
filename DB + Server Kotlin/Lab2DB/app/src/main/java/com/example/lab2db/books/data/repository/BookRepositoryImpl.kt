package com.example.lab2db.books.data.repository

import android.R
import android.graphics.Movie
import android.util.Log
import android.widget.ProgressBar
import android.widget.Toast
import com.example.lab2db.api.ApiInterface
import com.example.lab2db.books.data.source.local.dao.BookDao
import com.example.lab2db.books.domain.model.Book
import com.example.lab2db.books.domain.repository.BookRepository
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.flow
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import javax.inject.Inject


class BookRepositoryImpl @Inject constructor(
    private val dao: BookDao,
    private val bookApi: ApiInterface
) : BookRepository {

    override fun getBooks(): Flow<List<Book>> {
        return dao.getBooks()
    }

    override suspend fun getOfflineBooks(): List<Book> {
        return dao.getOfflineData()
    }

    override fun getServerBooks(): Flow<List<Book>> = flow {
        while (true) {
            bookApi.getAllBooks().body()?.let { emit(it) }
            delay(1000)
        }
    }

    override suspend fun getBookById(id: Int): Book? {
        return dao.getBookById(id)
    }

    override suspend fun insertBook(book: Book) {
        return dao.insertBook(book)
    }

    override suspend fun deleteBookById(id: Int) {
        return dao.deleteBookById(id)
    }

    override suspend fun updateBook(book: Book) {
        return dao.insertBook(book)
    }

    override suspend fun deleteAll() {
        return dao.deleteAll()
    }

    override suspend fun insertBooks(books: List<Book>) {
        return dao.insertBooks(books)
    }


}