class SelectedSongsManager {
    static let manager = SelectedSongsManager()   // for Singleton
    var songs: [Song] = []

    private init() {}

    func setSongs(selectables: [Selectable]) {
        self.songs = flatMap(selectables, { return $0.selected() }) as! [Song]
    }

    func appendSongs(selectables: [Selectable]) {
        self.songs += flatMap(selectables, { return $0.selected() }) as! [Song]
    }

    func selectSongs(selectedIds: [Int]) {
        self.songs = map(selectedIds, { self.songs[$0] })
    }
}
