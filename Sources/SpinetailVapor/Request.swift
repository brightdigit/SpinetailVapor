import Vapor

public extension Vapor.Request {
  var mailchimp: Mailchimp {
    guard let mailchimp = application.storage[MailchimpClient.Key.self] else {
      fatalError("Mailchimp is not configured.")
    }

    return mailchimp.forRequest(self)
  }
}
