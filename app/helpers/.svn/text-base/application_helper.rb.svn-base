module ApplicationHelper
  def title(page_title)
		content_for(:title) { page_title }
	end
	
	def cp(path)
  	"current" if current_page?(path)
	end
	
	def link_to_nav(name, path)
		link_to name, path, :class => cp(path)
	end
	
	def wrapper_id(id)
		content_for(:wrapper_id) { id }
	end
	
	def no_container()
	  content_for(:no_container) { true }
	end
end
