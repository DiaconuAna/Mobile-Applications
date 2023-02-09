package com.example.lab2db.books.presentation.edit

import android.app.Application
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.lab2db.api.ApiInterface
import com.example.lab2db.api.NetworkManager
import com.example.lab2db.books.domain.model.Book
import com.example.lab2db.books.domain.repository.BookRepository
import com.example.lab2db.books.domain.use_cases.GetBook
import com.example.lab2db.books.domain.use_cases.InsertBook
import com.example.lab2db.books.domain.use_cases.UpdateBook
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch
import org.json.JSONObject
import org.json.JSONTokener
import java.util.logging.Handler
import javax.inject.Inject

@HiltViewModel
class AddViewModel @Inject constructor(
    private val getBook: GetBook,
    private val insertBook: InsertBook,
    savedStateHandle: SavedStateHandle,
    private val bookRepository: BookRepository,
    private val bookApi: ApiInterface,
    private val application: Application
) : ViewModel() {

    private val _bookTitle = mutableStateOf(TextFieldState())
    val bookTitle: State<TextFieldState> = _bookTitle

    private val _bookAuthor = mutableStateOf(TextFieldState())
    val bookAuthor: State<TextFieldState> = _bookAuthor

    private val _bookDescription = mutableStateOf(TextFieldState())
    val bookDescription: State<TextFieldState> = _bookDescription

    private val _bookGenre = mutableStateOf(TextFieldState())
    val bookGenre: State<TextFieldState> = _bookGenre

    private val _bookQuotes = mutableStateOf(TextFieldState())
    val bookQuotes: State<TextFieldState> = _bookQuotes

    private val _bookPageNumber = mutableStateOf(TextFieldState())
    val bookPageNumber: State<TextFieldState> = _bookPageNumber

    private val _bookReview = mutableStateOf(TextFieldState())
    val bookReview: State<TextFieldState> = _bookReview

    private val _eventFlow = MutableSharedFlow<UiEvent>()
    val eventFlow = _eventFlow.asSharedFlow()

    private var currentBookId: Int? = null
    private var offlineStatus: Boolean = false


    init {
        if (!NetworkManager.isOnline(application.applicationContext)) {
            offlineStatus = true
            android.os.Handler(Looper.getMainLooper()).post {
                Toast.makeText(
                    application.applicationContext,
                    "You are currently offline - data will be added locally",
                    Toast.LENGTH_LONG
                )
                    .show()
            }
        }
        savedStateHandle.get<Int>("bookId")?.let { bookId ->
            if (bookId != -1) {
                viewModelScope.launch {
                    getBook(bookId)?.also { book ->
                        currentBookId = book.id
                        _bookTitle.value = bookTitle.value.copy(
                            text = book.title
                        )
                        _bookAuthor.value = bookAuthor.value.copy(
                            text = book.author
                        )
                        _bookGenre.value = bookGenre.value.copy(
                            text = book.genre
                        )
                        _bookDescription.value = bookDescription.value.copy(
                            text = book.description
                        )
                        _bookQuotes.value = bookQuotes.value.copy(
                            text = book.quotes
                        )
                        _bookPageNumber.value = bookPageNumber.value.copy(
                            text = book.pageNumber.toString()
                        )
                        _bookReview.value = bookReview.value.copy(
                            text = book.review
                        )
                        if (!NetworkManager.isOnline(application.applicationContext)) {
                            offlineStatus = true
                        }

                    }
                }
            }
        }
    }

    fun onEvent(event: EditEvent) {
        when (event) {
            is EditEvent.EnteredTitle -> {
                _bookTitle.value = bookTitle.value.copy(
                    text = event.value
                )
            }
            is EditEvent.EnteredAuthor -> {
                _bookAuthor.value = bookAuthor.value.copy(
                    text = event.value
                )
            }
            is EditEvent.EnteredGenre -> {
                _bookGenre.value = bookGenre.value.copy(
                    text = event.value
                )
            }
            is EditEvent.EnteredDescription -> {
                _bookDescription.value = bookDescription.value.copy(
                    text = event.value
                )
            }
            is EditEvent.EnteredQuotes -> {
                _bookQuotes.value = bookQuotes.value.copy(
                    text = event.value
                )
            }
            is EditEvent.EnteredPageNumber -> {
                _bookPageNumber.value = bookPageNumber.value.copy(
                    text = event.value
                )
            }
            is EditEvent.EnteredReview -> {
                _bookReview.value = bookReview.value.copy(
                    text = event.value
                )
            }
            EditEvent.InsertBook -> {
                viewModelScope.launch {
//                    insertBook(
//                        Book(
//                            title = bookTitle.value.text,
//                            author = bookAuthor.value.text,
//                            genre = bookGenre.value.text,
//                            description = bookDescription.value.text,
//                            pageNumber = bookPageNumber.value.text.toInt(),
//                            review = bookReview.value.text,
//                            quotes = bookQuotes.value.text,
//                            id = currentBookId,
//                            isOffline = offlineStatus
//                        )
//                    )
                    val book = Book(
                        title = bookTitle.value.text,
                        author = bookAuthor.value.text,
                        genre = bookGenre.value.text,
                        description = bookDescription.value.text,
                        pageNumber = bookPageNumber.value.text.toInt(),
                        review = bookReview.value.text,
                        quotes = bookQuotes.value.text,
                        id = currentBookId,
                        isOffline = offlineStatus
                    )
                    if (!NetworkManager.isOnline(application.applicationContext)) {
                        addLocal(book)
                    } else {
                        addServer(book)
                    }
                    _eventFlow.emit(UiEvent.SaveBook)
                }
            }

        }
    }

    private suspend fun syncData() {
        Log.d("ADD", "Synchronising data  " + bookRepository.getOfflineBooks().toString())
        for (book in bookRepository.getOfflineBooks()) {
            viewModelScope.launch {
                try {
                    book.isOffline = false
                    bookApi.addBook(book)
                    launch(Dispatchers.IO) {
                        bookRepository.updateBook(book)
                    }
                    Log.d("ADD", "Successfully synced offline data")
                } catch (e: Exception) {
                    e.printStackTrace()
                    Log.e("ADD error", "$e")
                    Toast.makeText(
                        application.applicationContext,
                        "Error has occurred",
                        Toast.LENGTH_LONG
                    ).show()
                }
            }

        }
    }

    private fun addLocal(book: Book) = viewModelScope.launch(Dispatchers.IO) {
        Log.d("ADD Local", "Add item DB$book")
        try {
            bookRepository.insertBook(book)
            Log.d("ADD Local", "DB Book Successfully added")
        } catch (e: Exception) {
            Log.e("Add Local error", "$e")
            android.os.Handler(Looper.getMainLooper()).post {
                Toast.makeText(
                    application.applicationContext,
                    "Error has occurred",
                    Toast.LENGTH_LONG
                )
                    .show()
            }
        }
    }

    private fun addServer(book: Book) = viewModelScope.launch(Dispatchers.IO) {
        Log.d("ADD Server", "Add item SERVER")
        try {
            val response = bookApi.addBook(book)

            if (response.isSuccessful) {

                if (response.code() != 200) {
                    val jsonObject =
                        JSONTokener(response.errorBody()?.string()).nextValue() as JSONObject
                    val errorMessage = jsonObject.getString("text")
                    Log.d("ADD Server Error", response.code().toString() + ": " + errorMessage)
                    Toast.makeText(
                        application.applicationContext,
                        errorMessage,
                        Toast.LENGTH_LONG
                    ).show()
                } else {
                    addLocal(book)
                    if (NetworkManager.isOnline(application.applicationContext)) {
                        if (bookRepository.getOfflineBooks().isNotEmpty()) {
                            Toast.makeText(
                                application.applicationContext,
                                "Switching back to online mode",
                                Toast.LENGTH_LONG
                            ).show()
                            syncData()
                        }
                    }
                }
            } else {
                Log.e("ERROR", "UNSUCCESSFUL")
            }
        } catch (e: Exception) {
            Log.e("ERROR", "$e")
            android.os.Handler(Looper.getMainLooper()).post {
                Toast.makeText(
                    application.applicationContext,
                    "Error has occurred",
                    Toast.LENGTH_LONG
                )
                    .show()
            }
        }

    }

    sealed class UiEvent {
        object SaveBook : UiEvent()
    }
}

