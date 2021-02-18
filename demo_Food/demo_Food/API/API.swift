//
//  API.swift
//  demo_Food
//
//  Created by 4n4rk0z on 17/02/21.
//

import Foundation
import SwiftyJSON
import Alamofire

enum NetworkErrors: Error {
	case failure
	case success
}

class API {
	var Searchresul = [JSON]()
	
	func search(searchText: String, Handler: @escaping([JSON]?, NetworkErrors) -> ()) {
		let urlSearch = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(searchText)"
		
		
		Alamofire.request(urlSearch).responseJSON{ response in
			guard let data = response.data else {
				Handler(nil, .failure)
				return
			}
			
			let json = try? JSON(data: data)
			let result = json?["meals"].arrayValue
			guard let empty = result?.isEmpty, !empty else {
				Handler(nil, .failure)
				return
			}
			Handler(result, .success)
		}
	}
	
	func getId(id: String, Handler: @escaping([JSON]?, NetworkErrors) -> ()) {
		let url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
		
		Alamofire.request(url).responseJSON{ response in
			guard let data = response.data else {
				Handler(nil, .failure)
				return
			}
			
			let json = try?JSON(data: data)
			let result = json?["meals"].arrayValue
			guard let empty = result?.isEmpty, !empty else {
				Handler(nil, .failure)
				return
			}
			Handler(result, .success)
		}
	}
	
	func fetchImage(url: String, Handler:@escaping(UIImage?, NetworkErrors) -> ()) {
		Alamofire.request(url).responseData{ responseData in
			
			guard let imageData = responseData.data else {
				Handler(nil, .failure)
				return
			}
			
			guard let image = UIImage(data: imageData) else {
				Handler(nil, .failure)
				return
			}
			
			Handler(image, .success)
		}
	}
}
