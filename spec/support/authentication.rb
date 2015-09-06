module AuthenticationHelper
  def sign_in_as(user)
    mock_auth_for(user)
    visit root_path
    click_link "Sign in with Github"
  end

  def mock_auth_for(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      "provider" => user.provider,
      "uid" => user.uid,
      "info" => {
        "nickname" => "",
        "email" => user.email,
        "name" => user.name,
        "image" => user.image,
        "urls" => {
          "GitHub" => "",
          "Blog" => nil
        }
      },
      "credentials" => {
        "token" => "1234",
        "expires" => false
      },
      "extra" => {
        "raw_info" => {
          "login" => "",
          "id" => user.uid.to_s,
          "avatar_url" => user.image,
          "gravatar_id" => "",
          "url" => "",
          "html_url" => "",
          "followers_url" => "",
          "following_url" => "",
          "gists_url" => "",
          "starred_url" => "",
          "subscriptions_url" => "",
          "organizations_url" => "",
          "repos_url" => "",
          "events_url" => "",
          "received_events_url" => "",
          "type" => "User",
          "site_admin" => false,
          "name" => user.name,
          "company" => nil,
          "blog" => nil,
          "location" => "",
          "email" => user.email,
          "hireable" => true,
          "bio" => nil,
          "public_repos" => 0,
          "public_gists" => 0,
          "followers" => 0,
          "following" => 0,
          "created_at" => "",
          "updated_at" => ""
        }
      }
    )
  end

  def mock_github_auth!
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      "provider" => "github",
      "uid" => "123456",
      "info" => {
        "nickname" => "jarlax",
        "email" => "jarlax@launchacademy.com",
        "name" => "Alex Jarvis",
        "image" => "https://avatars2.githubusercontent.com/u/174825?v=3&s=400",
        "urls" => {
          "GitHub" => "",
          "Blog" => nil
        }
      },
      "credentials" => {
        "token" => "1234",
        "expires" => false
      },
      "extra" => {
        "raw_info" => {
          "login" => "jarlax",
          "id" => 123456,
          "avatar_url" => "https://avatars2.githubusercontent.com/u/174825?v=3&s=400",
          "gravatar_id" => "",
          "url" => "",
          "html_url" => "",
          "followers_url" => "",
          "following_url" => "",
          "gists_url" => "",
          "starred_url" => "",
          "subscriptions_url" => "",
          "organizations_url" => "",
          "repos_url" => "",
          "events_url" => "",
          "received_events_url" => "",
          "type" => "User",
          "site_admin" => false,
          "name" => "Alex Jarvis",
          "company" => nil,
          "blog" => nil,
          "location" => "",
          "email" => "jarlax@launchacademy.com",
          "hireable" => true,
          "bio" => nil,
          "public_repos" => 0,
          "public_gists" => 0,
          "followers" => 0,
          "following" => 0,
          "created_at" => "",
          "updated_at" => ""
        }
      }
    )
  end

  def invalid_mock_github_auth!
    invalid_mock_auth = double("github_auth").tap do |auth|
      allow(auth).to receive(:provider).and_return("")
      allow(auth).to receive(:uid).and_return("")
    end

    OmniAuth.config.mock_auth[:github] = invalid_mock_auth
  end
end
