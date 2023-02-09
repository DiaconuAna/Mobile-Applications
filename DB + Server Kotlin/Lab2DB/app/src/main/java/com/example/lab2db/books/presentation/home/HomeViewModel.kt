package com.example.lab2db.books.presentation.home

import android.app.Application
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.lab2db.api.ApiInterface
import com.example.lab2db.api.NetworkManager
import com.example.lab2db.books.domain.model.Book
import com.example.lab2db.books.domain.repository.BookRepository
import com.example.lab2db.books.domain.use_cases.DeleteBookById
import com.example.lab2db.books.domain.use_cases.GetBooks
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import org.json.JSONObject
import org.json.JSONTokener
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(
//    private val deleteBook: DeleteBook,
    private val deleteBook: DeleteBookById,
    private val bookRepository: BookRepository,
    private val bookApi: ApiInterface,
//    getBooks: GetBooks,
//    getLocalBooks: GetLocalBooks,
    private val application: Application
) : ViewModel() {

    //  private val _state = MutableStateFlow(emptyList<Character>())
    //    val state: StateFlow<List<Character>>
    //        get() = _state

    //     private val _listOfMovies: MutableState<List<Movie>> = mutableStateOf(emptyList())

    //    private val _state = mutableStateOf(HomeState())
//    private val _state: MutableState<List<Book>> = mutableStateOf(emptyList())
    private val _state: MutableState<List<Book>> = mutableStateOf(emptyList())

    //    val state: State<HomeState> = _state
    var state: State<List<Book>> = _state

    init {
        fetchData()
    }

    fun fetchData() {
        Log.d("Home view model", "FETCH DATA")
        if (NetworkManager.isOnline(application.applicationContext)) {

            fetchNetworkData()

//            viewModelScope.launch {
////                val characters = characterRepo.getCharacters()
////                _state.value = characters
//                val books = bookApi.getAllBooks()
//                _state.value = books.body()
//            }

            bookRepository.getBooks().onEach { books ->
                _state.value = books

            }.launchIn(viewModelScope)

        } else {
//            viewModelScope.launch {
//                val books = bookRepository.getBooks()
////                _state.value = books
//                bookRepository.getBooks().onEach { books ->
//                    _state.value = books
//                }
//            }
            bookRepository.getBooks().onEach { books ->
                _state.value = books
            }.launchIn(viewModelScope)

            Toast.makeText(
                application.applicationContext,
                "Server offline - local data displayed",
                Toast.LENGTH_LONG
            ).show()
        }
    }

    fun fetchNetworkData() {
        viewModelScope.launch {
            try {
                Log.d("Home view model", "fetchNetworkData: ")
                val response = bookApi.getAllBooks()

                if (response.isSuccessful) {

                    if (response.code() != 200) {
                        val jsonObject =
                            JSONTokener(response.errorBody()?.string()).nextValue() as JSONObject
                        val errorMessage = jsonObject.getString("text")
                        Log.d("Error", response.code().toString() + ": " + errorMessage)
                        Toast.makeText(
                            application.applicationContext,
                            errorMessage,
                            Toast.LENGTH_LONG
                        ).show()
                    } else {
                        response.body()?.let { _state.value = it }
                        viewModelScope.launch(Dispatchers.IO) {
                            // update db with fetched data
                            bookRepository.deleteAll()
                            bookRepository.insertBooks(state.value)
                        }
                    }
                } else {
                    Log.e("ERROR", "UNSUCCESSFUL")
                }
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
                Log.e("error", "$e")
            }
        }
    }

    suspend fun syncData() {
        Log.d("DELETE", "SYNC  " + bookRepository.getOfflineBooks().toString())
        for (book in bookRepository.getOfflineBooks()) {
            viewModelScope.launch {
                try {
                    book.isOffline = false
                    bookApi.addBook(book)
                    launch(Dispatchers.IO) {
                        bookRepository.updateBook(book)
                    }
                    Log.d("DELETE", "Successfully synced offline data")
                } catch (e: Exception) {
                    e.printStackTrace()
                    Log.e("error", "$e")
                    Toast.makeText(
                        application.applicationContext,
                        "Error has occurred",
                        Toast.LENGTH_LONG
                    ).show()
                }
            }

        }
    }

    fun deleteBook(id: Int) {
        viewModelScope.launch {
            Log.d("DELETE Server", "DELETE book from server")
            try {
                val response = bookApi.deleteBook(id)

                if (response.isSuccessful) {

                    if (response.code() != 200) {
                        val jsonObject =
                            JSONTokener(response.errorBody()?.string()).nextValue() as JSONObject
                        val errorMessage = jsonObject.getString("text")
                        Log.d(
                            "DELETE Server Error",
                            response.code().toString() + ": " + errorMessage
                        )
                        Toast.makeText(
                            application.applicationContext,
                            errorMessage,
                            Toast.LENGTH_LONG
                        ).show()
                    } else {
                        bookRepository.deleteBookById(id)
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
                    Log.e("DELETE ERROR", "DELETE FAILED")
                    android.os.Handler(Looper.getMainLooper()).post {
                        Toast.makeText(
                            application.applicationContext,
                            "Delete error has occurred",
                            Toast.LENGTH_LONG
                        )
                            .show()
                    }
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
    }

//    fun onEvent(event: HomeEvent) {
//        when (event) {
//            is HomeEvent.DeleteBook -> {
//
//                viewModelScope.launch {
//                    deleteBook(event.id)
//                    Log.d("AXU", state.toString())
//                }
//            }
//        }
//    }
}
