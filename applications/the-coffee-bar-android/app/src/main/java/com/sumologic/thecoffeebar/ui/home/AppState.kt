package com.sumologic.thecoffeebar.ui.home

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class AppState {
    companion object {
        val order = mutableMapOf("coffee1" to 0, "coffee2" to 0, "coffee3" to 0, "pastry1" to 0, "pastry2" to 0, "pastry3" to 0, )
    }
}