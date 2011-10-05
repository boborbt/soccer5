module InvitationsHelper
	def format_invitation_status(status)
		status != '' && status || 'unspecified'
	end
end
