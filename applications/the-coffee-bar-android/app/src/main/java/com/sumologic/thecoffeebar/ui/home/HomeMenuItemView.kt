package com.sumologic.thecoffeebar.ui.home

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.findFragment
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModelProvider
import com.sumologic.thecoffeebar.R
import com.sumologic.thecoffeebar.databinding.HomeMenuBinding

class HomeMenuItemView(ctx: Context, val id: String) : LinearLayout(ctx) {
    init {
        inflate(context, R.layout.home_menu_item, this)

        val amount = MutableLiveData(0)
        val amountView = findViewById<TextView>(R.id.amount)
        val plusButton = findViewById<Button>(R.id.plus_button)
        val minusButton = findViewById<Button>(R.id.minus_button)

        amount.observeForever {
            amountView.text = it.toString()
            AppState.order[id] = it
        }

        plusButton.setOnClickListener {
            amount.value = (amount.value ?: 0) + 1
        }

        minusButton.setOnClickListener {
            amount.value = Math.max(0, (amount.value ?: 0) - 1)
        }
    }

    var image: Int? = null
        set(value) {
            if (value != null) {
                val view = findViewById<ImageView>(R.id.imageView)
                view.setImageResource(value)
                field = value
            }
        }

    var title: String = ""
        set(value) {
            val view = findViewById<TextView>(R.id.title)
            view.text = value
            field = value
        }

    var description: String = ""
        set(value) {
            val view = findViewById<TextView>(R.id.description)
            view.text = value
            field = value
        }

    var price: Int = 0
        set(value) {
            val view = findViewById<TextView>(R.id.price)
            view.text = "Price: $${value/100}"
            field = value
        }
}