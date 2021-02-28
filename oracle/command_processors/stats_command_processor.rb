# frozen_string_literal: true

module Oracle
	module CommandProcessors
	  class StatsCommandProcessor < BaseCommandProcessor
  
		def child_process(result)
		  server_count = Oracle::Models::Server.count
		  last_server = Oracle::Models::Server.order("created_at desc").first
		  list_count = Oracle::Models::List.count
		  last_list = Oracle::Models::List.order("created_at desc").first
		  updated_list = Oracle::Models::List.order("updated_at desc").first
		  datetime_format = "%Y/%m/%d at %I:%M:%S %p"
		  command.event << "Servers:"
		  command.event << "  **# Servers:** #{server_count}"
		  command.event << "  **# Active:** #{Oracle::Models::Server.where("removed_on is null").count}"
		  command.event << "  **# Removed:** #{Oracle::Models::Server.where("removed_on is not null").count}"
		  command.event << "  **Last Added:** #{last_server.created_at.in_time_zone(ENV["BOT_OWNER_TIME_ZONE"]).strftime(datetime_format)}"
		  command.event << " "
		  command.event << "Lists:"
		  command.event << "  **# Lists:** #{list_count}"
		  command.event << "  **Last Added:** #{last_list.created_at.in_time_zone(ENV["BOT_OWNER_TIME_ZONE"]).strftime(datetime_format)}"
		  command.event << "  **Last Updated:** #{updated_list.updated_at.in_time_zone(ENV["BOT_OWNER_TIME_ZONE"]).strftime(datetime_format)}"
		end
	  end
	end
  end
  