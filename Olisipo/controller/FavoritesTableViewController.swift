//
//  FavoritesTableViewController.swift
//  Olisipo
//
//  Created by Tiago Xavier da Cunha Almeida on 03/08/18.
//  Copyright © 2018 tiagoAlmeida. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    var label = UILabel()
    var fetchedResultController: NSFetchedResultsController<FavoriteMovie>!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        //searchController.searchBar.backgroundColor = .white
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        configurelabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadFavoriteMovies()
    }
    
    
    
    func loadFavoriteMovies(filtering: String = ""){
        let request : NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        if !filtering.isEmpty {
            let predicate = NSPredicate(format: "title contains [c] %@", filtering)
            request.predicate = predicate
        }
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    fileprivate func configurelabel() {
        label.text = "No Favorite Movies"
        label.textColor = UIColor.white
        label.textAlignment = .center
    }

    

    // MARK: - Table view data source

    
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? label : nil
        
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoriteMovieCell
        
        cell.frame = cell.frame.inset(by: UIEdgeInsets.init(top: 40, left: 0, bottom: 10, right: 0))

        if let favoriteMovie = fetchedResultController.fetchedObjects?[indexPath.row] {
            cell.updateCell(movie: favoriteMovie)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let favoriteMovie = fetchedResultController.fetchedObjects?[indexPath.row] {
            performSegue(withIdentifier: "favoriteToDetail", sender: favoriteMovie)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteToDetail" {
            
            
            if let navigationVC = segue.destination as? UINavigationController {
                if let detailVC = navigationVC.viewControllers.first as? MovieDetailViewController,
                    let index = tableView.indexPathForSelectedRow {
                    if let id = Int((fetchedResultController.fetchedObjects?[index.item].id)!) {
                        detailVC.idMovie = id
                    }
                }
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteFavorite(index: indexPath.row, context: context)
        }
    }
    
    func deleteFavorite(index: Int, context: NSManagedObjectContext){
        if let favoriteMovie = fetchedResultController.fetchedObjects?[index] {
            context.delete(favoriteMovie)
            
        }
        
        
    }

}

extension FavoritesTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
           
        default:
            tableView.reloadData()
        }
        
        
    }
}

extension FavoritesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.loadFavoriteMovies()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadFavoriteMovies(filtering: searchText)
        tableView.reloadData()
    }
    
    
}
