//
//  FeedViewController.swift
//  Selfigram
//
//  Created by Liam Fahy on 2018-03-12.
//  Copyright © 2018 Liam Fahy. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var words = ["Hello", "My", "Name", "Is", "Selfiegram"]
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let me = User(aUsername: "danny", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//        let post0 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 0")
//        let post1 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 1")
//        let post2 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 2")
//        let post3 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 3")
//        let post4 = Post(image: UIImage(named: "Grumpy-Cat")!, user: me, comment: "Grumpy Cat 4")
        
        
//        posts = [post0, post1, post2, post3, post4]
        
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=c62234b3fc16c55831f6550461066246&tags=puppy")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void in
            if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []) {
                let json = jsonUnformatted as? [String : AnyObject]
                let photosDictionary = json?["photos"] as? [String : AnyObject]
                guard let photosArray = photosDictionary?["photo"] as? [[String : AnyObject]] else {
                    print("error")
                    return
                }
                
                
                for photo in photosArray {
                    
                    if let farmID = photo["farm"] as? Int,
                        let serverID = photo["server"] as? String,
                        let photoID = photo["id"] as? String,
                        let secret = photo["secret"] as? String {
                        
                        let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                        print(photoURLString)
                        if let photoURL = URL(string: photoURLString) {
                            
                            let me = User(aUsername: "Liam", aProfileImage: UIImage(named: "Grumpy-Cat")!)
                            let post = Post(imageURL: photoURL, user: me, comment: "A Flickr Selfie")
                            self.posts.append(post)
                        }
                    }
                    
                }
            
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                    
                }
                
            }else{
                print("error with response data")
            }
            
        })
        
        // this is called to start (or restart, if needed) our task
        task.resume()
        
        print ("outside dataTaskWithURL")

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SelfieCell
        // Configure the cell...
        let post = self.posts[indexPath.row]
      cell.selfieViewImage.image = nil
        
        let task = URLSession.shared.downloadTask(with: post.imageURL) { (url, response, error) -> Void in
        
            if let imageURL = url, let imageData = try? Data(contentsOf: imageURL) {
                OperationQueue.main.addOperation {
                    
                    cell.selfieViewImage.image = UIImage(data: imageData)
                }
            }
        }
        task.resume()

        
//        cell.selfieViewImage.image = post.image
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment
        
        return cell
    
     }

    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            pickerController.sourceType = .photoLibrary
        } else {
            pickerController.sourceType = .camera
            pickerController.cameraDevice = .front
            pickerController.cameraCaptureMode = .photo
        }
        
        self.present(pickerController, animated: true, completion: nil)
        
        
        print("Camera Button Pressed")
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //2. We create a Post object from the image
            let me = User(aUsername: "sam", aProfileImage: UIImage(named: "Grumpy-Cat")!)
//            let post = Post(image: image, user: me, comment: "My Selfie")
            
        }
        
        //3. We remember to dismiss the Image Picker from our screen.
        dismiss(animated: true, completion: nil)
        
     //4. We remember to dismiss the Image Picker from our screen.
    dismiss(animated: true, completion: nil)
    
    //5. Now that we have added a post, reload our table
    tableView.reloadData()

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
