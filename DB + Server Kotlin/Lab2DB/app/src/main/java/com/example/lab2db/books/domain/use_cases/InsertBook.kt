package com.example.lab2db.books.domain.use_cases

import com.example.lab2db.books.domain.model.Book
import com.example.lab2db.books.domain.repository.BookRepository
import javax.inject.Inject

class InsertBook @Inject constructor(
    private val repository: BookRepository
){
    suspend operator fun invoke(book: Book){
        repository.insertBook(book)
    }
}