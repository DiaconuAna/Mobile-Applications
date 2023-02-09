package com.example.lab2db.books.presentation.home

import com.example.lab2db.books.domain.model.Book

sealed class HomeEvent {
//    data class DeleteBook(val book: Book): HomeEvent()
    data class DeleteBook(val id: Int?): HomeEvent()
}