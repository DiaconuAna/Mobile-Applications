package com.example.lab2db.books.presentation.home

import android.app.AlertDialog
import android.app.Dialog
import android.os.Bundle
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.viewModels


class DeleteDialogFragment: DialogFragment() {

    private val viewModel: HomeViewModel by viewModels()

    companion object{
        fun newInstance(event: HomeEvent) : DeleteDialogFragment{
            val f = DeleteDialogFragment()
                return f;
//            args.put
        }
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog =
        AlertDialog.Builder(requireContext())
            .setTitle("Confirm deletion")
            .setMessage("Do you really want to delete all completed tasks?")
            .setNegativeButton("Cancel", null)
            .setPositiveButton("Yes") { _, _ ->
                //viewModel.onEvent()
            }
            .create()
}

/*
 companion object {
        fun newInstance(isStarted: Boolean): DatePickerFragmentDialog {
            val f = DatePickerFragmentDialog()
            // Supply isStarted input as an argument.
            val args = Bundle()
            args.putBoolean("isStarted", isStarted)
            f.arguments = args
            return f
        }
    }
 */