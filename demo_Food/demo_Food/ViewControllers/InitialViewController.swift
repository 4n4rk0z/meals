//
//  InitialViewController.swift
//  demo_Food
//
//  Created by 4n4rk0z on 17/02/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class InitialViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	private var searchResult = [JSON]() {
		didSet{
			tableView.reloadData()
		}
	}
	
	private let searchController = UISearchController(searchResultsController: nil)
	private let api: API = API()
	private var previous = Date()
	private let minInterval = 0.05
	var idMeal: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		setupTableView()
		setupSearchBar()
		
    }
    
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toDetail"{
			if segue.destination.isKind(of: DetailViewController.self){
				let vc = segue.destination as! DetailViewController
				vc.idMeal = idMeal
			}
		}
    }
	
	private func setupSearchBar() {
		searchController.searchBar.delegate = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.placeholder = "Search Any Meal"
		definesPresentationContext = true
		tableView.tableHeaderView = searchController.searchBar
	}
	
	private func setupTableView() {
		let backgroundViewLabel = UILabel(frame: .zero)
		backgroundViewLabel.textColor = .darkGray
		backgroundViewLabel.numberOfLines = 0
		backgroundViewLabel.text = "No results.."
		backgroundViewLabel.textAlignment = NSTextAlignment.center
		tableView.backgroundView = backgroundViewLabel
		
	}

}

extension InitialViewController: UITableViewDelegate, UITableViewDataSource {
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InitialTableViewCell
		cell.lblDishName.text = searchResult[indexPath.row]["strMeal"].string
		cell.lblDishDescription.text = searchResult[indexPath.row]["strCategory"].stringValue
		if let url = searchResult[indexPath.row]["strMealThumb"].string {
			api.fetchImage(url: url, Handler:{ image, _ in
				cell.imgFoodDish.image = image
				
			})
		}
		return cell
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let strMealId = searchResult[indexPath.row]["idMeal"].stringValue
		idMeal = strMealId
		performSegue(withIdentifier: "toDetail", sender: nil)
	}
    
}

extension InitialViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchResult.removeAll()
		guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
			return
		}
		
		if Date().timeIntervalSince(previous) > minInterval {
			previous = Date()
			fetchResult(for: textToSearch)
		}
	}
	
	func fetchResult(for text: String) {
		api.search(searchText: text, Handler: {
			[weak self] results, error in
			if case .failure = error {
				return
			}
			
			guard let results = results, !results.isEmpty else {
				return
			}
			
			self?.searchResult = results
		})
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchResult.removeAll()
	}
	
}
