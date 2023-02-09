package com.example.lab2db.books.domain.repository

import com.example.lab2db.books.domain.model.Book
import kotlinx.coroutines.flow.Flow

interface BookRepository {

//    fun getBooks(): Flow<List<Book>>
    fun getBooks(): Flow<List<Book>>

    suspend fun getOfflineBooks(): List<Book>

    fun getServerBooks(): Flow<List<Book>>

    suspend fun getBookById(id: Int): Book?

    suspend fun insertBook(book: Book)

    suspend fun insertBooks(books: List<Book>)

//    suspend fun deleteBook(book: Book)

    suspend fun deleteBookById(id: Int)

    suspend fun updateBook(book: Book)

    suspend fun deleteAll()
}