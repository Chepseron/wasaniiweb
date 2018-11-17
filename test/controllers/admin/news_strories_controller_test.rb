require 'test_helper'

class Admin::NewsStoriesControllerTest < ActionDispatch::IntegrationTest
  test 'can move news_story from unpublished to published' do
    news_story = news_stories(:born)
    patch change_status_admin_news_story_path(news_story), params: {
      status: 'publish'
    }
    assert news_story.reload.published?
  end

  test 'can move news_story from unpublished to rejected' do
    news_story = news_stories(:born)
    patch change_status_admin_news_story_path(news_story), params: {
      status: 'reject'
    }
    assert news_story.reload.rejected?
  end

  test 'can move news_story from rejected to edited' do
    news_story = news_stories(:first_single)
    patch change_status_admin_news_story_path(news_story), params: {
      status: 'edit'
    }
    assert news_story.reload.edited?
  end

  test 'can move news_story from edited to rejected' do
    news_story = news_stories(:second_single)
    patch change_status_admin_news_story_path(news_story), params: {
      status: 'reject'
    }
    assert news_story.reload.rejected?
  end

  test 'can move news_story from edited to published' do
    news_story = news_stories(:second_single)
    patch change_status_admin_news_story_path(news_story), params: {
      status: 'publish'
    }
    assert news_story.reload.published?
  end
end
