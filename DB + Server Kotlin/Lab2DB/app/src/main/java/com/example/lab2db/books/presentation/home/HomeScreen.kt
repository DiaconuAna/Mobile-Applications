package com.example.lab2db.books.presentation.home

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Add
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.example.lab2db.books.domain.model.Book
import com.example.lab2db.books.presentation.Screen
import com.example.lab2db.books.presentation.home.components.bookItem
import android.content.Context
import android.app.AlertDialog
import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.runtime.*
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.key.Key.Companion.D
import com.example.lab2db.api.NetworkManager
import java.util.Collections.addAll


@Composable
fun HomeScreen(
    navController: NavController,
    viewModel: HomeViewModel = hiltViewModel(),
    appContext: Context
) {
//    viewModel.fetchData()
//    val state by remember{viewModel.state}
    val state by remember(key1 = "id"){viewModel.state}
//    val state by viewModel.state.collectAsState()

    val state1 = viewModel.state


    Scaffold(
        topBar = {
            HomeTopBar()
        },
        floatingActionButton = {
            HomeFab(
                onFabClicked = { navController.navigate(Screen.Add.route) }
            )
        },
        content = { innerPadding ->
            HomeContent(
                modifier = Modifier.padding(innerPadding),
                onDeleteBook = {
                    if (NetworkManager.isOnline(appContext)) {
                        val builder = AlertDialog.Builder(appContext)
                        builder.setTitle("Delete confirmation")
                        builder.setMessage("Do you want to delete the book?")

                        builder.setPositiveButton("Yes") { _, _ ->
//                            viewModel.onEvent(HomeEvent.DeleteBook(it))
                            if (it != null) {
                                viewModel.deleteBook(it)
                            }
                        }

                        builder.setNegativeButton(android.R.string.no) { _, _ ->
                            Log.d("Good", "Book deleted");
                        }
                        builder.show()
                    }
                    else{
                        Toast.makeText(appContext, "Cannot delete as network is offline", Toast.LENGTH_LONG).show()
                    }

                },
                onEditBook = {
                    navController.navigate(
                        route = Screen.Edit.passId(it)
                    )
                },
                onDetails = {
                    navController.navigate(
                        route = Screen.Details.passId(it)
                    )
                },
                books = state1.value
//                books = state
//                books = viewModel.state.value.books
            )
        }
    )
}

@Composable
fun HomeContent(
    modifier: Modifier = Modifier,
//    onDeleteBook: (book: Book) -> Unit,
    onDeleteBook: (id: Int?) -> Unit,
    onEditBook: (id: Int?) -> Unit,
    onDetails: (id: Int?) -> Unit,
    books: List<Book> = emptyList()
) {
    Surface(
        color = MaterialTheme.colors.surface,
        modifier = modifier
    ) {

        LazyColumn {
            itemsIndexed(books) { index, book ->
                bookItem(
                    book = book,
                    onEditBook = { onEditBook(book.id) },
//                    onDeleteBook = { onDeleteBook(book) },
                    onDeleteBook = { onDeleteBook(book.id) },
                    onDetails = { onDetails(book.id) }
                )
            }
        }
    }

}

@Composable
fun HomeFab(
    modifier: Modifier = Modifier,
    onFabClicked: () -> Unit = { }
) {

    FloatingActionButton(
        onClick = onFabClicked,
        modifier = modifier
            .height(52.dp)
            .widthIn(min = 52.dp),
        backgroundColor = Color.Yellow
    ) {
        Icon(
            imageVector = Icons.Outlined.Add,
            contentDescription = "Add a book to the library"
        )
    }

}

@Composable
fun HomeTopBar(
    modifier: Modifier = Modifier
) {
    TopAppBar(
        title = {
            Text(
//                text = stringResource(id = R.string.books)
                text = "My personal library",
                textAlign = TextAlign.Center,
                modifier = modifier
                    .fillMaxSize()
                    .wrapContentSize(Alignment.Center)
            )
        },
        backgroundColor = MaterialTheme.colors.surface
    )
}

