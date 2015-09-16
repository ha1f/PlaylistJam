import UIKit

class MyPlaylistCollectionHeaderCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    var parent: HomeViewController! // for manage prayingList
    var index = -1    
}
