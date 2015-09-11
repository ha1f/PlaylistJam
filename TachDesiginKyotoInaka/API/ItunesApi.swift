import ObjectMapper

class ItunesApi {
    static let domain = "http://ax.itunes.apple.com/"
    static let url = "\(domain)WebObjects/MZStoreServices.woa/wa/wsSearch"
    static let client = ApiClient()

    static func songs() {
        let params = ["term": "let", "country": "JP", "entity": "musicTrack"]

        client.get(url, parameters: params, completion: { (response: MusicTrackResponse?, error: NSError?) in
            if let songs = response?.songs {
                println(songs)
            }
        })
    }
}