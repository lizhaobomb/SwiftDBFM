
import UIKit

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,HttpProtocal {
                            
    @IBOutlet var progressView : UIView
    @IBOutlet var playTime : UILabel
    @IBOutlet var imageView : UIImageView
    @IBOutlet var tableview : UITableView
    
    var httpController:HttpController=HttpController();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        httpController.delegate = self
        httpController.onSearch("http://www.douban.com/j/app/radio/channels")
        httpController.onSearch("http://douban.fm/j/mine/playlist?channel=0")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "douban")
        return cell
    }
    
    func didReceiveResults(results: NSDictionary) {
        println("========================")
        println(results)
    }
}

