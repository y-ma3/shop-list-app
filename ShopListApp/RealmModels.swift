import Foundation
import RealmSwift

class Item: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name:String
}
