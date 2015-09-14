import ObjectMapper

class ItunesApi {
    static let domain = "http://ax.itunes.apple.com/"
    static let url = "\(domain)WebObjects/MZStoreServices.woa/wa/wsSearch"
    let client = ApiClient()
    static let api = ItunesApi()

    private init() {}

    func fetchSongs(completion: (songs: [Song]) -> Void) {
        let params = ["term": "sekai", "country": "JP", "entity": "musicTrack"]

        client.get(ItunesApi.url, parameters: params, completion: { (response: MusicTrackResponse?, error: NSError?) in
            if let songs = response?.songs {
                completion(songs: songs)
            }
        })

    }
}
