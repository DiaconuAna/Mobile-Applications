package com.example.lab2db.books.presentation.edit

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.example.lab2db.api.NetworkManager
import com.example.lab2db.books.presentation.edit.components.BookInputText
import kotlinx.coroutines.flow.collectLatest


@Composable
fun EditScreen(
    navController: NavController,
    viewModel: EditViewModel = hiltViewModel(),
    appContext: Context
) {

    val titleState = viewModel.bookTitle.value
    val authorState = viewModel.bookAuthor.value
    val descriptionState = viewModel.bookDescription.value
    val genreState = viewModel.bookGenre.value
    val pageNumberState = viewModel.bookPageNumber.value
    val quotesState = viewModel.bookQuotes.value
    val reviewState = viewModel.bookReview.value



    LaunchedEffect(key1 = true) {
        viewModel.eventFlow.collectLatest { event ->
            when (event) {
                is EditViewModel.UiEvent.SaveBook -> {
                    navController.navigateUp()
                }
            }
        }
    }

    Log.d("STATE TITLE", titleState.text)

    val titleCheck = remember { mutableStateOf(viewModel.bookTitle.value.text) }
    val pageNumberCheck = remember { mutableStateOf("") }
    val authorCheck = remember { mutableStateOf("") }
    val genreCheck = remember { mutableStateOf("") }
    val descriptionCheck = remember { mutableStateOf("") }
    val quotesCheck = remember { mutableStateOf("") }
    val reviewCheck = remember { mutableStateOf("") }


    Scaffold(
        topBar = {
            EditTopBar(
                topAppBarText = "Update book data here"
            )
        },
        content = {
            EditContent(
                title = titleState.text,
                author = authorState.text,
                genre = genreState.text,
                description = descriptionState.text,
                pageNumber = pageNumberState.text,
                review = reviewState.text,
                quotes = quotesState.text,
                onEvent = { viewModel.onEvent(it) },
                titleCheck = titleCheck,
                authorCheck = authorCheck,
                pageNumberCheck = pageNumberCheck,
                descriptionCheck = descriptionCheck,
                genreCheck = genreCheck,
                reviewCheck = reviewCheck,
                quotesCheck = quotesCheck
            )
        },
        bottomBar = {
            EditBottomBar(
                navigation = navController,
                context = appContext,
                onEvent = { viewModel.onEvent(it) },
                onInsertBook = {
                    viewModel.onEvent(EditEvent.InsertBook)
                },
                titleCheck = titleCheck,
                authorCheck = authorCheck,
                pageNumber = pageNumberCheck,
                descriptionCheck = descriptionCheck,
                genreCheck = genreCheck,
                reviewCheck = reviewCheck,
                quoteCheck = quotesCheck
            )
        }
    )
}


@Composable
fun EditBottomBar(
    modifier: Modifier = Modifier,
    navigation: NavController,
    context: Context,
    onEvent: (EditEvent) -> Unit,
    onInsertBook: () -> Unit,
    titleCheck: MutableState<String>,
    pageNumber: MutableState<String>,
    authorCheck: MutableState<String>,
    genreCheck: MutableState<String>,
    descriptionCheck: MutableState<String>,
    quoteCheck: MutableState<String>,
    reviewCheck: MutableState<String>
) {
    Button(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 10.dp, vertical = 14.dp),
        onClick = {
            if (NetworkManager.isOnline(context)) {
                var message = ""

                if (titleCheck.value == "") {
                    message += "\n Title cannot be empty"
                }
                if (authorCheck.value == "") {
                    message += "\n Author's name cannot be empty"
                }
                if (descriptionCheck.value == "") {
                    message += "\n Description cannot be empty"
                }
                if (genreCheck.value == "") {
                    message += "\n Book genre cannot be empty"
                }
                if ((pageNumber.value == "") or (pageNumber.value.toDoubleOrNull() == null)) {
                    message += "\n Page number must be a positive integer"
                    pageNumber.value = ""
                }

                if (message != "") {
                    val builder = android.app.AlertDialog.Builder(context)
                    builder.setTitle("Invalid book data")
                    builder.setMessage(message)
                    builder.setPositiveButton("Yes") { _, _ ->
                    }
                    builder.setNegativeButton("No") { _, _ ->
                        navigation.navigateUp()
                    }
                    builder.show()
                } else {
                    onEvent(EditEvent.EnteredTitle(titleCheck.value))
                    onEvent(EditEvent.EnteredAuthor(authorCheck.value))
                    onEvent(EditEvent.EnteredDescription(descriptionCheck.value))
                    onEvent(EditEvent.EnteredGenre(genreCheck.value))
                    onEvent(EditEvent.EnteredQuotes(quoteCheck.value))
                    onEvent(EditEvent.EnteredReview(reviewCheck.value))
                    onEvent(EditEvent.EnteredPageNumber(pageNumber.value))
                    onInsertBook()
                }
            } else {
                Toast.makeText(context, "Cannot update as network is offline", Toast.LENGTH_LONG)
                    .show()
            }
        }) {
        Text(text = "Update book")
    }
}

@Composable
fun EditContent(
    title: String,
    author: String,
    genre: String,
    description: String,
    pageNumber: String,
    review: String,
    quotes: String,
    onEvent: (EditEvent) -> Unit,
    titleCheck: MutableState<String>,
    pageNumberCheck: MutableState<String>,
    authorCheck: MutableState<String>,
    genreCheck: MutableState<String>,
    descriptionCheck: MutableState<String>,
    quotesCheck: MutableState<String>,
    reviewCheck: MutableState<String>
) {
    Column(modifier = Modifier.fillMaxWidth()) {
        Spacer(modifier = Modifier.height(44.dp))

        titleCheck.value = title
        authorCheck.value = author
        genreCheck.value = genre
        descriptionCheck.value = description
        pageNumberCheck.value = pageNumber

        BookInputText(
            text = title,
            hint = "Book title",
            onTextChange = {
                titleCheck.value = it
                onEvent(EditEvent.EnteredTitle(it))
            }
        )
        BookInputText(
            text = author,
            hint = "Book author",
            onTextChange = {
                authorCheck.value = it
                onEvent(EditEvent.EnteredAuthor(it))
            }
        )
        BookInputText(
            text = description,
            hint = "Book description",
            onTextChange = {

                onEvent(EditEvent.EnteredDescription(it))
            }
        )
        BookInputText(
            text = genre,
            hint = "Book genre",
            onTextChange = {
                onEvent(EditEvent.EnteredGenre(it))
            }
        )
        BookInputText(
            text = pageNumber,
            hint = "Book page number",
            onTextChange = {
                onEvent(EditEvent.EnteredPageNumber(it))
            }
        )
        BookInputText(
            text = review,
            hint = "Book review",
            onTextChange = {
                onEvent(EditEvent.EnteredReview(it))
            }
        )
        BookInputText(
            text = quotes,
            hint = "Book quotes",
            onTextChange = {
                onEvent(EditEvent.EnteredQuotes(it))
            }
        )

    }
}


@Composable
fun EditTopBar(topAppBarText: String) {

    TopAppBar(
        title = {
            Text(
                text = topAppBarText,
                textAlign = TextAlign.Center,
                modifier = Modifier
                    .fillMaxSize()
                    .wrapContentSize(Alignment.Center)
            )
        },
        backgroundColor = MaterialTheme.colors.surface
    )

}

