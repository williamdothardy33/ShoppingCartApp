//
//  ShopViewModel.swift
//  shopAppSB
//
//  Created by developer on 5/14/22.
//

import Foundation


class CartViewModel {
    var cartItems: [ProductViewModel] = [] {
        didSet {
            updateCartIcon()
        }
    }
    
    var cartIconString: String = "cart"
    
    var updateCartIcon: () -> Void = { print("The view controller needs to tell me how to do this") }
    
    var isCartEmpty: Bool {
        self.cartItems.isEmpty
    }
    
    var updateCartDisplay: () -> Void = {
        print("need to set this in the cart view controller") }
    
    func addToCart(productVM: ProductViewModel) {
        if cartItems.count == 0 {
            //add last entry
            let report = ProductViewModel(item: nil, isForItem: false)
            
            report.name = "Num items: \(1)"
            if let priceString = productVM.price, let price = Double(priceString) {
                report.price = "Price \(price)"
            }
            
            
            cartItems.append(report)
            cartItems.append(productVM)
        }else {
            cartItems.append(productVM)
            cartItems[0] = getReport()
        }
    }
    
    var itemCount: Int {
        get {
            self.cartItems.count
        }
    }
    
    var totalPrice: Double {
        get {
            self.cartItems.compactMap({
                Double($0.item?.price ?? 0.0)
            }).reduce(0.0, {
                total, next in
                total + next
            })
        }
    }
    
    func getReport() -> ProductViewModel {
        let report = ProductViewModel(item: nil, isForItem: false)
        
        report.name = "Num items: \(self.itemCount)"
        report.price = "Price \(self.totalPrice)"
        
        return report
    }
    
    func removeFromCart(productVM: ProductViewModel) {
        //need to add logic to find particular item
        //and make sure last item isn't selected
        if let found = self.cartItems.enumerated().first(where: {
            $0.element.item?.name == productVM.item?.name
        }), found.offset != 0 {
            if cartItems.count == 2 {
                cartItems.removeAll()
            }else {
                //need to add logic to find particular item
                cartItems.remove(at: found.offset)
                if cartItems.count > 0 {
                    self.cartItems[0] = getReport()
                }
            }
        }
        
        
    }
    
}

class ProductViewModel {
    var isForItem: Bool
    var rowNumber: Int?
    var item: Item?
    var imageData: Data? {
        didSet {
            useImageData()
        }
    }
    
    var name: String?
    var price: String?
    
    init(item: Item?, isForItem: Bool = true) {
        self.item = item
        self.isForItem = isForItem
        self.name = isForItem ? item?.name : nil
        if let price = item?.price {
            self.price = isForItem ? String(price) : nil
        }
    }
    
    var useImageData: () -> Void = { print("will set this in the browsing cells") }
    var bindModelToCell: () -> Void = { print("will set this is table cell file") }
    
    func loadImageData() {
        if let imageUrl = item?.image_link {
            Webservice.shared.getImage(imageUrl: imageUrl, completion: {
                imageData in
                self.imageData = imageData
            })
        }
    }
}

class ShopViewModel {
    var cart: CartViewModel = CartViewModel()

    var products: [ProductViewModel]? {
        didSet {
            updateProductsDisplay()
        }
    }
    
    var updateProductsDisplay: () -> Void = { print("The view controller needs to tell me how to do this") }
    
    func loadProducts() {
        Webservice.shared.getItems(completion: {
            items in
            self.products = items.map {
                ProductViewModel(item: $0)
            }
        })
    }
}
