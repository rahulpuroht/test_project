module Recaptcha

  def self.verify_google_recaptcha(captcha)
    begin
      response = `curl "https://www.google.com/recaptcha/api/siteverify?secret=#{Settings.google.recaptcha.private_key}&response=#{captcha}"`
      result = JSON.parse(response)
      return result["success"] == true ? true : false
    rescue Exception => e
      return false
    end
  end

end
