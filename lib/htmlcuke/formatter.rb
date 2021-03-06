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
      modified_src = src
      modified_src = modified_src.split(',')
      modified_src = modified_src.drop(1) unless modified_src.size != 2
      modified_src = modified_src[0]
      @img_id += 1
      @builder.span(:class => 'embed') do |pre|
        pre << %{<a href="" onclick="img=document.getElementById('#{id}'); img.style.display = 'none'; window.open('#{modified_src}', '_blank');return false">#{label}</a><br>&nbsp;
        <img id="#{id}" style="display: none" src="#{modified_src}"/>} unless label == 'Screenshot' # if you want the image to show up on the same page change to: img.style.display = (img.style.display == 'none' ? 'block' : 'none')
      end
    end

    def before_features(features)
      @step_count = features && features.step_count || 0

      # <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
      @builder.declare!(
          :DOCTYPE,
          :html,
          :PUBLIC,
          '-//W3C//DTD XHTML 1.0 Strict//EN',
          'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'
      )

      @builder << '<html xmlns ="http://www.w3.org/1999/xhtml">'
      @builder.head do
        @builder.meta('http-equiv' => 'Content-Type', :content => 'text/html;charset=utf-8')
        @builder.title 'Cucumber'
        inline_css
        inline_js
      end
      @builder << '<body>'
      @builder << "<!-- Step count #{@step_count}-->"
      @builder << '<div class="cucumber">'
      @builder.div(:id => 'cucumber-header') do
        @builder.div(:id => 'label') do
        @builder.h1('Cucumber Features')
        end
        @builder.div(:id => 'summary') do
          @builder.p('',:id => 'totals')
          @builder.p('',:id => 'duration')
        end
      end
      @builder.div(:id => 'expand-collapse') do
        @builder.p('Hide Passing', :id => 'hide_passing', :class => 'hide_passing')
        @builder.p('Hide Failing', :id => 'hide_failing', :class => 'hide_failing')
        @builder.p('Hide Pending', :id=> 'hide_pending', :class => 'hide_pending')
      end
    end

    def inline_js_content
      <<-EOF

  SCENARIOS = "h3[id^='scenario_'],h3[id^=background_]";
  FAILED_SCENARIOS = "h3[style*='rgb(196, 13, 13)']";
  PENDING_SCENARIOS = "h3[style*='rgb(250, 248, 52)']";
  PASSED_SCENARIOS = "h3[style^='cursor:']";
  BACKGROUND_SCENARIOS = "h3[id^=background_]";
  var box_color = "#666"
  var button_color = "#2DB6CF"
  var hover_button_color = "#46b98a"
  var click_button_color = "#294A4F"
  var $box_style = "text-align: right; padding-bottom: 1em; background-color:" + box_color + "; background-position: initial initial; background-repeat: initial initial;";
  var $button_style = "margin-right: 1em; border: 0 none; border-radius: 6px 6px 6px 6px; color: #FFFFFF; cursor: pointer; display: inline-block; font-family: Arial,sans-serif; font-size: 12px; font-weight: bold; line-height: 20px; margin-bottom: 0; margin-top: 10px; padding: 7px 10px; text-transform: none; transition: all 0.3s ease 0s; -moz-transition: all 0.3s ease 0s; -webkit-transition: all 0.3s ease 0s; width: auto; text-align: center; background: none repeat scroll 0 0" + button_color + ";";
  var $hover_button_style = "margin-right: 1em; border: 0 none; border-radius: 6px 6px 6px 6px; color: #FFFFFF; cursor: pointer; display: inline-block; font-family: Arial,sans-serif; font-size: 12px; font-weight: bold; line-height: 20px; margin-bottom: 0; margin-top: 10px; padding: 7px 10px; text-transform: none; transition: all 0.3s ease 0s; -moz-transition: all 0.3s ease 0s; -webkit-transition: all 0.3s ease 0s; width: auto; text-align: center; background: none repeat scroll 0 0" + hover_button_color + ";";
  var $click_button_style = "margin-right: 1em; border: 0 none; border-radius: 6px 6px 6px 6px; color: #FFFFFF; cursor: pointer; display: inline-block; font-family: Arial,sans-serif; font-size: 12px; font-weight: bold; line-height: 20px; margin-bottom: 0; margin-top: 10px; padding: 7px 10px; text-transform: none; transition: all 0.3s ease 0s; -moz-transition: all 0.3s ease 0s; -webkit-transition: all 0.3s ease 0s; width: auto; text-align: center; background: none repeat scroll 0 0" + click_button_color + ";";

  $(document).ready(function() {
    $(SCENARIOS).css('cursor', 'pointer');
    $(SCENARIOS).click(function() {
      $(this).siblings().toggle(250);
    });

    $("#expand-collapse").attr("style", $box_style);

    $("#hide_pending").attr("style", $button_style);

    $("#hide_pending").hover(function() {
          $("#hide_pending").attr("style", $hover_button_style)}, function() {
          $("#hide_pending").attr("style", $button_style);
        });

    $("#hide_pending").click(function() {
      var $this = $(this);
      $this.toggleClass('hide_pending');
      if($this.hasClass('hide_pending')){
        $this.text('Hide Pending');
        $(PENDING_SCENARIOS).siblings().show();
        $this.hover(function() {
          $this.attr("style", $hover_button_style)}, function() {
          $this.attr("style", $button_style);
        });
      } else {
        $this.text('Show Pending');
        $(PENDING_SCENARIOS).siblings().hide();
         $this.hover(function() {
          $this.attr("style", $hover_button_style)}, function() {
          $this.attr("style", $click_button_style);
        });
      }
    });

    $("#hide_failing").attr("style", $button_style);

    $("#hide_failing").hover(function() {
      $("#hide_failing").attr("style", $hover_button_style)}, function() {
      $("#hide_failing").attr("style", $button_style);
    });

    $("#hide_failing").click(function() {
      var $this = $(this);
      $this.toggleClass('hide_failing');
      if($this.hasClass('hide_failing')){
        $this.text('Hide Failing');
        $(FAILED_SCENARIOS).siblings().show();
        $this.hover(function() {
          $this.attr("style", $hover_button_style)}, function() {
          $this.attr("style", $button_style);
        });
      } else {
        $this.text('Show Failing');
        $(FAILED_SCENARIOS).siblings().hide();
        $this.hover(function() {
          $this.attr("style", $hover_button_style)}, function() {
          $this.attr("style", $click_button_style);
        });
      }
    });

    $("#hide_passing").attr("style", $button_style);

    $("#hide_passing").hover(function() {
      $("#hide_passing").attr("style", $hover_button_style)}, function() {
      $("#hide_passing").attr("style", $button_style);
    });

    $("#hide_passing").click(function() {
      var $this = $(this);
      $this.toggleClass('hide_passing');
      if($this.hasClass('hide_passing')){
        $this.text('Hide Passing');
        $(PASSED_SCENARIOS).siblings().show();
        $this.hover(function() {
          $this.attr("style", $hover_button_style)}, function() {
          $this.attr("style", $button_style);
        });
      } else {
        $this.text('Show Passing');
        $(PASSED_SCENARIOS).siblings().hide();
        $this.hover(function() {
          $this.attr("style", $hover_button_style)}, function() {
          $this.attr("style", $click_button_style);
        });
      }
    });

  })

  function moveProgressBar(percentDone) {
    $("cucumber-header").css('width', percentDone +"%");
  }
  function makeRed(element_id) {
    $('#'+element_id).css('background', '#C40D0D');
    $('#'+element_id).css('color', '#FFFFFF');
  }
  function makeYellow(element_id) {
    $('#'+element_id).css('background', '#FAF834');
    $('#'+element_id).css('color', '#000000');
  }

      EOF
    end

  end
end
