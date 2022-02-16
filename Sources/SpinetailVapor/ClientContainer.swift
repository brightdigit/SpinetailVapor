import Vapor

protocol ClientContainer {
  var client: Vapor.Client { get }
}

extension Vapor.Request: ClientContainer {}

extension Application: ClientContainer {}
