json.array! @mindlogs.try(:with_details) do |m,details|
	json.title details[:highlight].flatten[1]
end