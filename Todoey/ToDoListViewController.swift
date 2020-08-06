//
//  ViewController.swift
//  Todoey
//
//  Created by Sumit K Agarwal on 7/29/20.
//  Copyright © 2020 Shruti Agarwal. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: SwipeTableViewController {

    var itemArray:[Item] = [Item]()
    var selectedCategory:Category? {
        didSet{
            //triggers when selectedCategory gets assigned a value
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
        tableView.rowHeight = 80.0
 
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // Configure the cell’s contents.
        cell.textLabel!.text = item.title
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        //deselecting animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        //sets checked property
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        //straight up removes the item you clicked on
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
    }
    
    //MARK: - IB Actions

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
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
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.checked = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        
       
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Persistent Container Manipulation Methods
    
    func saveItems(){
        //set up the code to use CD for saving our new items that have been added through uialert
        //save
        do {
            try context.save()
        } catch {
            print ("error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let parameterPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, categoryPredicate])
            
            //add query to request (basically customizing the request to grab items which correspond with the category)
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        //need to specify the entity you want to request (Item in this case) -- > Parameter
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context: \(error)")
        }
        
        self.tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        let item = self.itemArray[indexPath.row]
        self.context.delete(item)
        self.itemArray.remove(at: indexPath.row)
        
        //self.saveItems()
        do {
            try self.context.save()
        } catch {
            print ("error saving context \(error)")
        }
    }
    
    
}


extension ToDoListViewController: UISearchBarDelegate {
    
    //MARK - Search Bar Delegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //send a request
        let request:NSFetchRequest<Item> = Item.fetchRequest() //<item> returns an array of items
        
        print(searchBar.text!)
        //query the database
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        //sort the data we get back
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) //alphabetical order
        
        //add the sort descriptor to the request
        request.sortDescriptors = [sortDescriptor]
        
        //run our request and fetch the results
        //try using our context to fetch these results
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text!.count == 0) {
            loadItems()
            
            //dispatch queue lines up the projects on the diff threads (in this case --> main)
            DispatchQueue.main.async {
                //should no longer be the thing that is currently selected
                searchBar.resignFirstResponder()   //resigns its status as first responder

            }
            
        }
    }
}

