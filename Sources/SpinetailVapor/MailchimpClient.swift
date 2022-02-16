import Vapor
import Prch
import PrchVapor
import Spinetail

class MailchimpClient: ApplicationMailchimp {
  internal init(application: ClientContainer, api: Spinetail.Mailchimp.API? = nil) {
    self.application = application
    self.api = api
  }

  public struct Key: StorageKey {
    public typealias Value = MailchimpClient
  }

  let application: ClientContainer
  var api: Spinetail.Mailchimp.API?

  public func configure(withAPIKey apiKey: String) throws {
    guard let api = Spinetail.Mailchimp.API(apiKey: apiKey) else {
      throw MailchimpError.invalidAPIKey(apiKey)
    }
    self.api = api
  }

  var client: Prch.Client<SessionClient, Spinetail.Mailchimp.API> {
    guard let api = self.api else {
      fatalError("Mailchimp is not configured.")
    }

    return Client(api: api, session: SessionClient(client: application.client))
  }

  func forRequest(_ request: Vapor.Request) -> Mailchimp {
    MailchimpClient(application: request, api: api)
  }
}
