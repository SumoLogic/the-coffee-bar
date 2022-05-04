package com.sumologic.thecoffeebar.ui.checkout

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.widget.TextView
import androidx.core.content.ContextCompat.getSystemService
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.sumologic.thecoffeebar.MainActivity
import com.sumologic.thecoffeebar.databinding.FragmentCheckoutBinding
import com.sumologic.thecoffeebar.ui.home.AppState
import com.sumologic.thecoffeebar.ui.home.MENU
import okhttp3.*
import org.json.JSONObject
import java.io.IOException
import kotlinx.serialization.*
import kotlinx.serialization.json.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody

private data class OrderSummary(val coffee: Int, val pastry: Int, val total: Int)

class CheckoutFragment : Fragment() {

    private var _binding: FragmentCheckoutBinding? = null

    // This property is only valid between onCreateView and
    // onDestroyView.
    private val binding get() = _binding!!

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View {
        _binding = FragmentCheckoutBinding.inflate(inflater, container, false)
        val root: View = binding.root

        val textView: TextView = binding.text
        val orderSummary = getOrderSummary()
        textView.text = "Coffee: $${orderSummary.coffee / 100}\nPastry: $${orderSummary.pastry / 100}\nTotal: $${orderSummary.total / 100}"

        binding.input.setOnEditorActionListener { _, actionId, _ ->
            if (actionId == EditorInfo.IME_ACTION_SEND) {
                val inputMethodManager = context?.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                inputMethodManager.hideSoftInputFromWindow(binding.input.windowToken, 0)

                binding.payButton.callOnClick()
                return@setOnEditorActionListener true
            }
            false
        }
        
        binding.cancelButton.setOnClickListener {
            activity?.let {
                if (it is MainActivity) {
                    it.onSupportNavigateUp()
                }
            }
        }

        binding.payButton.setOnClickListener {
            val coffeeAmount = AppState.order.map { entry ->
                val config = MENU["coffee"]?.find { it.id == entry.key }
                if (config == null) 0 else entry.value
            }.sum()
            val pastryAmount = AppState.order.map { entry ->
                val config = MENU["pastry"]?.find { it.id == entry.key }
                if (config == null) 0 else entry.value
            }.sum()

            val coffee = when {
                AppState.order["coffee1"] ?: 0 > 0 -> "espresso"
                AppState.order["coffee2"] ?: 0 > 0 -> "cappucino"
                AppState.order["coffee3"] ?: 0 > 0 -> "americano"
                else -> ""
            }

            val sweets = when {
                AppState.order["pastry1"] ?: 0 > 0 -> "tiramisu"
                AppState.order["pastry2"] ?: 0 > 0 -> "cornetto"
                AppState.order["pastry3"] ?: 0 > 0 -> "muffin"
                else -> ""
            }

            val payload = mapOf(
                "bill" to binding.input.text.toString().ifEmpty { "0" }.toDouble(),
                "coffee" to coffee,
                "coffee_amount" to coffeeAmount,
                "sweets" to sweets,
                "sweets_amount" to pastryAmount,
                "total" to orderSummary.total / 100,
                "water" to 10
            )
            val body = JSONObject(payload).toString()

            println("-- send ${body}")

            val client = OkHttpClient()
            val request = Request.Builder()
                .method("POST", body.toRequestBody("application/json; charset=utf-8".toMediaType()))
                .url("http://a03e06822ab5946b986382a8830bbb76-1553635081.us-west-2.elb.amazonaws.com:8082/order")
                .build()
            client.newCall(request).enqueue(object : Callback {
                override fun onFailure(call: Call, e: IOException) {
                    println("-- failure ${e}")
                }

                override fun onResponse(call: Call, response: Response) {
                    Handler(Looper.getMainLooper()).post {
                        AlertDialog.Builder(context)
                            .setMessage("Status: ${response.code}\nBody: ${response.body!!.string()}")
                            .show()
                    }
                }
            })
        }
        return root
    }

    private fun getOrderSummary(): OrderSummary {
        val coffee = AppState.order.map { entry ->
            val config = MENU["coffee"]?.find { it.id == entry.key }
            if (config == null) 0 else config.price * entry.value
        }.sum()
        val pastry = AppState.order.map { entry ->
            val config = MENU["pastry"]?.find { it.id == entry.key }
            if (config == null) 0 else config.price * entry.value
        }.sum()
        val total = coffee + pastry

        return OrderSummary(coffee, pastry, total)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}