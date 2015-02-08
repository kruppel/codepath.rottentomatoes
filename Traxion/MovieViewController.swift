//
//  MovieViewController.swift
//  Traxion
//
//  Created by Kurt Ruppel on 2/3/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    let overlay = UIView()
    var movie: NSDictionary! = nil

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = posterView.bounds //view is self.view in a UIViewController
        posterView.addSubview(blurEffectView)
        blurEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
        posterView.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: posterView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        posterView.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: posterView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        posterView.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: posterView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        posterView.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: posterView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
*/
        overlay.frame = CGRect(x: self.posterView.bounds.origin.x, y: self.posterView.bounds.origin.y, width: self.posterView.bounds.width, height: self.posterView.bounds.height);
        overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        posterView.addSubview(overlay)

        var tmb = movie.valueForKeyPath("posters.detailed") as NSString
        var range:NSRange = tmb.rangeOfString("_tmb.jpg$", options: .RegularExpressionSearch)
        var orig = tmb.stringByReplacingCharactersInRange(range, withString: "_ori.jpg")

        titleLabel.text = movie["title"] as NSString
        synopsisLabel.text = movie["synopsis"] as NSString
        let url = NSURL(string: orig)
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("image/*", forHTTPHeaderField: "Accept")
        posterView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) -> Void in
            println(image.size)
            self.posterView.image = image
        }, failure: nil)
        view.sendSubviewToBack(posterView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
