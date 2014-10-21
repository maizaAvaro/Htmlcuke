require 'cucumber/formatter/html'

  module Htmlcuke
    class Formatter < Cucumber::Formatter::Html

      def print_messages
        return if @delayed_messages.empty?

        @delayed_messages.each do |msg|
          @builder.li(:class => 'step message') do
            modified_msg = msg
            modified_msg.to_s.gsub!(/\[[0-9;]*m/, '') # Remove color codes from colorizer/puts for HTML format only
            @builder << modified_msg
          end
        end
        empty_messages
      end

      def embed_image(src, label)
        id = "img_#{@img_id}"
        @img_id += 1
        @builder.span(:class => 'embed') do |pre|
          pre << %{<a href="" onclick="img=document.getElementById('#{id}'); img.style.display = 'none'; window.open('file://#{src}', '_blank');return false">#{label}</a><br>&nbsp;
          <img id="#{id}" style="display: none" src="#{src}"/>} unless label == 'Screenshot' # if you want the image to show up on the same page change to: img.style.display = (img.style.display == 'none' ? 'block' : 'none')
        end
      end

    end
  end
