import AVFoundation
import UIKit

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {
    var button: UIButton!
    var player: PlayerManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        createPlayers()
    }

    private func createPlayers() {
        ItunesApi.api.fetchSongs { (songs) in
            self.player = PlayerManager(songs: songs)
            self.player.play()

            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(), {
                    println("aaaaaaaaaaaaaaaa")
                    self.player.pause()

                    println("asdf")
                    self.player.nextTune()
            })

        }
    }
}