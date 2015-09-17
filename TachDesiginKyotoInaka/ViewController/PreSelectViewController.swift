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
    Tracks:5
    Playlists:5
*/

class PreSelectViewController: PagingViewController, PageControlDelegate {
    var samplePlaylistRepository: PlaylistRepository = PlaylistRepository()
    var historyPlaylistRepository: PlaylistRepository = PlaylistRepository()
    var myPlaylistRepository: PlaylistRepository = PlaylistRepository()
    var songs: [Song] = []
    var controller: PreSelectDataController?
    let manager = SongsManager.manager

    var pageControl: PageControl!
    var subPageControl: PageControl!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!

    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var exitButton: UIBarButtonItem!


    static let tabHeight: CGFloat = 60.0
    static let subTabHeight: CGFloat = 50.0
    let navigationBarHeight: CGFloat = 64.0

    //100->200

    //0ページ目になってる奴
    let largePage: [Int] = [0, 2, 4, 5]

    override func createDataController() -> PagingDataController {
        controller = PreSelectDataController(pageIdentities: self.pageData)
        return controller!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingView.frame = CGRectMake(0, 0, 100, 100)
        self.loadingView.layer.position = self.view.center
        self.loadingView.startAnimating()
        self.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.view.addSubview(self.loadingView)
        
        nextButton.target = self
        nextButton.action = "toReduceEight:"
        nextButton.enabled = false
        
        self.automaticallyAdjustsScrollViewInsets = false

        samplePlaylistRepository.fetchSongsWithTerm( "Alexandros", completion: { (playlists, songs) in
            self.historyPlaylistRepository.fetchSongsWithTerm("きゃりーぱみゅぱみゅ", completion: { (playlists, songs) in
               self.myPlaylistRepository.loadPlaylistsFormCache { playlists in
                self.loadingView.removeFromSuperview()
                self.nextButton.enabled = true

                self.songs = songs!
                self.pageData = [
                    self.samplePlaylistRepository.getPlaylists(),
                    self.samplePlaylistRepository.getSongs(),
                    self.historyPlaylistRepository.getPlaylists(),
                    self.historyPlaylistRepository.getSongs(),
                    self.myPlaylistRepository.getPlaylists(),
                    "search"
                ]
                self.createView()

                //TODO navigationBarの高さを取得する
                self.pageControl = PageControl(frame: CGRectMake(0, self.navigationBarHeight, self.view.frame.width, PreSelectViewController.tabHeight), mode: PageControl.SelectedViewType.bar)
                self.pageControl.setPages(["Favorite", "History", "My Playlists", "Search"])
                self.pageControl.setIdentity(0)
                self.pageControl.delegate = self
                self.pageControl.setFontSize(16, isBold: false)
                self.pageControl.backgroundColor = UIColor.colorFromRGB(ConstantShare.tabColorString, alpha: 1.0)
                self.view.addSubview(self.pageControl)

                self.subPageControl = PageControl(frame: CGRectMake(0, self.navigationBarHeight + 1 + PreSelectViewController.tabHeight, self.view.frame.width, PreSelectViewController.subTabHeight), mode: PageControl.SelectedViewType.triangle)
                self.subPageControl.setPages(["Playlists", "Tracks"])
                self.subPageControl.setFontSize(13, isBold: false)
                self.subPageControl.setIdentity(1)
                self.subPageControl.delegate = self
                self.view.addSubview(self.subPageControl)

                self.updateTab()
                }
            })
        })

        self.view.backgroundColor = UIColor.colorFromRGB(ConstantShare.backColorString, alpha: 1.0)

        self.trasitionStyle = UIPageViewControllerTransitionStyle.Scroll
        self.navigationOrientation = UIPageViewControllerNavigationOrientation.Horizontal

        exitButton.target = self
        exitButton.action = "exitButtonClicked:"
    }

