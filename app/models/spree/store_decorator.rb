Spree::Store.class_eval do 

  def show_newsletter_popup?(newsletter_cookie, current_user)
    return false unless self.show_newsletter_popup
    return false if current_user and !current_user.newsletter_subscriber?
    return true unless newsletter_cookie

    if current_user
      return newsletter_cookie < 7.days.ago
    else
      return newsletter_cookie < 24.hours.ago
    end
  end
end