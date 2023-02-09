package com.example.lab2db.books.data.source.local.dao

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import com.example.lab2db.books.domain.model.Book


//val MIGRATION_1_2: Migration = object : Migration(1, 2) {
//    override fun migrate(database: SupportSQLiteDatabase) {
//        database.execSQL(
//            "ALTER TABLE book "
//                    + "ADD COLUMN isOffline TEXT"
//        )
//    }
//}

@Database(
    entities = [Book::class],
    version = 2,
    exportSchema = false
)
abstract class BookDatabase : RoomDatabase(){
    abstract val bookDao: BookDao
}