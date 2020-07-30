//
//  ViewController.swift
//  Todoey
//
//  Created by Sumit K Agarwal on 7/29/20.
//  Copyright © 2020 Shruti Agarwal. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray:[Item] = [Item(title: "SAT Prep"),Item(title: "Study Udemy"), Item(title: "Eat ice cream")]
    //["SAT Prep", "Study Udemy", "Eat ice cream"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //sets the itemArray to the defaults array if it isn't nil (after adding one item it won't be nil)
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
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

        tableView.reloadData()
        
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
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        
        
       
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}

