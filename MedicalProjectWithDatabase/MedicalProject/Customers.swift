//
//  Customers.swift
//  
//
//  Created by Ricky Yang on 2/9/19.
//

import Foundation

class Customers{
    
    var custName: String?
    var custAddy: String?
    var deliv: String?
    var time: String?
    var delivStat: String?
    
    init(custName:String?, custAddy:String?, deliv:String?, time:String?, delivStat:String?){
        self.custName = custName;
        self.custAddy = custAddy;
        self.deliv = deliv;
        self.time = time;
        self.delivStat = delivStat;
    }
}
