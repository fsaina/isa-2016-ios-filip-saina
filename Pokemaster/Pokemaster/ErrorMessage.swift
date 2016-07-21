import Foundation
import Unbox

/*
 * User data model returned by unsuccessfull Pokemon API
 * requests made to the servers.
 */
struct ErrorMessage: Unboxable {
    
    //description of the error message
    let errorMessageDetail: String
    
    //source error
    let source: String
    
    // JSON data structure with variables
    // The only interesting part is the first error message - so that one is extracted
    init(unboxer: Unboxer) {
        errorMessageDetail = unboxer.unbox("errors.0.detail", isKeyPath: true)
        source = unboxer.unbox("errors.0.source.pointer", isKeyPath: true)
    }
    
}