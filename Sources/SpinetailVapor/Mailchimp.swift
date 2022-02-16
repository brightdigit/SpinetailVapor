import Prch
import PrchVapor
import Spinetail

public protocol Mailchimp {
  var client: Client<SessionClient, Spinetail.Mailchimp.API> { get }
}
