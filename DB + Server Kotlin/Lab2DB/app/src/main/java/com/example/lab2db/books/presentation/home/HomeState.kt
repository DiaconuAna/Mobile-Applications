package com.example.lab2db.books.presentation.home

import com.example.lab2db.books.domain.model.Book

data class HomeState (
    val books: List<Book> = emptyList())
    {
}