import Foundation
import class Prch.APIClient
import enum Prch.APIClientError
import class Prch.APIRequest
import protocol Prch.APIResponseValue
import enum Prch.APIResult
import protocol Prch.Response
import protocol Prch.Session
import protocol Prch.Task

import AsyncHTTPClient
import NIO
import NIOCore
import NIOHTTP1
import PrchVapor
import Spinetail
import Vapor

enum MailchimpError: Error {
  case invalidAPIKey(String)
}

public protocol Mailchimp {
  var client: APIClient<SessionClient> { get }
}

public extension Request {
  var mailchimp: Mailchimp {
    guard let mailchimp = application.storage[MailchimpImpl.Key.self] else {
      fatalError("Mailchimp is not configured.")
    }

    return mailchimp.forRequest(self)
  }
}

public protocol ApplicationMailchimp: Mailchimp {
  func configure(withAPIKey apiKey: String) throws
}

protocol ClientContainer {
  var client: Client { get }
}

extension Request: ClientContainer {}

extension Application: ClientContainer {}

class MailchimpImpl: ApplicationMailchimp {
  internal init(application: ClientContainer, api: MailchimpAPI? = nil) {
    self.application = application
    self.api = api
  }

  public struct Key: StorageKey {
    public typealias Value = MailchimpImpl
  }

  let application: ClientContainer
  var api: MailchimpAPI?

  public func configure(withAPIKey apiKey: String) throws {
    guard let api = MailchimpAPI(apiKey: apiKey) else {
      throw MailchimpError.invalidAPIKey(apiKey)
    }
    self.api = api
  }

  var client: APIClient<SessionClient> {
    guard let api = self.api else {
      fatalError("Mailchimp is not configured.")
    }

    return APIClient(api: api, session: SessionClient(client: application.client))
  }

  func forRequest(_ request: Request) -> Mailchimp {
    MailchimpImpl(application: request, api: api)
  }
}

public extension Application {
  var mailchimp: ApplicationMailchimp {
    guard let mailchimp = storage[MailchimpImpl.Key.self] else {
      let mailchimp = MailchimpImpl(application: self)
      storage[MailchimpImpl.Key.self] = mailchimp
      return mailchimp
    }
    return mailchimp
  }
}
