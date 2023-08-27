//
//  MapAPIManager.swift
//  MapAPIProject
//
//  Created by 박다혜 on 2023/08/27.
//

import Foundation
import Alamofire

class MapAPIManager {

    static let shared = MapAPIManager()

    private init(){}

    func request(keyword: String, x: String, y: String, completionHandler: @escaping (LocationData) -> Void) {

        let url = "https://dapi.kakao.com/v2/local/search/keyword?query=\(keyword)"
        let headers = HTTPHeaders(["Authorization":APIKey.kakaoKey])

        AF.request(url, method: .get, headers: headers).validate()
            .responseDecodable(of: LocationData.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                }
            }
    }


}
