//
//  DetailViewController.swift
//  demo_Food
//
//  Created by 4n4rk0z on 17/02/21.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {

	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblIngredients: UILabel!
	private var idResult = [JSON]() {
		didSet{
			self.lblTitle.text = idResult.first?["strMeal"].stringValue
			self.getImage()
		}
	}
	private let api: API = API()
	var idMeal: String!
    override func viewDidLoad() {
        super.viewDidLoad()
		initUI()
    }
	
	private func initUI() {
		api.getId(id: idMeal, Handler: {
			[weak self] results, error in
			if case .failure = error {
				return
			}
			guard let results = results, !results.isEmpty else {
				return
			}
			
			self?.idResult = results
		})
	}
	
	private func getImage(){
		if let url = idResult.first?["strMealThumb"].string {
			api.fetchImage(url: url, Handler:{ image, _ in
				self.imgView.image = image
			})
		}
	}

}
