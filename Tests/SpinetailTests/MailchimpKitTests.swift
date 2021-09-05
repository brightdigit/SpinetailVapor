import Prch
@testable import Spinetail
import XCTest
final class SpinetailTests: XCTestCase {
  // swiftlint:disable:next cyclomatic_complexity function_body_length
  func testCampaign() throws {
    let exp = expectation(description: "post campaign")

    guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
      return
    }
    guard let api = MailchimpAPI(apiKey: apiKey) else {
      return
    }
    let client = APIClient(api: api, session: URLSession.shared)

    client.request(Templates.PostTemplates.Request(body: .init(
      html: "Hello World",
      name: "hello-world"
    ))) { result in
      guard let templateId = try? result.get().success?.id else {
        return
      }
      let request = Campaigns.PostCampaigns.Request(body:
        .init(
          type: .regular,
          contentType: .template,
          recipients: .init(
            listId: "6f357ca335"
          ),
          settings: .init(
            fromName: "Leo",
            replyTo: "leogdion+mailchimpdev@brightdigit.com",
            subjectLine: "Hello World",
            templateId: templateId
          )
        ))
      client.request(request) { result in
        switch result {
        case let .success(.status200(response)):
          guard let campaignId = response.id else {
            debugPrint("response: \(response)")
            break
          }
          client.request(
            Campaigns.PostCampaignsIdActionsSend.Request(campaignId: campaignId)
          ) { result in
            switch result {
            case .success(.status204):
              debugPrint("campaign sent")

            case let .success(.defaultResponse(statusCode: code, response)):
              debugPrint("status: \(response)")

            case let .failure(error):
              debugPrint("error: \(error)")
            }
            exp.fulfill()
          }
          return

        case let .success(.defaultResponse(statusCode: code, response)):
          debugPrint("status: \(response)")

        case let .failure(error):
          debugPrint("error: \(error)")
        }
        exp.fulfill()
      }
    }

    waitForExpectations(timeout: 20.0) { error in
      XCTAssertNil(error)
    }
  }

  func testExample() throws {
    let exp = expectation(description: "get members")
    var members: [Lists.GetListsIdMembers.Response.Status200.Members]?

    guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
      return
    }
    guard let api = MailchimpAPI(apiKey: apiKey) else {
      return
    }
    let client = APIClient(api: api, session: URLSession.shared)

    let request = Lists.GetListsIdMembers.Request(listId: "6f357ca335")

    client.request(request) { result in
      members = try? result.get().success?.members
      exp.fulfill()
    }

    waitForExpectations(timeout: 10.0) { error in
      XCTAssertNil(error)
      XCTAssertNotNil(members)

      guard let members = members else {
        return
      }

      XCTAssertNotNil(members.first)
      guard let member = members.first else {
        return
      }

      debugPrint(member.emailAddress)
    }
  }
}
