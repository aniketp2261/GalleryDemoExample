//
//  HomeViewController.swift
//  GalleryDemoApp
//
//  Created by Aniket Patil on 24/01/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    
    var array = [DataModel]()
    var searchArray = [DataModel](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var isGrid = true, isList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APICALL()
        initViews()
    }
    private func initViews(){
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(filterData(textField:)), for: .editingChanged)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GridCVCell", bundle: nil), forCellWithReuseIdentifier: "GridCVCell")
        segmentedControl.addTarget(self, action: #selector(segmentControlClick(_:)), for: .valueChanged)
    }
    @objc func segmentControlClick(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            DispatchQueue.main.async {
                self.isGrid = true
                self.isList = false
                self.collectionView.reloadData()
            }
        case 1 :
            DispatchQueue.main.async {
                self.isGrid = false
                self.isList = true
                self.collectionView.reloadData()
            }
        default:
            break
        }
    }
    private func APICALL(){
        let request = URLRequest(url: URL(string: "https://api.unsplash.com/photos/?client_id=jvpdmE4hTVPAX5aRxMjB9m-pQyNbj2rCawlbzJ_O3CI")!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let parsedData = try? JSONDecoder().decode([DataModel].self, from: data) {
                        let dataArray = parsedData.sorted {($0.user?.name ?? "") < ($1.user?.name ?? "")} //sorted by ascending order
                        let newArray = dataArray.removeDuplicate{$0.user?.name ?? ""} //removed duplicates of name
                        self.array.append(contentsOf: newArray)
                        self.searchArray = self.array
                    } else {
                        print("Invalid Response")
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchArray.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCVCell", for: indexPath) as? GridCVCell{
            let data = array[indexPath.row]
            print("APIResponseName---\(data.user?.name ?? "")")
            if isGrid{
                cell.ListView.isHidden = true
                cell.GridView.isHidden = false
                cell.gridUserName.text = data.user?.name ?? ""
                cell.gridDesc.text = data.altDescription ?? ""
                cell.gridImg.loadFrom(data.urls?.small ?? "")
            } else{
                cell.ListView.isHidden = false
                cell.GridView.isHidden = true
                cell.listUserName.text = data.user?.name ?? ""
                cell.listDesc.text = data.altDescription ?? ""
                cell.listImg.loadFrom(data.urls?.small ?? "")
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        if isGrid{
            let noOfCellsInRow = 2
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                        + flowLayout.sectionInset.right
                        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: size)
        } else {
            return CGSize(width: screenWidth, height: 150)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = array[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageFullViewController") as? ImageFullViewController{
            vc.image = data.urls?.raw ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension HomeViewController : UITextFieldDelegate{
    @objc func filterData(textField: UITextField) {
        let searchText = textField.text ?? ""
        if searchText != "" && textField.text != nil {
            self.searchArray.removeAll()
            if self.array.count > 1 {
                for i in self.array {
                    if (i.user?.name ?? "").lowercased().contains(searchText.lowercased()) {
                        self.searchArray.append(i)
                    }
                }
            }
        } else {
            self.searchArray = array
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchTF.resignFirstResponder()
        return true
    }
    
}
