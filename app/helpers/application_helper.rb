# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	Markdown = RDiscount
	def box( *args, &block )
		options = args.extract_options!

		if @location then
			 raise SiteDevError("@location is currently reserved for box() helper")
		end
		if @image then
			raise SiteDevError("@image is currently reserved for box() helper")
		end
		@location = options[:location] || :right
		@image = options[:image]
		render :layout => "shared/box" do
			yield
		end
		@location = nil
		@image = nil
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
