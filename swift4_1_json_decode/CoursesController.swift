
import UIKit

class CoursesController: UITableViewController {

    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Course List"
        fetchJSON()
    }
    
    struct Course: Decodable {
        let id: Int
        let name: String
        let link: String
        
        let numberOfLessons: Int
        let imageUrl: String
        
        /* swift 4.0
        private enum CodingKeys: String, CodingKey {
            case imageUrl = "image_url"
            case numberOfLessons = "number_of_lessons"
            case id, name, link
        }*/
    }
    
    fileprivate func fetchJSON() {
        let urlString = "http://api.letsbuildthatapp.com/jsondecodable/courses_snake_case"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                   let decoder = JSONDecoder()
                    // Swift 4.1
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.courses = try decoder.decode([Course].self, from: data)
                    self.tableView.reloadData()
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.name
        print(course.name)
        cell.detailTextLabel?.text = String(course.numberOfLessons)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let currentCell = self.tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        let currentItem =  currentCell.textLabel!.text
        
        let alertController = UIAlertController(title: "Selection", message: "You Selected"+currentItem!, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}

