class Rack::Attack

  ### Configure Cache ###

  # If you don't want to use Rails.cache (Rack::Attack's default), then
  # configure it here.
  #
  # Note: The store is only used for throttling (not blocklisting and
  # safelisting). It must implement .increment and .write like
  # ActiveSupport::Cache::Store

  # Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 

  ### Throttle Spammy Clients ###

  # If any single client IP is making tons of requests, then they're
  # probably malicious or a poorly-configured scraper. Either way, they
  # don't deserve to hog all of the app server's CPU. Cut them off!
  #
  # Note: If you're serving assets through rack, those requests may be
  # counted by rack-attack and this throttle may be activated too
  # quickly. If so, enable the condition to exclude them from tracking.

  # Throttle all requests by IP (60rpm)
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:req/ip:#{req.ip}"
  
  # Exponential Backoff
  # Allows 20 requests in 8  seconds
  #        40 requests in 64 seconds
  #        ...
  #        100 requests in 0.38 days (~250 requests/day)
  # (1..5).each do |level|
  #   throttle("general/#{level}", :limit => (20 * level), :period => (8 ** level).seconds) do |req|
  #     req.ip
  #   end
  # end

  ### Prevent Brute-Force Login Attacks ###

  # The most common brute-force login attack is a brute-force password
  # attack where an attacker simply tries a large number of emails and
  # passwords to see if any credentials match.
  #
  # Another common method of attack is to use a swarm of computers with
  # different IPs to try brute-forcing a password for a specific account.

  # Throttle POST requests to /login by IP address
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/ip:#{req.ip}"
  # throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
  #   if req.path == '/login' && req.post?
  #     req.ip
  #   end
  # end

  # throttle('add/to/cart', limit: 1, period: 30.seconds) do |req|
  #   if (req.path == '/orders/populate' || req.path == '/orders/populate_ajax') && req.post?
  #     req.ip
  #   end
  # end

  # throttle("/users/sign_up", limit: 3, period: 15.minutes) do |req|
  #   # Using "vanilla" devise inside a User model
  #   req.ip if req.path == "/login" && req.post?
  # end

  # throttle("/users/sign_in", limit: 5, period: 15.minutes) do |req|
  #   # Using "vanilla" devise inside a User model
  #   if req.path == "/login" && req.get?
  #     req.ip 
  #   end
  # end

  # throttle("/coupon/form", limit: 1, period: 10.minutes) do |req|
  #   # Using "vanilla" devise inside a User model
  #   if req.path == "/orders/show_apply_coupon_form" && req.get?
  #     req.ip 
  #   end
  # end

  # Throttle POST requests to /login by email param
  #
  # Key: "rack::attack:#{Time.now.to_i/:period}:logins/email:#{normalized_email}"
  #
  # Note: This creates a problem where a malicious user could intentionally
  # throttle logins for another user and force their login requests to be
  # denied, but that's not very common and shouldn't happen to you. (Knock
  # on wood!)
  # throttle("logins/email", limit: 5, period: 20.seconds) do |req|
  #   if req.path == '/login' && req.post?
  #     # Normalize the email, using the same logic as your authentication process, to
  #     # protect against rate limit bypasses. Return the normalized email if present, nil otherwise.
  #     req.params['email'].to_s.downcase.gsub(/\s+/, "").presence
  #   end
  # end

  ### Custom Throttle Response ###

  # By default, Rack::Attack returns an HTTP 429 for throttled responses,
  # which is just fine.
  #
  # If you want to return 503 so that the attacker might be fooled into
  # believing that they've successfully broken your app (or you just want to
  # customize the response), then uncomment these lines.
  # self.throttled_response = lambda do |env|
  #  [ 503,  # status
  #    {},   # headers
  #    ['']] # body
  # end
end if Rails.env.production?