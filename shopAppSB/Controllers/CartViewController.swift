//
//  CartViewController.swift
//  shopAppSB
//
//  Created by developer on 5/15/22.
//

import UIKit

class CartViewController: UIViewController {

    var vm: CartViewModel?
    @IBOutlet weak var cartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.dataSource = self
        cartTableView.delegate = self
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        cartTableView.register(nib, forCellReuseIdentifier: "Item")
    }

}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm?.itemCount ?? 0
    }
    
    private func buy(rowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let buyAction = UIContextualAction(style: .destructive, title: "Buy") {
            _, _, _ in
            if let cartItems = self.vm?.cartItems {
                let item = cartItems[cartItems.count - 1 - indexPath.row]
                CartViewModel.saveToPhone(products: [item])
                /*print("user bought: \(item.name ?? "") which cost: \(item.price ?? "")")*/
            }
            
                
        }
        buyAction.backgroundColor = .systemTeal
        return buyAction
    }
    
    private func remove(rowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let removeAction = UIContextualAction(style: .destructive, title: "Remove") {
            _, _, _ in
            if let cartItems = self.vm?.cartItems {
                let item = cartItems[cartItems.count - 1 - indexPath.row]
                self.vm?.removeFromCart(productVM: item)
            }
            DispatchQueue.main.async {
                
                if self.vm?.itemCount == 0 {
                    self.cartTableView.deleteRows(at: self.getLastIndexPaths(), with: .fade)
                }else {
                    self.cartTableView.deleteRows(at: [indexPath], with: .fade)
                }
                self.cartTableView.reloadData()
            }
                
        }
        
        removeAction.backgroundColor = .systemYellow
        return removeAction
    }
    
    func getLastIndexPaths() -> [IndexPath] {
        self.cartTableView?.indexPathsForVisibleRows ?? []
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let buy = self.buy(rowAtIndexPath: indexPath)
        let removeFromCart = self.remove(rowAtIndexPath: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [buy, removeFromCart])
        return swipe
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cartTableView.dequeueReusableCell(withIdentifier: "Item") as? TableViewCell else {
            return UITableViewCell()
        }
        guard let cartItems = self.vm?.cartItems else {
            print("unable to set cart items")
            return UITableViewCell()
        }
        //cell.cellImage.image = nil
        
        let productVM = cartItems[cartItems.count - 1 - indexPath.row]
        productVM.rowNumber = indexPath.row
        cell.configure(productVM: productVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let index = cartTableView.indexPathForSelectedRow
        else {
            print("couldn't find index path of selected row")
            return
        }
        
        let chosenCell = cartTableView.cellForRow(at: index) as? TableViewCell
        
        guard let chosenVM = chosenCell?.productVM else {
            print("cell didn't have a vm attached")
            return
        }
        print(chosenVM.name)
        print(chosenVM.price)
    }
}
