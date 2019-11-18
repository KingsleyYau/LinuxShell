do
 local tcp_port_table = DissectorTable.get("tcp.port")
 local websocket_dissector = tcp_port_table:get_dissector(8080)
 for i,port in ipairs{3006} do
  tcp_port_table:add(port,websocket_dissector)
 end
end