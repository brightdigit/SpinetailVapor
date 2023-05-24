import Prch
import PrchVapor
import Spinetail
import Vapor

class MailchimpClient: ApplicationMailchimp {
  internal init(application: ClientContainer, api: SpinetailAPI? = nil) {
    self.application = application
    self.api = api
  }

  public struct Key: StorageKey {
    public typealias Value = MailchimpClient
  }

  let application: ClientContainer
  var api: SpinetailAPI?

  public func configure(withAPIKey apiKey: String) throws {
    guard let api = SpinetailAPI(apiKey: apiKey) else {
      throw MailchimpError.invalidAPIKey(apiKey)
    }
    self.api = api
  }

  var client: any MailchimpService {
    guard let api = api else {
      fatalError("Mailchimp is not configured.")
    }

    
    return MailchimpServiceImpl(session: SessionClient(client: application.client), api: api)
  }

  func forRequest(_ request: Vapor.Request) -> Mailchimp {
    MailchimpClient(application: request, api: api)
  }
}
