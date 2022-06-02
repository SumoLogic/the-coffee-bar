import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var state: OrderState
    @Environment(\.dismiss) var dismiss
    @State private var money = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Coffee: x\(state.getCoffeeTotalAmount()) $\(state.getCoffeeTotalPrice() / 100)")
                Text("Pastry: x\(state.getPastryTotalAmount()) $\(state.getPastryTotalPrice() / 100)")
                Text("Total: $\((state.getCoffeeTotalPrice() + state.getPastryTotalPrice()) / 100)")
            }
            TextField("Your money", text: $money)
                .keyboardType(.decimalPad)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 2)
                )
            HStack {
                Button("Cancel", action: {
                    dismiss()
                })
                    .padding()
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                if (state.isOrderInProgress) {
                    ProgressView()
                        .padding()
                } else {
                    Button("Pay", action: {
                        let formatter = NumberFormatter()
                        formatter.locale = Locale.current
                        formatter.numberStyle = .decimal
                        formatter.maximumFractionDigits = 2
                        state.makeOrder(money: formatter.number(from: money)?.decimalValue ?? 0)
                    })
                        .padding(.vertical)
                        .padding(.horizontal, 50)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                }
            }
        }
        .navigationBarTitle("Accept order?")
        .navigationBarHidden(false)
        .padding()
        .alert(state.orderResult ?? "", isPresented: $state.isOrderResultVisible) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
    }
}

struct MenuItem: View {
    @EnvironmentObject var state: OrderState
    var type: OrderItemType
    var image: String
    var title: String
    var description: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
            
            VStack(spacing: 10) {
                Image(image)
                    .resizable()
                    .clipShape(Circle())
                Text(title)
                Text(description)
                    .font(.caption2)
                Text("Price: $\((state.items[type]?.price ?? 0) / 100)")
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(Color.black)
                HStack {
                    Text("\(state.items[type]?.amount ?? 0)")
                    Button("+", action: {
                        state.incAmount(type: type, inc: 1)
                    })
                        .frame(width: 40, height: 50)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .font(.title)
                        .cornerRadius(.infinity)
                    Button("-", action: {
                        state.incAmount(type: type, inc: -1)
                    })
                        .frame(width: 40, height: 50)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .font(.title)
                        .cornerRadius(.infinity)
                }
            }
            .padding()
        }
        .frame(width: 300, height: 400)
    }
}

struct Menu<Content: View>: View {
    var title: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack {
            Text("\(title) menu:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(content: content)
                    .padding(.horizontal)
            }
        }
    }
}

struct ContentView: View {
    var coffeeMenu = Menu(title: "Coffee") {
        MenuItem(
            type: .espresso,
            image: "coffee1",
            title: "Espresso, where it all begins!",
            description: "The espresso, also known as a short black, is approximately 1 oz. of highly concentrated coffee."
        )
        MenuItem(
            type: .cappucino,
            image: "coffee2",
            title: "Cappucino, to feel the clouds!",
            description: "A cappuccino is a coffee-based drink made primarily from espresso and milk."
        )
        MenuItem(
            type: .americano,
            image: "coffee3",
            title: "Americano, to have more!",
            description: "An Americano is an espresso-based drink designed to resemble coffee brewed in a drip filter."
        )
    }
    
    var pastryMenu = Menu(title: "Pastry") {
        MenuItem(
            type: .tiramisu,
            image: "pastry1",
            title: "Tiramisu, elegant and rich layered!",
            description: "Tiramisu, the delicate flavor of layers of mascarpone and Italian custard are contrasted with the darklyrobust presence of espresso and sharpness of cocoa powder."
        )
        MenuItem(
            type: .cornetto,
            image: "pastry2",
            title: "Cornetto, delicious and crispy-baked wafer!",
            description: "Cornetto is an Italian variation of the Austrian kipferl. A cornetto with an espresso or cappuccino at a coffee bar is considered to be the most common breakfast in Italy."
        )
        MenuItem(
            type: .muffin,
            image: "pastry3",
            title: "Muffin, just a bit of sweetness!",
            description: "A muffin is batter-based bakery product. It’s formulation is somewhere in between a low-ratio cake and quick bread. Muffin batter is typically deposited or placed into deep, small cup-shaped pan before baking."
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Image("sumo").resizable().scaledToFit()
                    Text("The Sumo Logic Coffee Bar")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 150)
                ScrollView {
                    VStack(spacing: 30) {
                        coffeeMenu
                        pastryMenu
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 50)
                }
                .frame(maxWidth: .infinity)
                NavigationLink(destination: CheckoutView()) {
                    Text("Checkout")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(OrderState())
    }
}
