module InvitationsHelper
	def format_status(status)
		status != '' && status || 'pending'
	end
end
