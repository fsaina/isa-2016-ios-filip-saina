import Foundation
import Unbox

/*
 * User data model returned by successfull Pokemon API
 * requests made to the servers.
 */
struct User: Unboxable {
    
    // authorization token returned by the server
    let authToken: String?
    
    // email of the user
    let email: String
    
    //username of the user
    let username: String
    
    // JSON data structure with variables
    init(unboxer: Unboxer) {
        authToken = unboxer.unbox("data.attributes.auth-token")
        email = unboxer.unbox("data.attributes.email")
        username = unboxer.unbox("data.attributes.username")
    }
    
}
