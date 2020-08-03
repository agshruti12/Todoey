//
//  ViewController.swift
//  Todoey
//
//  Created by Sumit K Agarwal on 7/29/20.
//  Copyright © 2020 Shruti Agarwal. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray:[Item] = [Item]()
    //["SAT Prep", "Study Udemy", "Eat ice cream"]
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(dataFilePath)
        
        loadItems()
 
    }

    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // Configure the cell’s contents.
        cell.textLabel!.text = item.title
        
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        //deselecting animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        //sets checked property
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        saveItems()
        
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        //uialert controller
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        //add textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        //add action
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks Add Item button on our alert
            //append textfield into itemArray
            self.itemArray.append(Item(title: textField.text!))
            
            self.saveItems()
        }
        
        
       
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print ("encoder error")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("decoder error")
            }
        }
        
    }
}

