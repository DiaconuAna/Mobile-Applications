package com.example.lab2db.books.data.source.local.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.example.lab2db.books.domain.model.Book
import kotlinx.coroutines.flow.Flow

@Dao
interface BookDao {

    /**
     * In coroutines, flow is a type that can emit multiple values sequentially,
     * as opposed to suspend functions that return only a single value.
     * Here, we use flow to receive live updates from a database.
     */

    // use live data instead of flow?
    @Query("SELECT * FROM Book")
    fun getBooks(): Flow<List<Book>>

    @Query("SELECT * FROM Book")
    fun getDBBooks(): List<Book>

    @Query("SELECT * from Book WHERE isOffline=1")
    suspend fun getOfflineData(): List<Book>

    @Query("SELECT * FROM Book WHERE id=:id")
    suspend fun getBookById(id: Int): Book?

    @Query("DELETE FROM Book WHERE id=:id")
    suspend fun deleteBookById(id: Int)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertBook(book: Book)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertBooks(books: List<Book>)

    @Query("DELETE FROM Book")
    suspend fun deleteAll()

}