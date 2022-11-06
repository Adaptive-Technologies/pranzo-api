Mjml.setup do |config|
  config.template_language = :erb # :erb (default), :slim, :haml, or any other you are using
   # Optimize the size of your emails
   config.beautify = false
   config.minify = true
 
   # Render MJML templates with errors
   config.validation_level = "soft"
end
