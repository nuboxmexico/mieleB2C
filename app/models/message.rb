class Message
	include ActiveModel::Model
	attr_accessor :name, :email,:to_email, :subject, :body
	validates :name, :email, :body, :subject, presence: true
end