package com.example.lab2db.books.presentation

import android.content.Context
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.example.lab2db.books.presentation.details.DetailsScreen
import com.example.lab2db.books.presentation.edit.AddScreen
import com.example.lab2db.books.presentation.edit.EditScreen
import com.example.lab2db.books.presentation.home.HomeScreen

@Composable
fun Navigation(applicationContext: Context) {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = Screen.Home.route
    ){
        composable(route = Screen.Home.route){
            HomeScreen(navController = navController, appContext = applicationContext)
        }
        composable(route = Screen.Add.route){
            AddScreen(navController = navController, appContext = applicationContext)
        }
        composable(route = Screen.Edit.route,
        arguments = listOf(
            navArgument(
                name = "bookId"
            ){
                type = NavType.IntType
                defaultValue = -1
            }
        )
        ){
            EditScreen(navController = navController, appContext = applicationContext)
        }
        composable(route = Screen.Details.route,
        arguments = listOf(
            navArgument(
                name = "bookId"
            ){
                type = NavType.IntType
                defaultValue = -1
            }
        )
        ){
            Log.d("HELLO?", "here")
            DetailsScreen(navController = navController, appContext = applicationContext)
        }
    }
}