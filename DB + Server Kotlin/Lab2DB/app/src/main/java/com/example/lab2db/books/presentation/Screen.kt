package com.example.lab2db.books.presentation

sealed class Screen(val route: String){
    object Home: Screen("home")
    object Edit: Screen("edit?bookId={bookId}"){
        fun passId(bookId: Int?): String{
            return "edit?bookId=$bookId"
        }
    }
    object Details: Screen("details?bookId={bookId}"){
        fun passId(bookId: Int?): String{
            return "details?bookId=$bookId"
        }
    }
    object Add: Screen("add")
}
