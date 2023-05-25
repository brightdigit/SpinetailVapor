import Prch
import PrchVapor
import Spinetail

public protocol Mailchimp {
  var client: any MailchimpService { get }
}
