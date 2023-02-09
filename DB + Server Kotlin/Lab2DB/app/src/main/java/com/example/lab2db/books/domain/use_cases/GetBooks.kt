package com.example.lab2db.books.domain.use_cases

import com.example.lab2db.books.domain.model.Book
import com.example.lab2db.books.domain.repository.BookRepository
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject

class GetBooks @Inject constructor(
  private val repository: BookRepository
) {
    operator fun invoke(flag: Boolean): Flow<List<Book>> {
//        return repository.getDBBooks()
        return if(flag)
//            repository.getServerBooks()
            repository.getBooks()
        else
            repository.getBooks()
    }
}