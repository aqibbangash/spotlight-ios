//
//  TermsVC.swift
//  Spotlight
//
//  Created by Aqib on 30/03/2016.
//  Copyright © 2016 Sofit. All rights reserved.
//

import UIKit

class TermsVC: UIViewController {

    @IBOutlet weak var tv: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv.scrollRangeToVisible(NSRange(location:0, length:0))

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
