# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	Markdown = RDiscount
	def box( *args, &block )
		options = args.extract_options!

		options[:location] ||= :right

		@box_options = options
		render( :layout => "shared/box", &block )
	end

	def shortcut_key( key, label )
		label.sub!( /#{key}/, "<span class=\"shortcut\">#{h key}</span>" );
		label
	end

	def menu_item( shortcut, label, options, *more )
		t = "<li"
		if( current_page?(options) ) then
			t.concat ' class="active"'
		end
		t.concat '>'
		t.concat link_to( shortcut_key( shortcut, label ), options, *more )
		t.concat "</li>"
		t
	end
end

class SiteDevError < Exception
end
