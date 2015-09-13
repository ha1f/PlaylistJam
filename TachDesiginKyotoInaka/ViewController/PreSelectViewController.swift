import Foundation
import UIKit

class PreSelectViewController: PagingViewController {
    var playlists: [Playlist] = []
    var songs: [Song] = []
    
    override func createDataController() -> PagingDataController {
        return PreSelectDataController(pageIdentities: self.pageData)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPlaylistsAnd {
            self.pageData = [self.playlists, self.songs, self.songs]
            self.createView()
        }

        self.view.backgroundColor = UIColor.whiteColor()
        self.trasitionStyle = UIPageViewControllerTransitionStyle.Scroll
        self.navigationOrientation = UIPageViewControllerNavigationOrientation.Horizontal

        var button: UIButton! = UIButton(frame: CGRectMake(0, 0, 200, 50))
        button.setTitle("button", forState: UIControlState.Normal)
        button.addTarget(self, action: "reduceEight:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }

    func reduceEight(sender: UIButton!) {
        self.performSegueWithIdentifier("reduceEight", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func fetchPlaylistsAnd(completion: (Void -> Void))  {
        SampleData().fetchDataAnd { (playlists, songs) in
            self.playlists = playlists
            self.songs = songs
            completion()
        }
    }
}

//PagingDataControllerをオーバーライドしてDataControllerクラスを作成
class PreSelectDataController: PagingDataController {
    var selectedItemIndexes: [[Int]] = [[]]

    override func viewControllerAtIndex(index: Int) -> PageCellViewController? {
        super.viewControllerAtIndex(index)

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let dataViewController: PageCellViewController!
        let sendData: AnyObject = self.pageProperty[index]

        // SongかPlaylistか判定してViewControllerを切り替え
        if let tmp = sendData[0] as? Song {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("SongListViewController") as! SongListViewController

        } else {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("PlaylistListViewController") as! PlaylistListViewController
        }

        dataViewController.listen(self)
        dataViewController.setDataObject(sendData)
        dataViewController.setIndex(index)
        return dataViewController
    }

    func appendSelectedItem(pageIndex: Int, itemIndex: Int) {
        initIfNeed(pageIndex)
        self.selectedItemIndexes[pageIndex].append(itemIndex)
        println(self.selectedItemIndexes)
    }

    func removeSelectedItem(pageIndex: Int, itemIndex: Int) {
        initIfNeed(pageIndex)
        if let idx = find(self.selectedItemIndexes[pageIndex], itemIndex) {
            self.selectedItemIndexes[pageIndex].removeAtIndex(idx)
        }
        println(self.selectedItemIndexes)
    }

    func contain(pageIndex: Int, itemIndex: Int) ->  Bool {
        initIfNeed(pageIndex)
        return contains(self.selectedItemIndexes[pageIndex], itemIndex)
    }

    private func initIfNeed(i: Int) {
        if self.selectedItemIndexes.count == 1 && self.selectedItemIndexes.first?.count == 0 {
            self.selectedItemIndexes = [[Int]](count: self.pageProperty.count, repeatedValue: [])
        }
    }
}