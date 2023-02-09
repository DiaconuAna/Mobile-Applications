package com.example.lab2db.books.presentation.details

import android.content.Context
import android.util.Log
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.example.lab2db.R
import com.example.lab2db.books.domain.model.Book
import com.example.lab2db.books.presentation.edit.*
import com.example.lab2db.books.presentation.edit.components.baseLineHeight

@Composable
fun DetailsScreen(
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

    val scrollState = rememberScrollState()

    Column(modifier = Modifier.fillMaxSize()){
        BoxWithConstraints(modifier = Modifier.weight(1f)){
            Surface{
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .verticalScroll(scrollState),
                ){
                    BookTopBar(titleState.text)
                    BookDetails(
                        title = titleState.text,
                        author = authorState.text,
                        genre = genreState.text,
                        description = descriptionState.text,
                        pageNumber = pageNumberState.text,
                        review = reviewState.text,
                        quotes = quotesState.text
                    )
                }
            }
        }
    }
}

@Composable
fun BookTopBar(title: String) {
    TopAppBar(
        title = {
            Text(
                text = title,
                textAlign = TextAlign.Center,
                modifier = Modifier
                    .fillMaxSize()
                    .wrapContentSize(Alignment.Center)
            )
        },
        backgroundColor = Color.Gray
    )
}

@Composable
fun BookDetails(
    title: String,
    author: String,
    genre: String,
    description: String,
    pageNumber: String,
    review: String,
    quotes: String
) {
    Column{
        Spacer(modifier = Modifier.height(8.dp))

        Column(modifier = Modifier.padding(start = 16.dp, end = 16.dp, bottom = 16.dp)){
            Text(
                text = title,
                modifier = Modifier.baseLineHeight(32.dp),
                style = MaterialTheme.typography.h5,
                fontWeight = FontWeight.Bold
            )
        }

        BookProperty(stringResource(R.string.title), title)
        BookProperty(stringResource(R.string.author), author)
        BookProperty(stringResource(R.string.genre), genre)
        BookProperty(stringResource(R.string.description), description)
        BookProperty(stringResource(R.string.pagenumber), pageNumber)
        BookProperty(stringResource(R.string.review), review)
        BookProperty(stringResource(R.string.quotes), quotes)
    }

}

@Composable
fun BookProperty(label: String, value: String){
    Column(modifier = Modifier.padding(start = 16.dp, end = 16.dp, bottom = 16.dp)){
        Divider()
        CompositionLocalProvider(LocalContentAlpha provides ContentAlpha.medium) {
            Text(
                text = label,
                modifier = Modifier.baseLineHeight(24.dp),
                style = MaterialTheme.typography.caption
            )
        }
        Text(
            text = value,
            modifier = Modifier.baseLineHeight(24.dp),
            style = MaterialTheme.typography.body1
        )
    }
}


@Composable
fun DetailsTopBar(topAppBarText: String) {

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
        backgroundColor = Color.Gray
    )

}


