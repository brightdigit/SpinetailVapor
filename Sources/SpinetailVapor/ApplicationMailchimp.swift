
public protocol ApplicationMailchimp: Mailchimp {
  func configure(withAPIKey apiKey: String) throws
}
