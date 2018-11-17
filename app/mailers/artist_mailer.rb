class ArtistMailer < ApplicationMailer
  default :from => 'info@wasaniimedia.com'

  def approved(entity)
    @entity = entity
    @user = if @entity.is_a?(Award)
      @entity.business.parent
    elsif @entity.parent.respond_to?(:email)
      @entity.parent
    else
      @entity.parent.parent
    end
    mail(:to => @user.email, :subject => "Artist Approved!")
  end

  def approved_with_changes(entity, changes)
    @entity = entity
    @user = if @entity.is_a?(Award)
      @entity.business.parent
    elsif
      @entity.parent.respond_to?(:email)
      @entity.parent
    else
      @entity.parent.parent
    end
    @changes = changes
    mail(:to => @user.email, :subject => "Artist Approved With Changes!")
  end

  def rejected(entity)
    @entity = entity
    @user = if @entity.is_a?(Award)
      @entity.business.parent
    elsif @entity.parent.respond_to?(:email)
      @entity.parent
    else
      @entity.parent.parent
    end
    mail(:to => @user.email, :subject => "Artist Rejected!")
  end

  def published(entity)
    @entity = entity
    @user = if @entity.is_a?(Award)
      @entity.business.parent
    elsif @entity.parent.respond_to?(:email)
      @entity.parent
    else
      @entity.parent.parent
    end
    mail(:to => @user.email, :subject => "Artist Published!")
  end
end
