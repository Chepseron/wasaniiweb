class AdminMailer < ApplicationMailer

  default :from => 'noreply@wasanii.com'

  def registration_confirmation(admin, password)
    @admin = admin
    @password = password
    mail(:to => admin.email, :subject => "Registration Confirmation")
  end

  def reset_password(admin, password)
    @admin = admin
    @password = password
    mail(:to => admin.email, :subject => "Reset Password")
  end

  def submitted_for_review(entity)
    @entity = entity
    mail(:to => 'info@wasanii.com', :subject => "New Submission")
  end

  def new_artist_for_review(artist)
    @artist = artist
    @greeting = "Hi"

    mail(to: "info@wasanii.com", subject: "New Submission")
  end

  def edit_submitted_for_review(entity, changes)
    @entity = entity
    @changes = changes
    mail(:to => 'info@wasanii.com', :subject => "Edited Submission")
  end
end
