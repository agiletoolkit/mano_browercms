require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActionController::TestCase
  tests Cms::ContentController
  
  def setup
    create_baseline_data
  end
  
  def test_list_of_blog_posts
    get :show, :paths => ["/"]
    #log @response.body
    assert_response :success
    assert_select ".blog_post", 5
    
    assert_select "#blog_post_#{@first_post.id}" do
      assert_select "h2 a", "First Post"
      assert_select "p.body", "Yadda Yadda Yadda"
      assert_select "p.meta a", "General"
      assert_select "p.meta a", "0 Comments"
    end
    
    assert_select "#blog_post_#{@foo_post_1.id}" do
      assert_select "h2 a", "Foo #1"
      assert_select "p.body", "Foo 1 Foo 1 Foo 1"
      assert_select "p.meta .tags a", "foo"
      assert_select "p.meta .tags a", "stuff"
    end
  end
  
  def test_list_of_tagged_blog_posts
    get :show, :paths => ["/"], :category => "General"
    #log @response.body
    assert_response :success
    assert_select ".blog_post", 3
  end
  
  def test_list_of_categorized_blog_posts
    get :show, :paths => ["/"], :tag => "foo"
    #log @response.body
    assert_response :success
    assert_select ".blog_post", 2
  end
  
end