    func exitButtonClicked(sender: UIBarButtonItem!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //ページのタブが押された時に移動させる
    func pageSelected(identity: Int, page: Int) {
        let currentPage = self.getCurrentPageIndex()
        println("\(identity),\(page)")
        //大カテゴリ
        var targetPage: Int! = nil
        if identity == 0 {
            targetPage = self.largePage[page]
        //小カテゴリ
        } else if identity == 1 {
            targetPage = getLargeCategory(currentPage) + page
            if (targetPage >= 5) {
                self.subPageControl.setCurrentPage(page)
                targetPage = 5
            }
        }
        if let target = targetPage {
            moveTargetPage(target)
        }
    }
    func getLargeCategoryIndex(page: Int) -> Int {
        var index = self.largePage.count - 1
        for i in self.largePage.reverse() {
            if page >= i {
                return index
            }
            index--
        }
        return 0
    }

    //大カテゴリの0ページ目を取得
    func getLargeCategory(page: Int) -> Int{
        return self.largePage[getLargeCategoryIndex(page)]
    }

    //特定のページヘ移動
    func moveTargetPage(targetPageTmp: Int) {
        var targetPage = targetPageTmp > 5 ? 5 : targetPageTmp
        if targetPage != self.getCurrentPageIndex() {
            let dataViewController: PageCellViewController = self.dataController.viewControllerAtIndex(targetPage)!
            let viewControllers: NSArray = NSArray(array: [dataViewController])
            let direction:UIPageViewControllerNavigationDirection = targetPage > self.getCurrentPageIndex() ? UIPageViewControllerNavigationDirection.Forward : UIPageViewControllerNavigationDirection.Reverse

            self.pageViewController?.setViewControllers(viewControllers as [AnyObject], direction: direction, animated: true, completion: {(Bool) -> Void in self.updateTab()})
            updateTab()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        manager.reset()

        var index = 0
        for indexes in controller!.selectedItemIndexes {
            let tmpDataList: AnyObject = self.pageData[index]
            let tmpDatas = map(indexes){ return tmpDataList[$0] }
            if !tmpDatas.isEmpty {
                //型判定
                if tmpDatas[0] is Playlist {
                    manager.appendPlaylists(tmpDatas as! [Playlist])
                } else {
                    manager.appendSongs(tmpDatas as! [Song])
                }
            }
            index++
        }
    }

    func toReduceEight(sender: AnyObject?) {
        self.performSegueWithIdentifier("toReduceEight", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateTab() {
        let currentPage = getCurrentPageIndex()
        let largeCategoryIndex = getLargeCategoryIndex(currentPage)

        //my playlist
        if largeCategoryIndex == 2 {
            self.subPageControl.hidden = true
        } else {
            self.subPageControl.hidden = false
        }

        //search
        if largeCategoryIndex == 3 {
            self.subPageControl.setPages(["Artists", "Playlists", "Tracks"])
            self.subPageControl.frame = CGRectMake(0, 64 + PreSelectViewController.tabHeight + 44, self.view.frame.width, PreSelectViewController.subTabHeight)
        } else {
            self.subPageControl.setPages(["Playlists", "Tracks"])
            self.subPageControl.frame = CGRectMake(0, 64 + 1 + PreSelectViewController.tabHeight, self.view.frame.width, PreSelectViewController.subTabHeight)
        }

        self.pageControl.setCurrentPage(largeCategoryIndex)
        if largeCategoryIndex == 3 {

        } else {
            self.subPageControl.setCurrentPage(currentPage - self.largePage[largeCategoryIndex])
        }
    }

    //ページ遷移アニメーション完了後
    override func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        //self.pageControl.currentPage = self.dataController.indexOfViewController(self.pageViewController!.viewControllers[0] as! PageCellViewController)
        updateTab()
    }

    func getCurrentPageIndex() -> Int! {
        return self.dataController.indexOfViewController(self.pageViewController!.viewControllers[0] as! PageCellViewController)
    }
}

//PagingDataControllerをオーバーライドしてDataControllerクラスを作成
class PreSelectDataController: PagingDataController {
    var selectedItemIndexes: [[Int]] = [[]]

    let titles = ["","","","","MyPlaylist","","",""]

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
        dataViewController.title = self.titles[index]


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

    func getSelectedItem(pageIndex: Int) -> [Int] {
        return self.selectedItemIndexes[pageIndex]
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
