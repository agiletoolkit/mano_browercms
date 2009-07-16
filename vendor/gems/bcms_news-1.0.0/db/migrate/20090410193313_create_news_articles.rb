class CreateNewsArticles < ActiveRecord::Migration
  def self.up
    create_versioned_table :news_articles do |t|
      t.string :name 
      t.string :slug
      t.datetime :release_date 
      t.belongs_to :category 
      t.belongs_to :attachment
      t.integer :attachment_version 
      t.text :summary 
      t.text :body, :size => (64.kilobytes + 1) 
    end
    
    # Create the content type, category type and section for news
    ContentType.create!(:name => "NewsArticle", :group_name => "News")
    CategoryType.create!(:name => "News Article")
    news = Section.create!(:name => "News", 
      :path => "/news", 
      :parent => Section.root.first, 
      :group_ids => Group.all(&:id))      

    # Create the page to display the recent news
    overview = Page.create!(:name => "Overview", 
      :path => "/news/articles", 
      :section => news, 
      :template_file_name => "default.html.erb")
    RecentNewsPortlet.create!(:name => "Recent News Portlet", 
      :limit => 5, 
      :more_link => "/news/archive", 
      :template => RecentNewsPortlet.default_template,
      :connect_to_page_id => overview.id,
      :connect_to_container => "main")


    # Create the page to display the news archives
    archives = Page.create!(:name => "Archive", 
      :path => "/news/archive", 
      :section => news, 
      :template_file_name => "default.html.erb")
    NewsArchivePortlet.create!(:name => "News Archive Portlet", 
      :template => NewsArchivePortlet.default_template,
      :connect_to_page_id => archives.id,
      :connect_to_container => "main")

    # Create the page to display a given news article
    article = Page.create!(:name => "Article", 
      :path => "/news/article", 
      :section => news, 
      :template_file_name => "default.html.erb")
    NewsArticlePortlet.create!(:name => "News Article Portlet", 
      :template => NewsArticlePortlet.default_template,
      :connect_to_page_id => article.id,
      :connect_to_container => "main")

    # Create Page Route to article page
    route = article.page_routes.build(
      :name => "News Article",
      :pattern => "/news/articles/:year/:month/:day/:slug",
      :code => "@news_article = NewsArticle.released_on(params).with_slug(params[:slug]).first")
    route.add_condition(:method, "get")
    route.add_requirement(:year, '\d{4,}')
    route.add_requirement(:month, '\d{2,}')
    route.add_requirement(:day, '\d{2,}')
    route.save!
  end

  def self.down
    ContentType.delete_all(['name = ?', 'NewsArticle'])
    CategoryType.all(:conditions => ['name = ?', 'News Article']).each(&:destroy)
    drop_table :news_release_versions
    drop_table :news_releases
  end
end
