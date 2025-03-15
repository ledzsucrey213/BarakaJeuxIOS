import Foundation

struct Game: Identifiable, Codable {
    var id: String
    var name: String
    var editor: String
    var description: String
    var count: Int
    
    init(id: String = "", name: String = "", editor: String = "", description: String = "", count: Int = 0) {
        self.id = id
        self.name = name
        self.editor = editor
        self.description = description
        self.count = count
    }
}

