package com.example.lab2db.books.presentation.edit

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.example.lab2db.api.NetworkManager
import kotlinx.coroutines.flow.collectLatest


@Composable
fun AddScreen(
    navController: NavController,
    viewModel: AddViewModel = hiltViewModel(),
    appContext: Context
) {

    LaunchedEffect(key1 = true) {
        viewModel.eventFlow.collectLatest { event ->
            when (event) {
                is AddViewModel.UiEvent.SaveBook -> {
                    navController.navigateUp()
                }
            }
        }
    }

    val titleCheck = remember { mutableStateOf("") }
    val pageNumberCheck = remember { mutableStateOf("") }
    val authorCheck = remember { mutableStateOf("") }
    val genreCheck = remember { mutableStateOf("") }
    val descriptionCheck = remember { mutableStateOf("") }
    val quotesCheck = remember { mutableStateOf("") }
    val reviewCheck = remember { mutableStateOf("") }


    Scaffold(
        topBar = {
            AddTopBar(
                topAppBarText = "Enter your book data here"
            )
        },
        content = {
            AddContent(
                titleCheck = titleCheck,
                pageNumberCheck = pageNumberCheck,
                authorCheck = authorCheck,
                descriptionCheck = descriptionCheck,
                genreCheck = genreCheck,
                reviewCheck = reviewCheck,
                quotesCheck = quotesCheck
            )
        },
        bottomBar = {
            AddBottomBar(
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
fun AddTopBar(topAppBarText: String) {

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
        backgroundColor = Color.Red
    )

}

@Composable
fun AddBottomBar(
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
                builder.setPositiveButton("Review data") { _, _ ->
                }
                builder.setNegativeButton("Cancel operation") { _, _ ->
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

        }) {
        Text(text = "Add book ${titleCheck.value}")
    }
}


@Composable
fun AddContent(
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
        OutlinedTextField(
            value = titleCheck.value,
            onValueChange = {
                titleCheck.value = it
                Log.d("WHAT", it)
            },
            label = { Text(text = "Title") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = pageNumberCheck.value,
            onValueChange = { pageNumberCheck.value = it },
            label = { Text(text = "Page Number") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = authorCheck.value,
            onValueChange = { authorCheck.value = it },
            label = { Text(text = "Author") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = genreCheck.value,
            onValueChange = { genreCheck.value = it },
            label = { Text(text = "Genre") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = descriptionCheck.value,
            onValueChange = { descriptionCheck.value = it },
            label = { Text(text = "Description") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = reviewCheck.value,
            onValueChange = { reviewCheck.value = it },
            label = { Text(text = "Review") },
            modifier = Modifier.fillMaxWidth()
        )
        OutlinedTextField(
            value = quotesCheck.value,
            onValueChange = { quotesCheck.value = it },
            label = { Text(text = "Quotes") },
            modifier = Modifier.fillMaxWidth()
        )
    }
}
