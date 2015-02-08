//
//  MoviesViewController.swift
//  Traxion
//
//  Created by Kurt Ruppel on 2/2/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    let refreshControl = UIRefreshControl()

    var movies: [NSDictionary]! = []
    var selectedMovie: NSDictionary! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        fetch()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onRefresh() -> Void {
        fetch()
    }
    
    func fetch() -> Void {
        let url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=30&country=us&apikey=dagqdghwaq3e3mxyrp7kmmj5")
        let request = NSURLRequest(URL: url!)
        
        MBProgressHUD.showHUDAddedTo(view, animated: true)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
            if (error != nil) {
                TSMessage.showNotificationInViewController(self, title: "Network error", subtitle: nil, type: TSMessageNotificationType.Error, duration: 60.0)
            } else {
                let responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                
                self.movies = responseDictionary["movies"] as [NSDictionary]
                self.tableView.reloadData()
            }

            self.refreshControl.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieTableViewCell") as MovieTableViewCell

        var movie = movies[indexPath.row]
        var url = movie.valueForKeyPath("posters.thumbnail") as String
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        cell.posterView.setImageWithURL(NSURL(string: url))
        
        return cell
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedMovie = movies[indexPath.row] as NSDictionary

        return indexPath
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var viewController = segue.destinationViewController as MovieViewController
        
        viewController.movie = selectedMovie
    }

}
