note
	description: "Summary description for {SEARCH_PACKAGE_HANDLER}."
	author: ""
	date: "$Date: 2013-12-20 18:33:32 +0100 (ven., 20 déc. 2013) $"
	revision: "$Revision: 93781 $"

class
	SEARCH_PACKAGE_HANDLER

inherit
	WSF_URI_TEMPLATE_HANDLER

	IRON_NODE_HANDLER
		rename
			set_iron as make
		end

	WSF_SELF_DOCUMENTED_HANDLER

create
	make

feature -- Execution	

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			if req.is_get_request_method then
				if has_iron_version (req) then
					handle_search_package (req, res)
				else
					res.send (create {WSF_REDIRECTION_RESPONSE}.make (iron.page (Void, "/")))
				end
			else
				res.send (create {WSF_METHOD_NOT_ALLOWED_RESPONSE}.make (req))
			end
		end

	handle_search_package (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			s: detachable STRING
			lst: detachable LIST [IRON_NODE_VERSION_PACKAGE]
			html_vis: HTML_IRON_NODE_ITERATOR
			html: IRON_NODE_HTML_RESPONSE
			l_title: detachable READABLE_STRING_32
			l_found_count: INTEGER
			l_total_count: INTEGER
			kmp: KMP_WILD
		do
			html := new_response_message (req)

			if
				attached {WSF_STRING} req.query_parameter ("name") as l_searched_name and then
				not l_searched_name.is_empty
			then
				l_title := {STRING_32} "Search for name=%"" + l_searched_name.value + "%""
				lst := iron.database.version_packages (iron_version (req), 1, 0)
				if lst /= Void then
					l_total_count := lst.count
					create kmp.make_empty
					kmp.disable_case_sensitive
					kmp.set_pattern (l_searched_name.value)
					from
						lst.start
					until
						lst.after
					loop
						if attached lst.item.name as l_name then
							kmp.set_text (l_name)
--							if l_name.is_case_insensitive_equal_general (l_searched_name.value) then
							if kmp.pattern_matches then
								lst.forth
							else
								lst.remove
							end
						else
							lst.remove
						end
					end
					l_found_count := lst.count
				end
			elseif
				attached {WSF_STRING} req.query_parameter ("query") as l_search_query and then
				not l_search_query.is_empty
			then
				html.add_parameter (l_search_query.value, "search_query_text")
				html.add_parameter (iron.database.version_package_criteria_factory.description, "search_query_description")
				html.add_parameter (iron.database.version_package_criteria_factory.short_description, "search_query_short_description")
				l_title := {STRING_32} "Search for query=%"" + l_search_query.value + "%""
				l_total_count := iron.database.version_packages_count (iron_version (req))
				lst := iron.database.query_version_packages (l_search_query.value, iron_version (req), 1, 0)
				l_found_count := lst.count
			else
				lst := iron.database.version_packages (iron_version (req), 1, 0)
				if lst /= Void then
					l_total_count := lst.count
					l_found_count := lst.count
				end
			end
			create s.make_empty
			if lst /= Void then
				create html_vis.make (s, req, iron, iron_version (req))
				html_vis.set_user (current_user (req))
				html_vis.visit_package_version_iterable (lst)
			end

				-- Create new package
			if l_title /= Void then
				html.set_title (html.html_encoded_string (l_title))
			else
				html.set_title ("All packages (version " + iron_version (req).value + ")")
			end
			s.append ("<div>Found " + l_found_count.out + " out of " + l_total_count.out + " items.</div>")
			html.set_body (s)
			res.send (html)
		end

feature -- Documentation

	mapping_documentation (m: WSF_ROUTER_MAPPING; a_request_methods: detachable WSF_REQUEST_METHODS): WSF_ROUTER_MAPPING_DOCUMENTATION
			-- Documentation associated with Current handler, in the context of the mapping `m' and methods `a_request_methods'.
			--| `m' and `a_request_methods' are useful to produce specific documentation when the handler is used for multiple mapping.
		do
			create Result.make (m)
			Result.add_description ("List existing packages.")
		end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
