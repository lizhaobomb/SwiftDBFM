import UIKit

protocol HttpProtocal{
    func didReceiveResults(results:NSDictionary)
}

class HttpController:NSObject{
    
    var delegate:HttpProtocal?
    
    func onSearch(url:NSString){
        var nsUrl:NSURL = NSURL(string: url)
        var request:NSURLRequest = NSURLRequest(URL: nsUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
            var jsonResult:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            self.delegate?.didReceiveResults(jsonResult)
            })
    }
}
