module Oracle
	module Models
	  class StatsCommand < BaseCommand
		def list_required?
		  return false
		end
		
		def display_list?
		  return false
		end
	  end
	end
  end
  