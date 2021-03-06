//
//  ViewController.swift
//  UpdatedAlamofire
//
//  Created by IOS on 16/07/20.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class ViewController: UIViewController {
    
    var arrVehicle = [GetVehicleMakeData]()
    
    
    @IBOutlet weak var tblViw: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webServices(KEmptyParams, API.getVehicleMake, API.getVehicleMake)
    }
    
    //MARK: - WEB SERVICES
    func webServices(_ parameter: [String:Any],_ apiURL: String,_ type: String){
        self.showHudd()
        sharedInstance.dataTaskPostMapper(controller: self,request: apiURL,isHeaderRequired:true, params: parameter, completion: {
            result in
            self.hideHudd()
            let json = JSON(result)
            let code = json["statusCode"].intValue
            let msg = json["message"].stringValue
            print("\(apiURL) response: \(json)")
            if code == 200{
                let responseModel = Mapper<GetVehicleMakeBase>().map(JSONObject: result)
                if let data = responseModel?.data{
                    self.arrVehicle.removeAll()
                    self.arrVehicle = data
                    self.tblViw.reloadData()
                }
            }
            if code == 400{
                self.view.makeToast(msg, duration: 3, position: .center)
            }
        })
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVehicle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = arrVehicle[indexPath.row].make_name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "GoToVC") as! GoToVC
        nextVC.makeID = arrVehicle[indexPath.row].make_id ?? ""
        navigationController?.pushViewController(nextVC, animated: true)
    }
        
}


