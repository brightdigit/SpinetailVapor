import Prch
import PrchVapor
import Spinetail
import Vapor

public protocol MailchimpService: ServiceProtocol
  where ServiceAPI == SpinetailAPI {}

class MailchimpServiceImpl: MailchimpService, Service {
  internal init(
    session: SessionClient,
    api: SpinetailAPI,
    authorizationManager: NullAuthorizationManager<SessionType.AuthorizationType>
      = NullAuthorizationManager<SessionType.AuthorizationType>()
  ) {
    self.session = session
    self.api = api
    self.authorizationManager = authorizationManager
  }

  let session: SessionClient
  let api: SpinetailAPI
  let authorizationManager: any SessionAuthenticationManager
}
