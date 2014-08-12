
import UIKit

class ChannelController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return 10
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"channel")
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
