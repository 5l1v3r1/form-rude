
module FormRude
module Ui
module Console
module Operations

module HTTP

  class PostParser

    attr_reader :post   # The original post
    attr_reader :parse  # Full parsed post (header and body). Can take :headers, :body . @return [Hash]

    def initialize(post)
      @post  = post.dup
      @parse = [:headers => headers , :body => body , :full_post => [headers, body]]
    end

    #
    # Parsing post headers and @return [Hash] of of {header => value}
    #
    def headers
      post = @post
      post_header = post.split("\n")[0] # To solve split(":") issue in POST http://domain.com
      post_header       = post_header.split(" ", 2)

      headers_grep      = post.scan(/(.*:.*)[\n\r]/)

      headers = [{post_header[0] => post_header[1]}]
      headers_grep.map do |h|
        val = h[0].split(":", 2)
        val[1].strip!

        headers << {val[0] => val[1]}
      end

      return headers
    end

    #
    # Parsing post body and @return [Hash] of {variable => value}
    #
    def body
      post = @post
      body = []

      body_grep = post.split(/&/)[1..-1]
      body_grep.map do |var|
        val = var.split("=", 2)
        val[1].chomp if val.last
        val[1].strip!

        body << {val[0] => val[1]}
      end

      return body
    end

  end # PostParser

end # HTTP

end # Operations
end # Console
end # UI
end # FormRude
