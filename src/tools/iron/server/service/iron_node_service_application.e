note
	description : "Objects that ..."
	author      : "$Author: jfiat $"
	date        : "$Date: 2014-04-09 13:25:04 +0200 (mer., 09 avr. 2014) $"
	revision    : "$Revision: 94796 $"

class
	IRON_NODE_SERVICE_APPLICATION

create
	make,
	make_and_launch,
	make_from_iron_and_arguments

feature {NONE} -- Initialization

	make_and_launch
		do
			make
			launch
		end

	make
		do
			make_from_iron_and_arguments ((create {IRON_NODE_FACTORY}).iron_node, (create {ARGUMENTS_32}).argument_array)
		end

	make_from_iron_and_arguments (a_iron: IRON_NODE; args: ARRAY [READABLE_STRING_32])
		require
			args_has_index_0: args.lower = 0 and not args.is_empty
		do
			iron := a_iron
		end

feature {NONE} -- Access		

	iron: IRON_NODE

	connector: detachable READABLE_STRING_8

feature -- Execution

	launch
		local
			server: detachable IRON_NODE_SERVER
		do
			create server.make_and_launch (iron)
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
