package com.sumologic.thecoffeebar.ui.home

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.LinearLayout
import android.widget.TextView
import com.sumologic.thecoffeebar.R
import com.sumologic.thecoffeebar.databinding.HomeMenuBinding

data class MenuItem(val id: String, val image: Int, val title: String, val description: String, val price: Int)

val MENU = mapOf(
    "coffee" to listOf<MenuItem>(
        MenuItem(id = "coffee1", image = R.drawable.coffee1, title = "Espresso, where it all begins!", description = "The espresso, also known as a short black, is approximately 1 oz. of highly concentrated coffee.", price = 200),
        MenuItem(id = "coffee2", image = R.drawable.coffee2, title = "Cappucino, to feel the clouds!", description = "A cappuccino is a coffee-based drink made primarily from espresso and milk.", price = 400),
        MenuItem(id = "coffee3", image = R.drawable.coffee3, title = "Americano, to have more!", description = "An Americano is an espresso-based drink designed to resemble coffee brewed in a drip filter.", price = 300)
    ),
    "pastry" to listOf<MenuItem>(
        MenuItem(id = "pastry1", image = R.drawable.pastry1, title = "Tiramisu, elegant and rich layered!", description = "Tiramisu, the delicate flavor of layers of mascarpone and Italian custard are contrasted with the darklyrobust presence of espresso and sharpness of cocoa powder.", price = 300),
        MenuItem(id = "pastry2", image = R.drawable.pastry2, title = "Cornetto, delicious and crispy-baked wafer!", description = "Cornetto is an Italian variation of the Austrian kipferl. A cornetto with an espresso or cappuccino at a coffee bar is considered to be the most common breakfast in Italy.", price = 100),
        MenuItem(id = "pastry3", image = R.drawable.pastry3, title = "Muffin, just a bit of sweetness!", description = "A muffin is batter-based bakery product. It’s formulation is somewhere in between a low-ratio cake and quick bread. Muffin batter is typically deposited or placed into deep, small cup-shaped pan before baking.", price = 100),
    )
)

class HomeMenuView(ctx: Context, attrs: AttributeSet): LinearLayout(ctx, attrs) {
    init {
        inflate(ctx, R.layout.home_menu, this)

        val customAttrs = ctx.obtainStyledAttributes(attrs, R.styleable.HomeMenuView, 0, 0)
        val title = findViewById<TextView>(R.id.title)
        val menuItems = findViewById<LinearLayout>(R.id.menu_items)

        try {
            // title
            title.text = customAttrs.getString(R.styleable.HomeMenuView_title)

            // menu
            val menu = MENU[customAttrs.getString(R.styleable.HomeMenuView_menu_type)]
            menu?.forEach {
                val menuItemView = HomeMenuItemView(context, it.id)
                menuItemView.image = it.image
                menuItemView.title = it.title
                menuItemView.description = it.description
                menuItemView.price = it.price
                menuItems.addView(menuItemView)
            }
        } finally {
            customAttrs.recycle()
        }
    }
}