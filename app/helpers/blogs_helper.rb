module BlogsHelper

  
  def summarize(entries, num_chars)
    entries.map do |entry|
      if (entry.body.length() > num_chars)
        entry.body = summarize_body(entry.body, num_chars)
        # entry.body = summarize_body(entry.body, num_chars) + link_to("Read More", blog_post_path(entry.route_params))
      end
      entry
    end
  end
  
  private 
  def summarize_body(body, num_chars)
    body[0..num_chars].split()[0..-2].join(" ") + "..."
  end
  
end
