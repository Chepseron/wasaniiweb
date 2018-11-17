class ApplicationMailer < ActionMailer::Base
  add_template_helper(ArtistsHelper)

  default from: 'info@wasanii.com'
  layout 'mailer'
end
