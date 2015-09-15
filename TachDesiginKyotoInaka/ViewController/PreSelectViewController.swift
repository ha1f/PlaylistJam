import Foundation
import UIKit


/**  
Favorite
    Playlists:0
    Tracks:1
History
    Playlists:2
    Tracks:3
MyPlaylist:4
search
    Artists:5
    Tracks:6
    Playlists:7
*/

class PreSelectViewController: PagingViewController, PageControlDelegate {
    var playlists: [Playlist] = []
    var songs: [Song] = []
    var controller: PreSelectDataController?
    let manager = SelectedSongsManager.manager
    
    var pageControl: PageControl!
    var subPageControl: PageControl!
    
    let tabHeight: CGFloat = 50.0
    let subTabHeight: CGFloat = 50.0
    
    override func createDataController() -> PagingDataController {
        controller = PreSelectDataController(pageIdentities: self.pageData)
        return controller!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPlaylistsAnd {
            self.pageData = [self.playlists, self.songs, self.playlists, self.songs, self.playlists, "search1", "search2", "search3"]
            self.createView()
            
            //TODO navigationBarの高さを取得する
            self.pageControl = PageControl(frame: CGRectMake(0, 64, self.view.frame.width, self.tabHeight))
            self.pageControl.setPages(["Favorite", "History", "My Playlists", "Search"])
            self.pageControl.setIdentity(0)
            self.pageControl.delegate = self
            self.view.addSubview(self.pageControl)
            
            self.subPageControl = PageControl(frame: CGRectMake(0, 65 + self.tabHeight, self.view.frame.width, self.subTabHeight))
            self.subPageControl.setPages(["Playlists", "Tracks"])
            self.subPageControl.setIdentity(1)
            self.subPageControl.delegate = self
            self.view.addSubview(self.subPageControl)
        }

        //self.view.backgroundColor = UIColor.whiteColor()
        self.trasitionStyle = UIPageViewControllerTransitionStyle.Scroll
        self.navigationOrientation = UIPageViewControllerNavigationOrientation.Horizontal

        var button: UIButton! = UIButton(frame: CGRectMake(0, 0, 200, 50))
        button.setTitle("button", forState: UIControlState.Normal)
        button.addTarget(self, action: "reduceEight:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func pageSelected(identity: Int, page: Int) {
        println("selected:\(identity),\(page)")
        let currentPage = 0
        //大カテゴリ
        var targetPage: Int! = nil
        if identity == 0 {
            switch(page) {
            case 0:
                targetPage = 0
                break
            case 1:
                targetPage = 2
                break
            case 2:
                targetPage = 4
                break
            case 3:
                targetPage = 5
                break
            default:
                break
            }
        } else if identity == 1 {
            targetPage = getLargeCategory(currentPage) + page
        }
        if let target = targetPage {
            moveTargetPage(target)
        }
    }
    func getLargeCategory(page: Int) -> Int{
        if page >= 5 {
            return 5
        } else if page >= 4 {
            return 4
        } else if page >= 2 {
            return 2
        } else {
            return 0
        }
    }
    
    //特定のページヘ移動
    func moveTargetPage(targetPage: Int) {
        let dataViewController: PageCellViewController = self.dataController.viewControllerAtIndex(targetPage)!
        let viewControllers: NSArray = NSArray(array: [dataViewController])
        let direction:UIPageViewControllerNavigationDirection = targetPage > self.getCurrentPageIndex() ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse
        
        self.pageViewController?.setViewControllers(viewControllers as [AnyObject], direction: direction, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        manager.reset()

        let favPlaylists = map(controller!.selectedItemIndexes[0]) { return self.playlists[$0] }
        manager.appendPlaylists(favPlaylists)

        let favSongs = map(controller!.selectedItemIndexes[1]) { return self.songs[$0] }
        manager.appendSongs(favSongs)

        let historySongs = map(controller!.selectedItemIndexes[2]) { return self.songs[$0] }
        manager.appendSongs(historySongs)
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
    
    //ページ遷移アニメーション完了後
    override func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        //self.pageControl.currentPage = self.dataController.indexOfViewController(self.pageViewController!.viewControllers[0] as! PageCellViewController)
        println("pageMoved:\(getCurrentPageIndex())")
    }
    
    func getCurrentPageIndex() -> Int! {
        return self.dataController.indexOfViewController(self.pageViewController!.viewControllers[0] as! PageCellViewController)
    }
}

//PagingDataControllerをオーバーライドしてDataControllerクラスを作成
class PreSelectDataController: PagingDataController {
    var selectedItemIndexes: [[Int]] = [[]]

    override func viewControllerAtIndex(index: Int) -> PageCellViewController? {
        super.viewControllerAtIndex(index)
        initIfNeed(0)

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let dataViewController: PageCellViewController!
        let sendData: AnyObject = self.pageProperty[index]

        // SongかPlaylistか判定してViewControllerを切り替え
        if let tmp = sendData[0] as? Song {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("SongListViewController") as! SongListViewController

        } else if let tmp = sendData[0] as? Playlist {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("PlaylistListViewController") as! PlaylistListViewController
        } else {
            dataViewController = storyboard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        }

        dataViewController.listen(self)
        dataViewController.setDataObject(sendData)
        dataViewController.setIndex(index)
        return dataViewController
    }

    func appendSelectedItem(pageIndex: Int, itemIndex: Int) {
        self.selectedItemIndexes[pageIndex].append(itemIndex)
        println(self.selectedItemIndexes)
    }

    func removeSelectedItem(pageIndex: Int, itemIndex: Int) {
        if let idx = find(self.selectedItemIndexes[pageIndex], itemIndex) {
            self.selectedItemIndexes[pageIndex].removeAtIndex(idx)
        }
        println(self.selectedItemIndexes)
    }

    func contain(pageIndex: Int, itemIndex: Int) ->  Bool {
        return contains(self.selectedItemIndexes[pageIndex], itemIndex)
    }

    private func initIfNeed(i: Int) {
        if self.selectedItemIndexes.count == 1 && self.selectedItemIndexes.first?.count == 0 {
            self.selectedItemIndexes = [[Int]](count: self.pageProperty.count, repeatedValue: [])
        }
    }
}
