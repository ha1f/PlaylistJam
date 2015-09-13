import Foundation
import UIKit

/** 前段階の選択 */
class PreSelectViewController: PagingViewController {
    var playlists: [Playlist] = []
    var songs: [Song] = []

    override func createDataController() -> PagingDataController {
        return SongListViewDataController(pageIdentities: self.pageData)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        var button: UIButton! = UIButton(frame: CGRectMake(0,0,200,50))
        button.setTitle("button", forState: UIControlState.Normal)
        button.addTarget(self, action: "reduceEight:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)

        fetchPlaylistsAnd {
            self.pageData = [self.playlists, self.songs, self.songs]
            self.trasitionStyle = UIPageViewControllerTransitionStyle.Scroll
            self.navigationOrientation = UIPageViewControllerNavigationOrientation.Horizontal
            self.createView()
        }
    }

    func reduceEight(sender: UIButton!) {
        self.performSegueWithIdentifier("reduceEight", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
class SongListViewDataController: PagingDataController{
    //これだけは必ずオーバーライド
    override func viewControllerAtIndex(index: Int) -> PageCellViewController? {
        super.viewControllerAtIndex(index)

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let dataViewController: PageCellViewController!

        let sendData: AnyObject = self.pageProperty[index]

        //SongかPlaylistか判定してViewControllerを切り替え
        if let tmp = sendData[0] as? Song {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("SongListViewController") as! SongListViewController
        } else {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("PlaylistListViewController") as! PlaylistListViewController
        }

        dataViewController.setDataObject(sendData)//dataObjectをセット
        dataViewController.setIndex(index)//indexをセットしておく
        return dataViewController
    }
}