import ObjectMapper

class MusicTrackResponse: Mappable {
    var songs: [Song] = []

    func mapping(map: Map) {
        songs <- map["results"]
    }

    static func newInstance(map: Map) -> Mappable? {
        return MusicTrackResponse()
    }
    
    required convenience init?(_ map: Map) {
        self.init()
        mapping(map)
    }
}
