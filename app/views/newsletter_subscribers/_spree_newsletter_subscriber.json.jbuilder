json.extract! newsletter_subscriber, :id, :email, :active, :created_at, :updated_at
json.url newsletter_subscriber_url(newsletter_subscriber, format: :json)
