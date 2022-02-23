import SwiftUI

enum OrderItemType: String {
    case espresso, cappucino, americano, tiramisu, cornetto, muffin
}

struct OrderItem {
    var price: Int
    var amount: Int = 0
}

struct OrderResponse: Decodable {
    let result: String?
    let reason: String?
    let trace_id: String
}

class OrderState: ObservableObject {
    @Published var items: [OrderItemType: OrderItem] = [
        .espresso: OrderItem(
            price: 200
        ),
        .cappucino: OrderItem(
            price: 400
        ),
        .americano: OrderItem(
            price: 300
        ),
        .tiramisu: OrderItem(
            price: 300
        ),
        .cornetto: OrderItem(
            price: 100
        ),
        .muffin: OrderItem(
            price: 100
        )
    ]
    @Published var isOrderInProgress = false
    @Published var orderResult: String?
    @Published var isOrderResultVisible = false
    
    func incAmount(type: OrderItemType, inc: Int) -> Void {
        items[type]?.amount = max(items[type]!.amount + inc, 0)
    }
    
    func getCoffee() -> [OrderItem] {
        return [items[.espresso]!, items[.cappucino]!, items[.americano]!]
    }
    
    func getPastry() -> [OrderItem] {
        return [items[.tiramisu]!, items[.cornetto]!, items[.muffin]!]
    }
    
    func getCoffeeTotalAmount() -> Int {
        return getCoffee().map({$0.amount}).reduce(0, +)
    }
    func getCoffeeTotalPrice() -> Int {
        return getCoffee().reduce(0, { $0 + ($1.amount * $1.price) })
    }
    
    func getPastryTotalAmount() -> Int {
        return getPastry().map({$0.amount}).reduce(0, +)
    }
    func getPastryTotalPrice() -> Int {
        return getPastry().reduce(0, { $0 + ($1.amount * $1.price) })
    }
    
    func makeOrder(money: Decimal) -> Void {
        print("make order with \(money)")
        isOrderInProgress = true
        let url = URL(string: "http://a03e06822ab5946b986382a8830bbb76-1553635081.us-west-2.elb.amazonaws.com:8082/order")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var coffee: String = ""
        if (items[.espresso]!.amount > 0) {
            coffee = "espresso"
        } else if (items[.cappucino]!.amount > 0) {
            coffee = "cappucino"
        } else if (items[.americano]!.amount > 0) {
            coffee = "americano"
        }
        
        var sweets: String = ""
        if (items[.tiramisu]!.amount > 0) {
            sweets = "tiramisu"
        } else if (items[.cornetto]!.amount > 0) {
            sweets = "cornetto"
        } else if (items[.muffin]!.amount > 0) {
            sweets = "muffin"
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: [
            "bill": money,
            "coffee": coffee,
            "coffee_amount": getCoffeeTotalAmount(),
            "grains": coffee == "espresso" ? 80 : 0,
            "sweets": sweets,
            "sweets_amount": getPastryTotalAmount(),
            "total": (getCoffeeTotalPrice() + getPastryTotalPrice()) / 100,
            "water": 10
        ])
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isOrderInProgress = false
                if let res = response as? HTTPURLResponse {
                    let result = String(data: data!, encoding: .utf8)
                    if (result != nil && result != "") {
                        let resultJson: OrderResponse = try! JSONDecoder().decode(OrderResponse.self, from: data!)
                        self.orderResult = "Reason: \(resultJson.reason ?? "")\nResult: \(resultJson.result ?? "")\nTraceID: \(resultJson.trace_id)"
                    } else {
                        self.orderResult = "Status: \(res.statusCode)"
                    }
                    self.isOrderResultVisible = true
                }
            }
        }
        
        task.resume()
    }
}
