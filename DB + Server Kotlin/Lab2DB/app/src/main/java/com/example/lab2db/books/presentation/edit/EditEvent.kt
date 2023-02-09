package com.example.lab2db.books.presentation.edit

sealed class EditEvent {
    data class EnteredTitle(val value: String): EditEvent()
    data class EnteredAuthor(val value: String): EditEvent()
    data class EnteredGenre(val value: String): EditEvent()
    data class EnteredDescription(val value: String): EditEvent()
    data class EnteredQuotes(val value: String): EditEvent()
    data class EnteredPageNumber(val value: String): EditEvent()
    data class EnteredReview(val value: String): EditEvent()

    object InsertBook: EditEvent()
}