class UserMailer < ApplicationMailer
  default :from => 'info@wasaniimedia.com'

  def registration_confirmation(user)
    @user = user
    mail(:to => @user.email, :subject => "Registration Confirmation")
  end

  def password_reset(user)
    @user = user
    mail :to => @user.email, :subject => "Password Reset"
  end

  def admin_invitation(user, page)
    @user = user
    @name = if page.is_a?(Artist)
      page.profile_name
    else
      page.name
    end
    mail :to => @user.email, :subject => 'Invitation to admin artist page'
  end
end
