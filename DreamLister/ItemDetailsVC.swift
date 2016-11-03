//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Alvaro De La Cruz on 11/2/16.
//  Copyright © 2016 Alvaro De La Cruz. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        titleField.delegate = self
        priceField.delegate = self
        detailsField.delegate = self
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        fetchStores()
        if itemToEdit != nil {
            loadItemData()
        }
        //generateStores()
    }
    
    //    MARK: - Helpers
    func fetchStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do{
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func loadItemData(){
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            imageView.image = item.toImage?.image as? UIImage
            if let store = item.toStore {
                storePicker.selectRow(getPickerIndexForStoreWith(name: store.name!), inComponent: 0, animated: false)
            }
        }
    }
    
    func getPickerIndexForStoreWith(name: String) -> Int {
        var index = 0
        repeat {
            let store = stores[index]
            if store.name == name {
                break
            }
            index += 1
        }while(index < stores.count)
        return index
    }
    
    func switchTextField(textField: UITextField){
        switch textField {
        case titleField:
            priceField.becomeFirstResponder()
        case priceField:
            detailsField.becomeFirstResponder()
        case detailsField:
            self.view.endEditing(true)
        default:break
        }
    }
    
    
    //    MARK: - UIPickerView Delegate & DataSource
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //    MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchTextField(textField: textField)
        return true
    }
    
    //    MARK: - UIImagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //    MARK: - Actions
    @IBAction func savePressed() {
        var item: Item!
        
        if itemToEdit != nil {
            item = itemToEdit!
        }else{
            item = Item(context: context)
        }
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = Double(price)!
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        let picture = Image(context: context)
        picture.image = imageView.image
        item.toImage = picture
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        if let item = itemToEdit {
            context.delete(item)
            ad.saveContext()
            
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func imagePressed() {
        present(imagePicker, animated: true, completion: nil)
    }
    
}


func generateStores(){
    let store = Store(context: context)
    store.name = "Amazon"
    
    let store1 = Store(context: context)
    store1.name = "BestBuy"
    
    let store2 = Store(context: context)
    store2.name = "Tesla Dealership"
    
    let store3 = Store(context: context)
    store3.name = "Alibaba"
    
    ad.saveContext()
    
}
