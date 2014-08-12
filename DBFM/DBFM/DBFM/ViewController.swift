
import UIKit
import MediaPlayer
import QuartzCore

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,HttpProtocal,ChannelProtocol {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet var playTime : UILabel!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var tableview : UITableView!
    
    @IBOutlet var tap: UITapGestureRecognizer?=nil
    @IBOutlet weak var btnPlay: UIImageView!
    
    var httpController:HttpController=HttpController();
    var tableData:NSArray = NSArray()
    var channelData:NSArray = NSArray()
    var imageCache=Dictionary<String,UIImage>()
    var audioPlayer:MPMoviePlayerController = MPMoviePlayerController()
    var timer:NSTimer?
    
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        println("tap")
        if sender.view==btnPlay{
            btnPlay.hidden = true
            audioPlayer.play()
            btnPlay.removeGestureRecognizer(tap!)
            imageView.addGestureRecognizer(tap!)
        } else {
            btnPlay.hidden = false
            audioPlayer.pause()
            btnPlay.addGestureRecognizer(tap!)
            imageView.removeGestureRecognizer(tap!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        httpController.delegate = self
        httpController.onSearch("http://www.douban.com/j/app/radio/channels")
        httpController.onSearch("http://douban.fm/j/mine/playlist?channel=0")
        self.progressView.progress = 0.0
        self.imageView.addGestureRecognizer(tap!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var channelC:ChannelController=segue.destinationViewController as ChannelController
        channelC.delegate = self
        channelC.channelData = self.channelData
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return self.tableData.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!){
        cell.layer.transform=CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            cell.layer.transform=CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "douban")
        let rowData:NSDictionary = self.tableData[indexPath.row] as NSDictionary
        cell.textLabel.text = rowData["title"] as String
        cell.detailTextLabel.text=rowData["artist"] as String
        
        cell.imageView.image = UIImage(named: "detail.jpg")
        
        let url = rowData["picture"] as String
        let image = self.imageCache[url] as UIImage?
        if image? == nil{
            let imgURL:NSURL=NSURL(string: url)
            let request:NSURLRequest=NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (respond:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                let img = UIImage(data: data)
                cell.imageView.image = img
                self.imageCache[url] = img
            })
        } else {
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        var song:NSDictionary = self.tableData[indexPath.row] as NSDictionary;
        var audioUrl:String = song["url"] as String
        onSetAudio(audioUrl)
        var imgUrl:String = song["picture"] as String
        onSetImage(imgUrl)
    }
    
    func didReceiveResults(results: NSDictionary) {
        println(results)
        if results["song"]{
            self.tableData = results["song"] as NSArray
            self.tableview.reloadData()
            
            let firstDict:NSDictionary=self.tableData[0] as NSDictionary
            let audioUrl:String = firstDict["url"] as String
            onSetAudio(audioUrl)
            let imgUrl:String = firstDict["picture"] as String
            onSetImage(imgUrl)
        } else if results["channels"]{
            self.channelData = results["channels"] as NSArray
        }
    }
    
    func onChannelChanged(channel_id: String) {
        let url:String = "http://douban.fm/j/mine/playlist?\(channel_id)"
        httpController.onSearch(url)
    }
    
    func onSetAudio(url:String){
        timer?.invalidate()
        playTime.text="00:00"
        self.audioPlayer.stop()
        self.audioPlayer.contentURL = NSURL(string: url)
        self.audioPlayer.play()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        btnPlay.removeGestureRecognizer(tap!)
        imageView.addGestureRecognizer(tap!)
        btnPlay.hidden = true
    }
    
    func onUpdate(){
        let c=audioPlayer.currentPlaybackTime
        if c>0.0{
            let t = audioPlayer.duration
            let p:CFloat=CFloat(c/t)
            progressView.setProgress(p,animated:true)
            
            let all:Int = Int(c)
            let m:Int = all % 60
            let f:Int = all / 60
            var time:String = ""
            if f<10{
                time="0\(f):"
            } else {
                time="\(f):"
            }
            
            if m<10{
                time+="0\(m)"
            } else {
                time+="\(m)"
            }
        playTime.text = time
        }
        
    }
    
    func onSetImage(url:String){
        let image = self.imageCache[url] as UIImage?
        if image? == nil{
            let imgURL:NSURL=NSURL(string: url)
            let request:NSURLRequest=NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (respond:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                let img = UIImage(data: data)
                self.imageView.image = img
                self.imageCache[url] = img
            })
        } else {
            self.imageView.image = image
        }
    }
}

