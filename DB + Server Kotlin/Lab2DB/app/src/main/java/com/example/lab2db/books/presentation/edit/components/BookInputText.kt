package com.example.lab2db.books.presentation.edit.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.Divider
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import com.example.lab2db.R

@Composable
fun BookInputText(
    text: String,
    hint: String,
    modifier: Modifier = Modifier,
    onTextChange: (String) -> Unit
) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .padding(
                start = 16.dp, end = 16.dp, bottom = 16.dp
            )
    ) {
        Text(
            text = hint,
            modifier = Modifier.baseLineHeight(28.dp),
            color = Color(0xFF45464F)
        )
        BasicTextField(
            value = text,
            onValueChange = onTextChange,
            modifier = Modifier.baseLineHeight(28.dp),

        )
        Divider(modifier = Modifier.padding(top = 10.dp))

    }

}