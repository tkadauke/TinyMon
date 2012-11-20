class HtmlViewController < UIViewController
  attr_accessor :html
  
  def initWithHTML(html, title:title)
    self.html = html
    self.title = title
    init
  end
  
  def viewDidLoad
    self.view = UIWebView.alloc.initWithFrame(navigationController.view.bounds)
    view.delegate = self
    
    reload_content
  end
  
  def webView(webView, shouldStartLoadWithRequest:request, navigationType:navigationType)
    url = request.URL
    if url.absoluteString == "about:blank"
      true
    else
      UIApplication.sharedApplication.openURL(url)
      false
    end
  end
  
  def content
    template = <<-end
      <html>
        <head>
          <title></title>
          <style>
            body {font-family: helvetica;}
            img {max-width: 100%;}
          </style>
        </head>
        <body>
          CONTENT
        </body>
      </html>
    end
    template.sub('CONTENT', html)
  end
  
  def reload_content
    view.loadHTMLString(content, baseURL:nil)
  end
end
