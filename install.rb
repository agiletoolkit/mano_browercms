# Page Comments Module for BrowserCMS

A simple comments module that can be embedded into pages to allow users to leave comments. It adds the following capabilities:

* A page comment block, which stores the user name, email, url and comment of public visitors.
* A comments portlet, which can be added to any template, and will record comments for that page.

## Installation
To install this module, do the following:

### A. Build and install the gem from source
This assumes you have the latest copy of the code from github on your machine.
1. gem build browsercms_page_comments_module.gemspec
2. sudo gem install browser_cms_page_comments_module-3.0.0.gem

At this point, the Page Comments gem should be installed as a gem on your system, and can be added to your projects.

### B. Adding the Page Comments to your project
In your BrowserCMS application, do the following steps.

#### 1. Edit the confing/environment.rb file

		config.gem 'browsercms'

		# Add this next line after the browsercms gem
		config.gem "browser_cms_page_comments_module"

#### 2. Edit the routes.rb file

		# Add this route. It must be before the core browser_cms route.
		map.routes_for_browser_cms_page_comments_module
		map.routes_for_browser_cms

#### 3. Install the new module code
From the root directory of your cms project, run:

		script/generate browser_cms

This will copy all the necessary views and migrations from the gems into your local project. You should messages checking to see if files already exist or were created.

script/generate browser_cms_demo_site

#### 4. Run migrations and start the server
Modules will often add new data types, like content blocks, so you need to run the migrations to add them to your project.

		rake db:migrate
		script/server

#### 5. Create a Comments portlet and embed into your templates
* Open your browser to localhost:3000/cms/portlets and login 
* Click 'Add New Content', and select 'Page Comments Portlet'
* Set the name to 'Page Comments' and click save.
* Now go to Administration -> Page Templates -> Sub Page -> Edit
* Add the following line to your template, somewhere in the body (preferably after your main content area)

		<%= render_portlet "Page Comments" %>

This will render embed the portlet named "Page Comments" into any page which uses the Sub Page template. 

* Now add a new page using the "Sub Page" template and you should see the comments form. Adding a new comment will display on that page.
