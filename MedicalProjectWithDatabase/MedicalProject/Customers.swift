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
    var custNum: String?
    var choice: String?
    var deliv: String?
    var time: String?
    var delivStat: String?
    
    init(custName:String?, custAddy:String?, custNum:String?, choice:String?, deliv:String?, time:String?, delivStat:String?){
        self.custName = custName;
        self.custAddy = custAddy;
        self.custNum = custNum;
        self.choice = choice;
        self.deliv = deliv;
        self.time = time;
        self.delivStat = delivStat;
    }
}
