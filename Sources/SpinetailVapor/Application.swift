import Vapor

public extension Application {
  var mailchimp: ApplicationMailchimp {
    guard let mailchimp = storage[MailchimpClient.Key.self] else {
      let mailchimp = MailchimpClient(application: self)
      storage[MailchimpClient.Key.self] = mailchimp
      return mailchimp
    }
    return mailchimp
  }
}
