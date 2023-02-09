package com.example.lab2db.books.presentation.home.components

import android.util.Log
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CornerSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import com.example.lab2db.R
import com.example.lab2db.books.domain.model.Book

@Composable
fun bookItem(
    modifier: Modifier = Modifier,
    book: Book,
    onEditBook: () -> Unit,
    onDeleteBook: () -> Unit,
    onDetails: () -> Unit
) {

    Card(
        modifier = modifier
            .fillMaxWidth()
            .padding(horizontal = 14.dp, vertical = 12.dp),
        elevation = 3.dp,
        shape = RoundedCornerShape(corner = CornerSize(16.dp))
    ) {
        Image(
            painter = painterResource(id = R.drawable.book4), contentDescription = null,
            contentScale = ContentScale.Crop,
            modifier = Modifier.fillMaxSize()
        )
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.SpaceBetween
//            horizontalArrangement = Arrangement.SpaceBetween
        ) {// by ${book.author}
            Column(verticalArrangement = Arrangement.Center) {
                Text(
                    text = book.title,
                    style = MaterialTheme.typography.h5
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = book.author,
                    style = MaterialTheme.typography.h6
                )
                Text(
                    text = "${book.pageNumber.toString()} pages",
                    style = MaterialTheme.typography.caption.copy(color = Color.Magenta)
                )
            }
            Row {
                IconButton(onClick = onEditBook) {
                    Icon(
                        imageVector = Icons.Default.EditNote,
//                        imageVector = Icons.Filled.Edit,
                        contentDescription = null,
                        tint = Color.DarkGray
                    )
                }
                IconButton(onClick = onDeleteBook) {
                    Icon(
                        imageVector = Icons.Filled.Delete,
                        contentDescription = null,
                        tint = Color.DarkGray
                    )
                }
                IconButton(onClick = onDetails) {
                    Log.d("CREATED", "DETAILS")
                    Icon(
                        imageVector = Icons.Default.Pages,
                        contentDescription = null,
                        tint = Color.DarkGray
                    )

                }
            }
        }
    }

}