package com.example.lab2db.books.domain.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class Book(
    @PrimaryKey(autoGenerate = true)
    val id: Int? = null,
    @ColumnInfo(name = "title")
    val title: String,
    @ColumnInfo(name = "author")
    val author: String,
    @ColumnInfo(name = "description")
    val description: String,
    @ColumnInfo(name = "genre")
    val genre: String,
    @ColumnInfo(name = "quotes")
    val quotes: String,
    @ColumnInfo(name = "pageNumber")
    val pageNumber: Int,
    @ColumnInfo(name = "review")
    val review: String,
    @ColumnInfo (name = "isOffline", defaultValue = "false")
    var isOffline: Boolean
)
