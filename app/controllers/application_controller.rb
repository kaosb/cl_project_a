class ApplicationController < ActionController::Base

	protect_from_forgery with: :exception
	before_action :authenticate_user!

	layout :layout_by_resource

	def send_email(key, subject, from_name, from_email, to_name, to_email, text, html)
		require 'mandrill'  
		m = Mandrill::API.new key
		message = {
			:subject => subject,
			:from_name => from_name,
			:from_email => from_email,
			:to =>[
				{
					:name => to_name,
					:email => to_email
				}
			],
			:text => text,
			:html => html,
			:headers => { "Reply-To" => "felipe@coddea.com" }
		}
		sending = m.messages.send message  
		return sending
	end

	protected

	def layout_by_resource
		if devise_controller? #&& resource_name == :user && action_name == "new"
			"login"
		else
			"application"
		end
	end
	
end
