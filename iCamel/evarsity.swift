//
//  evarsity.swift
//  iCamel
//
//  Created by Sayan Das on 04/07/15.
//  Copyright © 2015 Sayan Das. All rights reserved.
//

import Foundation

class evarsity {
    
    private var ID: String!
    private var Password: String!
    private var attendanceDataHTML: String!
    var AttendanceDict = [AttendanceDetails]()
    var gotData: Bool!
    
    // MARK:-  Main data structure
    struct AttendanceDetails {
        var Subject: String
        var Max_Hours: String
        var Att_Hours: String
        var Absent_Hours: String
        var AveragePerc: String
        var OD_ML: String
        var Total: String
        var subjectCode: String!
        
        init(){
            Subject = ""
            Max_Hours = ""
            Att_Hours = ""
            Absent_Hours = ""
            AveragePerc = ""
            OD_ML = ""
            Total = ""
            subjectCode = ""
        }
    }
    
    
    //  INITIALIZE WITH ID AND PASSWORD
    init(ID: String, Password: String){
        self.ID = ID
        self.Password = Password
        gotData = false
    }
    
    //  BLANK INITIALIZATION
    init(){
        self.ID = ""
        self.Password = ""
        gotData = false
    }
    
    
    //MARK:- Function to be called from AttendanceOverView.swift
    func fetchAndReturnData() -> [AttendanceDetails]{
        createHTTPRequest()
        
        //  WAIT FOR gotData TO BE TRUE
        while(!gotData){}                           //Update this
        return self.AttendanceDict
    }
    
    //MARK:- create NSURL with ID and Password
    func createNSURL() -> NSURL{
        let parentLink: String = "http://evarsity.srmuniv.ac.in/srmswi/usermanager/youLogin.jsp"
        let parameters: String = "?txtRegNumber=iamalsouser&txtPwd=thanksandregards&txtSN=\(ID)&txtPD=\(Password)&txtPA=1"
    
        return NSURL(string: parentLink + parameters)!
    }
    
    //MARK:- Create HTTP request and create NSURLSession to fetch AJAX attendance table
    func createHTTPRequest(){
        let request = NSMutableURLRequest(URL: createNSURL())
        request.HTTPMethod = "POST"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            let attendanceURL = "http://evarsity.srmuniv.ac.in/srmswi/resource/StudentDetailsResources.jsp?resourceid=7"
            let attendanceAJAX = NSURL(string: attendanceURL)
            let data = NSData(contentsOfURL: attendanceAJAX!)
            let dataSTR = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            self.attendanceDataHTML = dataSTR as! String
            self.parseData()
            self.gotData = true
            print(dataSTR)
//            self.saveToDisk()
        })
        task?.resume()
        
    }
    
    //MARK:- Save the file to disk for the offline support
    func saveToDisk(){
        
    }
    
    
    //MARK:- Parse the table to AttendanceDict
    func parseData(){
        
        trimTableData()
        let pattern = "<TD class=\"tablecontent[0-9][0-9]\"> ([A-Za-z0-9. -])+</TD>"
        let length = NSString(string: attendanceDataHTML).length
        let regex = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
        
        let matches = regex.matchesInString(attendanceDataHTML, options: [], range: NSRange(location: 0, length: length))
        
        var index = 0
        var value = AttendanceDetails()
        for match in matches{
            let subSTR = (attendanceDataHTML as NSString).substringWithRange(match.range)
            let TRdata = getTextFromTR(subSTR)
            
            if index == 0{ value.subjectCode = TRdata }
            if index == 1{ value.Subject = TRdata}
            if index == 2{ value.Max_Hours = TRdata }
            if index == 3{ value.Att_Hours = TRdata }
            if index == 4{ value.Absent_Hours = TRdata }
            if index == 5{ value.AveragePerc = TRdata }
            if index == 6{ value.OD_ML = TRdata }
            if index == 7{ value.Total = TRdata
            index = -1
                self.AttendanceDict.append(value)
            }
            index = index + 1
        }
        
    }
    
    //MARK:-  get the text details from the table row
    func getTextFromTR(TR: String) -> String{
        let mutableTR = NSMutableString(string: TR)
        
        var pattern = "<TD class=\"tablecontent[0-9][0-9]\"> "
        var length = mutableTR.length
        let regex = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
        regex.replaceMatchesInString(mutableTR, options: [], range: NSRange(location: 0, length: length), withTemplate: "")
        
        pattern = "</TD>"
        let regex_ = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
        length = mutableTR.length
        regex_.replaceMatchesInString(mutableTR, options: [], range: NSRange(location: 0, length: length), withTemplate: "")
        
        return mutableTR as String
    }
    
    //MARK:- Get the first table tag
    func trimTableData(){
        let mutableAttendanceDataHTML = NSMutableString(string: attendanceDataHTML)
        var length = mutableAttendanceDataHTML.length
        
        var pattern = "</table>[\\s\\S]+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
        regex.replaceMatchesInString(mutableAttendanceDataHTML, options: [], range: NSRange(location: 0, length: length), withTemplate: "")
        
        length = mutableAttendanceDataHTML.length
        pattern = "[\\s\\S]+<table>"
        let regex_ = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
        regex_.replaceMatchesInString(mutableAttendanceDataHTML, options: [], range: NSRange(location: 0, length: length), withTemplate: "")
        
        self.attendanceDataHTML = mutableAttendanceDataHTML as String
        
    }
    
}